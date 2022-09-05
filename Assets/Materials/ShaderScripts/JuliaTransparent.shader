Shader "Unlit/JuliaTransparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (1,1,4,4)
        _Seed("Seed", vector) = (1,1,0,0)
        _MaxIter("Max Iterations", float) = 255
        _Color("Color", float) = 0.5
        _Repeat("Repeat", float) = 1
        _Speed("Speed", float) = 1
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
            float _Angle, _MaxIter, _Color, _Repeat, _Speed;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 z = _Area.xy + (i.uv - 0.5) * _Area.zw;
                float2 c = _Seed;
                float iter;
                float r = 20; //escape radius
                float r2 = r * r;

                for (iter = 0; iter < _MaxIter; iter++)
                {
                    z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;
                    if (length(z) > 2)
                    {
                        break;
                    }
                }
                if (iter >= _MaxIter) return 0;
                float dist = length(z); //distance from origin
                float fracIter = (dist - r) / (r2 - r); //linear interpolation
                fracIter = log2(log(dist) / log(r)); //double exponential interpolation

                iter -= fracIter;
                float m = sqrt(iter / _MaxIter); //0.0 - 1.0
                //_Color = m*_Repeat 
                float4 col = tex2D(_MainTex, float2(m * _Repeat + _Time.y * _Speed, _Color));
                return col;
            }
            ENDCG
        }
    }
}
