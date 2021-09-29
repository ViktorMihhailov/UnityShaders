using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class TrackMouse : MonoBehaviour
{
    Material material;
    Vector4 mouse;
    Camera camera;

    // Start is called before the first frame update
    void Start()
    {
        Renderer rend = GetComponent<Renderer>();
        material = rend.sharedMaterial;
        mouse = new Vector4();
        mouse.z = Screen.height;
        mouse.w = Screen.width;
        camera = Camera.main;
    }

    void Update()
    {
        Ray ray = camera.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            mouse.x = hit.textureCoord.x;
            mouse.y = hit.textureCoord.y;
        }
        material.SetVector("_Mouse", mouse);
    }

    // Update is called once per frame
}
