Shader "NiksShaders/Shader8Unlit"
{
    Properties
    {
        _Size("Size", Range(0.0, 3)) = 0.2
        _Color0("Color 0", Color) = (0,1,0,1)
        _Color1("Color 1", Color) = (1,1,0,1)
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

            float rect(float2 pt, float2 size, float2 center)
            {
                float2 p = pt - center;
                float2 halfsize = size * 0.5;
                //float horz = (p.x > -halfsize.x && p.x < halfsize.x) ? 1 : 0;
                //above is wrong, use step functions instead
                
                // float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                // float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);
                // return horz * vert;

                //more efficient step function than above
                float2 test = step(-halfsize, p) - step(halfsize, p);
                return test.x * test.y;

                //same as above, but maybe more effective?
                // return (1 - step(halfsize.x, abs(p.x))) * (1 - step(halfsize.y, abs(p.y)));
            }
            
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
                float2 pos = i.position.xy;
                float2 size = float2(0.25, 0.5);
                float2 right = float2(0.4 - size.x + size.x * 0.5, 0);
                float2 left = float2(-0.4 + size.x * 0.5, 0);
                float2 center = lerp(left, right, step(0, pos.x));
                
                float inRect = rect(pos, size, center);
                
                fixed4 color = lerp(_Color0, _Color1, inRect);
                return color;
            }
            ENDCG
        }
    }
}
