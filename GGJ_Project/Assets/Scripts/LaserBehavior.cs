﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserBehavior : MonoBehaviour
{

    public Transform m_muzzle;
	public GameObject m_shotPrefab;
    public float startingTime = 5;
    public float timer = 5f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;
        if (timer <= 0)
        {
            GameObject go = GameObject.Instantiate(m_shotPrefab, m_muzzle.position, m_muzzle.rotation) as GameObject;
            GameObject.Destroy(go, 3f);
            timer = startingTime;
        }
        
    }
}
