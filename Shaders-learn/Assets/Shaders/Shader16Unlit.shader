Shader "NiksShaders/Shader16Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1.0)
        _LineWidth("Line Width", Float) = 0.01
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
                float4 screenPos: TEXCOORD2;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }
           
            fixed4 _Color;
            float _LineWidth;

            float onLine(float a, float b, float line_width, float edge_thickness)
            {
                //check crossing point is within limits
                float half_line_width = line_width * 0.5;
                return smoothstep(a - half_line_width - edge_thickness, a - half_line_width, b)
                - smoothstep(a + half_line_width, a + half_line_width + edge_thickness, b);
            }
            
            float getDelta( float x ){
            	return (sin(x) + 1.0)/2.0;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.position * 2;
                
            	// float2 uv = i.screenPos.xy / i.screenPos.w;//get screen uv
            	float2 uv = i.uv;// * 2 - float2(1,1);

                //diagonal line
                // fixed3 color = lerp(fixed3(0,0,0), _Color.rgb, onLine(uv.x, uv.y, _LineWidth, _LineWidth * 0.1));
                // fixed3 color = _Color * onLine(pos.y, sin(pos.x * UNITY_PI), _LineWidth, _LineWidth * 0.01);
                // fixed3 color = _Color * onLine(pos.y, lerp(-0.4, 0.4, getDelta(pos.x * UNITY_PI)), _LineWidth, _LineWidth * 0.01);
                fixed3 color = _Color * onLine(uv.y, lerp(0.5, 0.8, getDelta(uv.x * UNITY_TWO_PI)), _LineWidth, _LineWidth * 0.01);
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
