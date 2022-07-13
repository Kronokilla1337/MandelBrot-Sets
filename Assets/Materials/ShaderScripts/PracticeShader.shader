Shader "Explorer/PracticeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (0,0,4,4)
        _Angle("Angle", range(3.1415, -3.1415)) = 0
        _MaxIter("MaxIterations", float) = 255
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            sampler2D _MainTex;
            float _Angle, _MaxIter;

            float2 rot(float2 p, float2 pivot, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);

                p -= pivot;
                p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
                p += pivot;
                return p;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 c = _Area.xy+( i.uv)*_Area.zw; 
                c = rot(c, _Area.xy, _Angle);
                float2 z ;
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
                float4 col = sin(float4(.21, .39, .76, 1.0)*m*20);
                return col;
            }
            ENDCG
        }
    }
}
