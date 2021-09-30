Shader "NiksShaders/Shader14Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.3
        _Smooth("Smooth", Float) = 0.02
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
            float _Smooth;

            float circle(float2 pt, float radius, float2 center){
                float2 p = pt - center;
                return 1 - step(radius, length(p.xy));
            }

            float circleSmooth(float2 pt, float radius, float2 center){
                float2 p = pt - center;
                return 1 - smoothstep(radius - _Smooth, radius, length(p.xy));
            }

            float circleOutline(float2 pt, float radius, float2 center, float outline_width){
                float2 p = pt - center;
                const float len = length(p.xy);
                
                return step(radius - outline_width, len) - step(radius, len);
            }

            float circleOutlineSmooth(float2 pt, float radius, float2 center, float outline_width){
                float2 p = pt - center;
                const float len = length(p.xy);
                float half_width = outline_width * 0.5;
                return 1 - smoothstep(radius - half_width, radius + half_width, len) - (1 - step(radius - half_width, len)) - step(radius + half_width, len);
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.uv;
                float inCircle = circle(pos, _Radius, 0.5);
                fixed3 color = _Color * inCircle;
                // color = lerp(color, fixed3(1,1,1), step(0.000001, inCircle) - step(1, inCircle)); //outline 1
                // color = lerp(color, fixed3(1,1,0), circleOutline(pos, _Radius, 0.5, _Radius * 0.01)); //outline 2
                color = lerp(color, fixed3(1,1,1), circleOutlineSmooth(pos, _Radius, 0.5, _Radius * 0.1));//smooth outline
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
