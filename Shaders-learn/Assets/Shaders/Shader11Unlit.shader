Shader "NiksShaders/Shader11Unlit"
{
    Properties
    {
        _Color("Square Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.5
        _Size("Size", Float) = 0.3
        _AnchorSize("Anchor Size", Float) = 0.01
        _Anchor("Anchor", Vector) = (0.15, 0.15, 0, 0)
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
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                return o;
            }

            fixed4 _Color;
            float _Radius;
            float _Size;
            float _AnchorSize;
            float2 _Anchor;

            float2x2 getRotationMatrix(float radAngle)
            {
                float s = sin(radAngle);
                float c = cos(radAngle);
                return float2x2(c, -s, s, c);
            }
            
            float2x2 getScaleMatrix(float scale)
            {
               return float2x2(scale, 0, 0, scale);                         
            }
            
            float rect(float2 pt, float2 size, float2 center){
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                float2 p = pt - center;
                float2 halfsize = size/2.0;
                float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);
                return horz*vert;
            }
            
            float rect(float2 pt, float2 anchor, float2 size, float2 center){
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                float2 p = pt - center;
                float2 halfsize = size/2.0;
                float horz = step(-halfsize.x - anchor.x, p.x) - step(halfsize.x - anchor.x, p.x);
                float vert = step(-halfsize.y - anchor.y, p.y) - step(halfsize.y - anchor.y, p.y);
                return horz*vert;
            }

            float circle(float2 pt, float2 anchor, float size, float2 center){
                //return 0 if not in rect and 1 if it is
                //step(edge, x) 0.0 is returned if x < edge, and 1.0 is returned otherwise.
                float2 p = pt - center;
                // float halfsize = size/2.0;
                float inCircle = 1 - step(size, length(p.xy));
                return inCircle;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float2 center = float2(cos(_Time.y), sin(_Time.y)) * _Radius;
                float2 pos = i.position * 2.0;
                float2 size = _Size;

                float2x2 matr = getRotationMatrix(_Time.y);
                float2x2 mats = getScaleMatrix((sin(_Time.y) + 1) / 3 + 0.5);
                float2x2 mat = mul(matr, mats);
                
                float2 p = mul(mat, pos - center) + center;

                float3 color = saturate((i.position * 2 + 1) / 2) * rect(p, _Anchor.xy, size, center);
                color = lerp(color, fixed3(1,0,0), circle(p, _Anchor.xy, _AnchorSize, center));
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
