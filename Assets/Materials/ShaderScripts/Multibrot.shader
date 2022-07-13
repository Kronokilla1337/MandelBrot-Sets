Shader "Explorer/MultibrotShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Area("Area", vector) = (0,0,4,4)
        _Angle("Angle", range(-3.1415, 3.1415)) = 0
        _MaxIter("MaxIterations" ,float) = 255
        _Color("Color", range(0,1)) = 0.5
        _Repeat("Repeat", float) = 1
        _Speed("Speed", float) = 1
        _Power("Power", float) = 1


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

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                float4 _Area;
                sampler2D _MainTex;
                float _Angle, _MaxIter, _Color, _Repeat, _Speed, _Power; 


                float2 rot(float2 p, float2 pivot, float a)
                {
                    float s = sin(a);
                    float c = cos(a);
                    p -= pivot;
                    p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
                    p += pivot;
                    return p;

                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float2 c = _Area.xy + (i.uv - .5) * _Area.zw;
                    c = rot(c, _Area.xy, _Angle);

                    float r = 20; //escape radius
                    float r2 = r * r;

                    float2 z;
                    float iter;
                    for (iter = 0; iter < _MaxIter; iter++)
                    {
                        float k;
                        r2 = 400;
                        switch (_Power)
                        {
                            case 1:
                            {
                                z = float2(z.x, z.y) + c;
                                //r2 *= r;
                                break;
                            }
                            case 2:
                            {
                                z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;
                                break;
                            }
                            case 3:
                            {
                                z = float2(pow(z.x,3) - 3*(z.x)*pow(z.y,2), 3 * pow(z.x,2) * (z.y) - pow(z.y,3)) + c;
                                //r2 /= r;
                                break;
                            }
                            case 4:
                            {
                                z = float2(pow(z.x,4) - 6*pow(z.x,2)*pow(z.y,2)+pow(z.y,4), 4*pow(z.x,3)*z.y - 4* pow(z.y,3)*z.x)+c;
                                //r2 /= r2;
                                break;
                            }
                            case 5:
                            {
                                z = float2(pow(z.x,5) - 10*pow(z.x,3)*pow(z.y,2)+ 5 * z.x * pow(z.y,4), pow(z.y, 5) + 5*pow(z.x,4)*z.y - 
                                    10* pow(z.y,3)*pow(z.x,2))+c;
                                break;
                            }
                            default:
                            {
                                z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;
                                break;
                            }

                        }

                        if (dot(z, z) > r2)
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
                    float4 col = tex2D(_MainTex, float2(m * _Repeat + _Time.y * _Speed, _Color));
                    col *= smoothstep(3, 0, fracIter);
                    //col *= 1 + sin(angle * 2 + _Time.y * 4) * 0.2;
                    return col;
                }
                ENDCG
            }
        }
}
