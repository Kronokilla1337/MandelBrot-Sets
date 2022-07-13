using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;





public class SetChanger : MonoBehaviour
{
    [SerializeField]RawImage[] setImage;
    KeyCode currentKey;
    int lastImage;

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
            int a = (int)currentKey-48;
            if(a > 0&&a<setImage.Length+1)
            {
                Debug.Log(--a);
                ChangeRawImage(a);
            }
        }
    }
}
