using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTranslate : MonoBehaviour
{
    [SerializeField] Camera cam;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Alpha1))
        {
            cam.transform.localPosition = new Vector3(0, 0, -300f);
        }
        if(Input.GetKeyDown(KeyCode.Alpha2))
        {
            cam.transform.localPosition = new Vector3(1000f, 0, -300f);
        }
        
    }
}
