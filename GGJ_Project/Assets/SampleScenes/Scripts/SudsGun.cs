using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SudsGun : MonoBehaviour
{
        public int damagePerShot = 20;                  // The damage inflicted by each bullet.
        public float timeBetweenBullets = 0.15f;        // The time between each shot.
        public float range = 100f;                      // The distance the gun can fire.

        public GameObject Suds;
        ParticleSystem gunParticles;                    // Reference to the particle system.
        AudioSource gunAudio;                           // Reference to the audio source.
        float effectsDisplayTime = 0.2f;                // The proportion of the timeBetweenBullets that the effects will display for.
        Transform target;
        Vector3 targetPos;
        float smooth; // Kind like turn speed
        float speed; // Movement speed
        



    void Awake()
        {
           // Set up the references.
            gunParticles = GetComponent<ParticleSystem>();
            gunAudio = GetComponent<AudioSource>();
        }

        void Update()
        {
            // If the Fire1 button is being press and it's time to fire...
            if (Input.GetButton("Fire1"))
            {
                // ... shoot the gun.
                Shoot();
            }


        }

        void Shoot()
        {
            // Create projectile
            Instantiate(Suds);

            // Play the gun shot audioclip.
            gunAudio.Play();

           
            // Stop the particles from playing if they were, then start the particles.
            gunParticles.Stop();
            gunParticles.Play();

        }

   

}



