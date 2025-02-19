﻿Shader "NiksShaders/Shader38Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
     
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
                float4 position: TEXCOORD1;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.position = v.vertex;
                return o;
            }

            sampler2D _MainTex;

            float2 rotate(float2 pt, float theta){
                float c = cos(theta);
                float s = sin(theta);
                float2x2 mat = float2x2(c,s,-s,c);
                return mul(pt, mat);
            }

            float4 frag (v2f i) : COLOR
            {
                fixed3 color = tex2D(_MainTex, i.uv).rgb;

                return fixed4( color, 1.0 );
            }
            ENDCG
        }
    }
}

