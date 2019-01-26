using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CrayonPickup : MonoBehaviour
{
   public float speed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
           // Rotate the object around its local X axis at 1 degree per second
        transform.Rotate(Time.deltaTime, 2, 2);

        // ...also rotate around the World's Y axis
        transform.Rotate(2, Time.deltaTime, 2, Space.World);
    }
}
