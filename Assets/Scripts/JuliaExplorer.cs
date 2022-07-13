using UnityEngine;
using System;
using System.Collections;

public class JuliaExplorer : MonoBehaviour
{
    [SerializeField] Material PracticeMat;
    [SerializeField] float scale;
    [SerializeField] float angle;
    [SerializeField] Vector2 pos;
    Vector2 smoothPos, seed, dir, seedScaled, smoothSeed;
    float scaleX;
    float scaleY;
    float aspect;
    float smoothScale, smoothAngle, sinAngle, cosAngle, mag;

    float scaleInput, angleInput;

    private void Start()
    {
        //pos = new Vector2(-1f, 0);
        scale = 2f;
    }
    void Update()
    {
        HandleInputs();
        UpdateShader();
    }
    private void HandleInputs()
    {
        //Inputs
        seed = Input.mousePosition;
        dir = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        seed.y /= Screen.height;
        seed.x /= Screen.width;
        seed.y -= 0.5f;
        seed.x -= 0.5f;

        scaleInput = Input.GetAxis("Zoom");
        angleInput = Input.GetAxis("Tilt");

        //Rotation
        sinAngle = Mathf.Sin(angle);
        cosAngle = Mathf.Cos(angle);
        seed = new Vector2(seed.x * cosAngle - seed.y * sinAngle, seed.x * sinAngle + seed.y * cosAngle);

        //Smoothing
        mag = dir.magnitude;
        dir.Normalize();
        dir *= mag * scale;

        //Scaling
        scale *= 1f - scaleInput / 5f * Time.deltaTime;
        angle += angleInput / 3f * Time.deltaTime;
        seedScaled = seed;
        pos += dir / 1000;
    }
    private void UpdateShader()
    {
        aspect = (float)Screen.width / Screen.height;
        smoothPos = Vector2.Lerp(pos, smoothPos, 0.03f*Time.deltaTime);
        smoothSeed = Vector2.Lerp(seedScaled, smoothSeed, 0.03f * Time.deltaTime);
        smoothScale = Mathf.Lerp(scale, smoothScale, 0.5f);
        smoothAngle = Mathf.Lerp(angle, smoothAngle, 0.5f);
        scaleX = smoothScale;
        scaleY = smoothScale;

        if (aspect > 1f)
            scaleY /= aspect;
        else
            scaleX *= aspect;
        PracticeMat.SetVector("_Area", new Vector4(smoothPos.x, smoothPos.y, scaleX, scaleY));
        PracticeMat.SetVector("_Seed", smoothSeed);
        PracticeMat.SetFloat("_Angle", smoothAngle);
    }
}
