using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Blit : MonoBehaviour
{
    public Material mat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat)
            Graphics.Blit(source, destination, mat);
    }
}
