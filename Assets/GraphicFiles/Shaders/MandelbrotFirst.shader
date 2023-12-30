Shader "MandelbrotFirst"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}


	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
		LOD 100

		Pass
		{
		    ZWrite Off
		    Cull off
		    Blend SrcAlpha OneMinusSrcAlpha
		    
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
            #pragma multi_compile_instancing
			
			#include "UnityCG.cginc"

			struct vertexPoints
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct pixel
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            UNITY_INSTANCING_BUFFER_START(CommonProps)
                UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
                UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeZero_Ten)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeSOne_One)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeZoro_OneH)

            UNITY_INSTANCING_BUFFER_END(CommonProps)

           
			pixel vert (vertexPoints v)
			{
				pixel o;
				
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.vertex.xy;
				return o;
			}
            
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
			
            #define PI 3.1415927
            #define TIME _Time.y

            float Mandelbrot( in float2 c)
            {
            	const float B = 256.0;
            	float l = 0.0;
            	float2 z = 0.0;

            	for(int i = 0; i < 512; i++)
            	{
            		z = float2( z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
            		if(dot(z,z) > (B*B))
            		{
            			break;
            		}
            		l += 1.0;
            	}

            	if( l > 511.0)
            	{
            		return 0.0;
            	}	

            	float sl = l - log2(log2(dot(z,z))) + 4.0;

            	float al = smoothstep(-0.1, 0.0, sin(0.5 * 6.2831 * TIME));

            	l = lerp(l, sl, al);

            	return l;

            }


			fixed4 frag (pixel i) : SV_Target
			{
			
			    UNITY_SETUP_INSTANCE_ID(i);
			    
			    float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   	float _rangeZero_Ten = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZero_Ten);
				float _rangeSOne_One = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeSOne_One);
				float _rangeZoro_OneH = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZoro_OneH);

				float2 scaleResolution = i.uv + 1;
    			
    			float2 coordinateScale = scaleResolution.xy/float2(2, 2);
			    
			    float2 coordinate = i.uv;

			    float3 col = 0.0;
			    uint AA = 2;

			    for(int m = 0; m < AA; m++)
			    {
			    	for(int n = 0; n < AA; n++)
			    	{
			    		float w = float(AA * m + n);
			    		float time = TIME + 0.5 * (1.0/24.0) * w /float(AA * AA);

			    		float zoo = 0.62 + 0.38 * cos(0.07 * TIME);
			    		float coa = cos(0.15 * (1.0 - zoo) * TIME);
			    		float sia = sin(0.15 * (1.0 - zoo) * TIME);

			    		zoo = pow(zoo, 8.0);

			    		float2 xy = float2(coordinate.x * coa - coordinate.y * sia, coordinate.x * sia + coordinate.y * coa);
			    		float2 c = float2(-0.745, 0.186) + xy * zoo;

			    		float l = Mandelbrot(c);

			    		col += 0.5 + 0.5 * cos(3.0 + l * 0.15 + float3(0.0, 0.6, 1.0));
			    	}			    	
			    }


			    return float4(col ,1.0); 

				

			}
			ENDCG
		}
	}
}

























