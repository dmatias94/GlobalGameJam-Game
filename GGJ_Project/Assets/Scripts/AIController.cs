using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIController : MonoBehaviour
{
    [SerializeField]
   public Transform Player;
     int MoveSpeed = 1;
     int MaxDist = 10;
     int MinDist = 5;
 
     GameObject bullet;

     public float firerate;
     public float nextfire;
 
 
     void Start()
     {
        firerate = 1f;
        nextfire = Time.time;
     }
 
     void Update()
     {
         transform.LookAt(Player);
 
         if (Vector3.Distance(transform.position, Player.position) >= MinDist)
         {
 
             transform.position += transform.forward * MoveSpeed * Time.deltaTime;
 
 
 
             if (Vector3.Distance(transform.position, Player.position) <= MaxDist)
             {
                 CheckIfTimeToFire();
             }
 
         }
     }

     
void CheckIfTimeToFire()
 {
        if (Time.time > nextfire)
    {
        Instantiate (bullet, transform.position, Quaternion.identity);
        nextfire = Time.time + firerate;
    }

 }

}



 

