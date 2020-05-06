using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindowController : MonoBehaviour
{
    public Material window;
    public Transform target;
    public bool adjustPosition, adjustSize;

    private float startSize;
    private float startDistance;
    private Camera thisCamera;

    private void Awake()
    {
        thisCamera = GetComponent<Camera>();
    }

    private void Start()
    {
        startSize = window.GetFloat("_Size");
        startDistance = Vector3.Distance(transform.position, target.position);
    }

    private void Update()
    {
        if (target)
        {
            if (adjustPosition)
            {
                Vector3 viewportPos = thisCamera.WorldToViewportPoint(target.position);
                window.SetVector("_ScreenPosition", viewportPos);
            }

            if (adjustSize)
            {
                float distance = Vector3.Distance(transform.position, target.position);
                float ratio = startDistance / distance;
                window.SetFloat("_Size", startSize * ratio);
            }
        }
    }
}
