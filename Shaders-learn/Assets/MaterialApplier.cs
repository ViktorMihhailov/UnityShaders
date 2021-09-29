using UnityEngine;

public class MaterialApplier : MonoBehaviour
{
    [SerializeField] private Material Material;
    [SerializeField] private bool Update;
    

    private void OnValidate()
    {
        Renderer[] renderers = transform.GetComponentsInChildren<Renderer>();
        for (int i = 0; i < renderers.Length; i++)
        {
            renderers[i].material = Material;
        }
    }
}
