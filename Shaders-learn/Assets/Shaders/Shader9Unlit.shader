Shader "NiksShaders/Shader9Unlit"
{
    Properties
    {
        _Mouse("Mouse", Vector) = (0,0,0,0)
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
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Mouse;
            float _Size;
            fixed4 _Color0;
            fixed4 _Color1;

            float rect(float2 pt, float2 size, float2 center){
                float2 p = pt - center;
                float2 halfsize = size * 0.5;

                float2 test = step(-halfsize, p) - step(halfsize, p);
                return test.x * test.y;
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                half2 pos = i.uv;
                float square = rect(pos, _Size, _Mouse.xy);
                
                return lerp(_Color0, _Color1, square);
            }
            ENDCG
        }
    }
}
