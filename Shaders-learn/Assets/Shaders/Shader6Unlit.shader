Shader "NiksShaders/Shader6Unlit"
{
    Properties
    {
        _Size("Size", Range(0.0, 3)) = 0.2
        _Color0("Color 0", Color) = (1,1,1,1)
        _Color1("Color 1", Color) = (1,1,1,1)
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

            float _Size;
            fixed4 _Color0;
            fixed4 _Color1;

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
                // float inCircle = 1 - smoothstep(0.198, 0.2, length(i.position.xy));
                const float inCircle = 1 - step(_Size, length(i.position.xy));
                // const float inCircle = (1 - step(_Size, abs(i.position.x))) * (1 - step(_Size, abs(i.position.y)));

                fixed4 color = lerp(_Color0, _Color1, inCircle);
                return color;
            }
            ENDCG
        }
    }
}
