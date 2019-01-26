
Shader "SwordMaster/PencilSketchShader"
{
	Properties
	{
		_MainColor("Main Color",Color) = (1,1,1,1)
		_OutlineColor("Outline Color",Color) = (0,0,0,1)
		_OutlineWidth("Outline Width",Range(0,1)) = 0.1
		_PencilSketchDensity("PencilSketch Density",Float) = 1
		_PencilSketchTexture0 ("PencilSketch Texture 0", 2D) = "white" {}
		_PencilSketchTexture1 ("PencilSketch Texture 1", 2D) = "white" {}
		_PencilSketchTexture2 ("PencilSketch Texture 2", 2D) = "white" {}
		_PencilSketchTexture3 ("PencilSketch Texture 3", 2D) = "white" {}
		_PencilSketchTexture4 ("PencilSketch Texture 4", 2D) = "white" {}
		_PencilSketchTexture5 ("PencilSketch Texture 5", 2D) = "white" {}

	}
	SubShader
	{
		Tags {"Queue"= "Geometry"  "RenderType"="Opaque" }

		Pass
		{
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			float4 _OutlineColor;
			fixed _OutlineWidth;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;

				float4 viewSpaceVertex = mul(UNITY_MATRIX_MV, v.vertex);

				float3 viewSpaceNormal = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);

				viewSpaceNormal.z = -0.5;

				viewSpaceNormal = normalize(viewSpaceNormal);

				viewSpaceVertex = viewSpaceVertex + float4(viewSpaceNormal,0) * _OutlineWidth;

				o.pos = mul(UNITY_MATRIX_P,viewSpaceVertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(_OutlineColor.rgb, 1);

				return col;
			}
			ENDCG
		}


		Pass
		{
			Tags { "LightMode"="ForwardBase" }

			Cull Back

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			float4 _MainColor;
			sampler2D _PencilSketchTexture0;
			sampler2D _PencilSketchTexture1;
			sampler2D _PencilSketchTexture2;
			sampler2D _PencilSketchTexture3;
			sampler2D _PencilSketchTexture4;
			sampler2D _PencilSketchTexture5;
			float _PencilSketchDensity;


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 worldSpaceVertexPosition : TEXCOORD0;
				float2 uv: TEXCOORD1;
				fixed3 pencilSketchWeights0 : TEXCOORD2;
				fixed3 pencilSketchWeights1 : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldSpaceVertexPosition = mul(unity_ObjectToWorld,v.vertex);

				half3 worldSpaceNormalDir = normalize(UnityObjectToWorldNormal(v.normal));

				half3 worldSpaceLightDir = normalize(WorldSpaceLightDir(v.vertex));

				half diffuse = max(0,dot(worldSpaceNormalDir,worldSpaceLightDir));

				half pencilSketchFactor = diffuse * 7.0;


				if(pencilSketchFactor > 6.0)
				{
					o.pencilSketchWeights0.x = 0.0;
					o.pencilSketchWeights0.y = 0.0;
					o.pencilSketchWeights0.z = 0.0;
					o.pencilSketchWeights1.x = 0.0;
					o.pencilSketchWeights1.y = 0.0;
					o.pencilSketchWeights1.z = 0.0;
				}
				else if(pencilSketchFactor > 5.0)
				{
					o.pencilSketchWeights0.x = pencilSketchFactor - 5.0;
					o.pencilSketchWeights0.y = 0.0;
					o.pencilSketchWeights0.z = 0.0;
					o.pencilSketchWeights1.x = 0.0;
					o.pencilSketchWeights1.y = 0.0;
					o.pencilSketchWeights1.z = 0.0;

				}
				else if(pencilSketchFactor > 4.0)
				{
					o.pencilSketchWeights0.x = pencilSketchFactor - 4.0;
					o.pencilSketchWeights0.y = 1.0 - o.pencilSketchWeights0.x;
					o.pencilSketchWeights0.z = 0.0;
					o.pencilSketchWeights1.x = 0.0;
					o.pencilSketchWeights1.y = 0.0;
					o.pencilSketchWeights1.z = 0.0;
				}
				else if(pencilSketchFactor > 3.0)
				{
					o.pencilSketchWeights0.x = 0.0;
					o.pencilSketchWeights0.y = pencilSketchFactor - 3.0;
					o.pencilSketchWeights0.z = 1.0 - o.pencilSketchWeights0.y;
					o.pencilSketchWeights1.x = 0.0;
					o.pencilSketchWeights1.y = 0.0;
					o.pencilSketchWeights1.z = 0.0;
				}
				else if(pencilSketchFactor > 2.0)
				{
					o.pencilSketchWeights0.x = 0.0;
					o.pencilSketchWeights0.y = 0.0;
					o.pencilSketchWeights0.z = pencilSketchFactor - 2.0;
					o.pencilSketchWeights1.x = 1.0 - o.pencilSketchWeights0.z;
					o.pencilSketchWeights1.y = 0.0;
					o.pencilSketchWeights1.z = 0.0;
				}
				else if(pencilSketchFactor > 1.0)
				{
					o.pencilSketchWeights0.x = 0.0;
					o.pencilSketchWeights0.y = 0.0;
					o.pencilSketchWeights0.z = 0.0;
					o.pencilSketchWeights1.x = pencilSketchFactor - 1.0;
					o.pencilSketchWeights1.y = 1.0 - o.pencilSketchWeights1.x;
					o.pencilSketchWeights1.z = 0.0;
				}
				else
				{
					o.pencilSketchWeights0.x = 0.0;
					o.pencilSketchWeights0.y = 0.0;
					o.pencilSketchWeights0.z = 0.0;
					o.pencilSketchWeights1.x = 0.0;
					o.pencilSketchWeights1.y = pencilSketchFactor;
					o.pencilSketchWeights1.z = 1.0 - o.pencilSketchWeights1.y;
				}

				o.uv = v.texcoord.xy * _PencilSketchDensity;

				TRANSFER_SHADOW(o)

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 pencilSketchTex0 = tex2D(_PencilSketchTexture0,i.uv) * i.pencilSketchWeights0.x;
				fixed4 pencilSketchTex1 = tex2D(_PencilSketchTexture1,i.uv) * i.pencilSketchWeights0.y;
				fixed4 pencilSketchTex2 = tex2D(_PencilSketchTexture2,i.uv) * i.pencilSketchWeights0.z;
				fixed4 pencilSketchTex3 = tex2D(_PencilSketchTexture3,i.uv) * i.pencilSketchWeights1.x;
				fixed4 pencilSketchTex4 = tex2D(_PencilSketchTexture4,i.uv) * i.pencilSketchWeights1.y;
				fixed4 pencilSketchTex5 = tex2D(_PencilSketchTexture5,i.uv) * i.pencilSketchWeights1.z;

				fixed4 whiteColor = fixed4(1.0,1.0,1.0,1.0) * (1.0 - i.pencilSketchWeights0.x - i.pencilSketchWeights0.y - i.pencilSketchWeights0.z
														 - i.pencilSketchWeights1.x - i.pencilSketchWeights1.y - i.pencilSketchWeights1.z);

			    fixed4 pencilSketchColor = pencilSketchTex0 + pencilSketchTex1 + pencilSketchTex2 + pencilSketchTex3 + pencilSketchTex4 + pencilSketchTex5 + whiteColor;

				UNITY_LIGHT_ATTENUATION(atten,i,i.worldSpaceVertexPosition.xyz);
															
				return fixed4(_MainColor.rgb * pencilSketchColor.rgb * atten,1.0);
			}
			ENDCG
		}
	}

	FallBack "Diffuse"
}
