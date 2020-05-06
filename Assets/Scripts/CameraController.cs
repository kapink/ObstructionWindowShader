using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target;
    public Vector3 positionOffset = new Vector3(0, 2, -5);

    public bool position, rotation;

    private void Start()
    {
        if (target)
        {
            Move();
            Look();
        }
    }

    private void LateUpdate()
    {
        if (target)
        {
            Move();
            Look();
        }
    }

    private void Move()
    {
        if(position)
            transform.position = target.position + positionOffset;
    }

    private void Look()
    {
        if(rotation)
            transform.LookAt(target);
    }
}
