Shader "Unlit/Color"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            float3 pal(in float t, in float3 a, in float3 b, in float3 c, in float3 d)
            {
                return a + b * cos(6.28318 * (c * t + d));
            }

            void mainImage(out float4 fragColor, in float2 fragCoord)
            {
                float2 p = fragCoord.xy

                // animate
                p.x += 0.01 * iTime;

                // compute colors
                float3 col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1.0, 1.0, 1.0), float3(0.0, 0.33, 0.67));
                if (p.y > (1.0 / 7.0)) col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1.0, 1.0, 1.0), float3(0.0, 0.10, 0.20));
                if (p.y > (2.0 / 7.0)) col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1.0, 1.0, 1.0), float3(0.3, 0.20, 0.20));
                if (p.y > (3.0 / 7.0)) col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1.0, 1.0, 0.5), float3(0.8, 0.90, 0.30));
                if (p.y > (4.0 / 7.0)) col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1.0, 0.7, 0.4), float3(0.0, 0.15, 0.20));
                if (p.y > (5.0 / 7.0)) col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(2.0, 1.0, 0.0), float3(0.5, 0.20, 0.25));
                if (p.y > (6.0 / 7.0)) col = pal(p.x, float3(0.8, 0.5, 0.4), float3(0.2, 0.4, 0.2), float3(2.0, 1.0, 1.0), float3(0.0, 0.25, 0.25));


                // band
                float f = frac(p.y * 7.0);
                // borders
                col *= smoothstep(0.49, 0.47, abs(f - 0.5));
                // shadowing
                col *= 0.5 + 0.5 * sqrt(4.0 * f * (1.0 - f));
                // dithering
                col += (1.0 / 255.0) * tex2d(iChannel0, fragCoord.xy / iChannelResolution[0].xy).xyz;

                fragColor = float4(col.x, col.y, col.z, 1.0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
