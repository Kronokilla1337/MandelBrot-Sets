using UnityEngine;
using System;
using System.Collections;

public class PracticeExplorer : MonoBehaviour
{
    [SerializeField] Material PracticeMat;
    [SerializeField] float scale;
    [SerializeField] float angle;
    [SerializeField] Vector2 pos;
    Vector2 smoothPos, dir;
    float scaleX;
    float scaleY;
    float aspect;
    float smoothScale, smoothAngle, sinAngle, cosAngle, mag;

    float scaleInput, angleInput;

    private void Start()
    {
        //pos = new Vector2(-1f, 0);
        scale = 10f;
    }
    void Update()
    {
        HandleInputs();
        UpdateShader();
    }
    private void HandleInputs()
    {
        //Inputs
        dir = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        scaleInput = Input.GetAxis("Zoom");
        angleInput = Input.GetAxis("Tilt");

        //Rotation
        sinAngle = Mathf.Sin(angle);
        cosAngle = Mathf.Cos(angle);
        dir = new Vector2(dir.x * cosAngle - dir.y * sinAngle, dir.x * sinAngle + dir.y * cosAngle);
        
        //Smoothing
        mag = dir.magnitude;
        dir.Normalize();
        dir *= mag*scale;

        //Scaling
        pos += dir/1000;
        scale *= 1f - scaleInput / 5f * Time.deltaTime;
        angle += angleInput / 3f * Time.deltaTime;
    }
    private void UpdateShader()
    {
        aspect = (float)Screen.width /Screen.height;
       
        smoothPos = Vector2.Lerp(pos, smoothPos, 0.03f);
        smoothScale = Mathf.Lerp(scale, smoothScale, 0.5f);
        smoothAngle = Mathf.Lerp(angle, smoothAngle, 0.5f);
        scaleX = smoothScale;
        scaleY = smoothScale;

        if (aspect > 1f)
            scaleY /= aspect;
        else
            scaleX *= aspect;
        PracticeMat.SetVector("_Area", new Vector4(smoothPos.x, smoothPos.y, scaleX, scaleY));
        PracticeMat.SetFloat("_Angle", smoothAngle);
    }
}
