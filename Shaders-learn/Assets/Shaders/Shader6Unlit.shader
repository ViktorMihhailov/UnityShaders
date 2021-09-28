Shader "NiksShaders/Shader6Unlit"
{
    Properties
    {
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
                float4 position: TEXCOORD1;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                const fixed len = length(i.position.xy);
                
                fixed3 color = i.position * 2;
                color.r = 1 - smoothstep(0.098, 0.1, len);
                color.g = 1 - smoothstep(0.098, 0.1, len);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
