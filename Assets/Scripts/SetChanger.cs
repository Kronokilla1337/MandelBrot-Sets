using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;





public class SetChanger : MonoBehaviour
{
    [SerializeField]RawImage[] setImage;
    KeyCode currentKey;
    int lastImage;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {


    }

    void ChangeRawImage(int setNum)
    {
        if(lastImage == setNum)
        {
            return;
        }       
        setImage[lastImage].enabled = false;
        setImage[setNum].enabled = true;
        lastImage = setNum;

    }

    void OnGUI()
    {
        Event e = Event.current;
        if (e.isKey)
        {
            currentKey = e.keyCode;
            int a = (int)currentKey-49;
            if(a >= 0&&a<54)
            {
                Debug.Log(a);
                ChangeRawImage(a);
            }
        }
    }
}
