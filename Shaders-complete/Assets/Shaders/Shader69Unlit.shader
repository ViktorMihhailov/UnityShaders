﻿Shader "NiksShaders/Shader69Unlit"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
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

            sampler2D _MainTex;
            fixed4 _TintColor;
            
            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed3 renderTex = tex2D(_MainTex, i.uv).rgb;
                fixed3 grayScale = (renderTex.r + renderTex.g + renderTex.b) / 3;
                fixed3 tinted = grayScale * _TintColor;
                
                return fixed4(tinted, 1);

            }
            ENDCG
        }
    }
    FallBack off
}
