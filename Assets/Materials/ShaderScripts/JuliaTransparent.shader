Shader "Unlit/JuliaTransparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (1,1,4,4)
        _Seed("Seed", vector) = (1,1,0,0)
        _MaxIter("Max Iterations", float) = 255
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"  }
        ZWrite Off
        Lighting Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
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

            float2 _Seed;
            float4 _Area;
            float _MaxIter;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 z = _Area.xy + (i.uv) * _Area.zw;
                float2 c = _Seed;
                float iter;

                for (iter = 0; iter < _MaxIter; iter++)
                {
                    z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;
                    if (length(z) > 2)
                    {
                        break;
                    }
                }
                if (iter >= _MaxIter) return 0;
                float m = (iter / _MaxIter);
                float4 col = sin(float4(.21, .39, .76, 0.3) * m * 20);
                return col;
            }
            ENDCG
        }
    }
}
