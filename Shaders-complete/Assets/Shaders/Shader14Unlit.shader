﻿Shader "NiksShaders/Shader14Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.3
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
                float4 position : TEXCOORD1;
                float2 uv: TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }
           
            fixed4 _Color;
            float _Radius;
            
            float circle(float2 pt, float2 center, float radius, float edge_thickness){
                float2 p = pt - center;
                float len = length(p);
                float result = 1.0-smoothstep(radius-edge_thickness, radius, len);

                return result;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.position * 2;
                fixed3 color = _Color * circle(pos, float2(0,0), _Radius, 0.002);
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
