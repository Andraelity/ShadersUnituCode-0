Shader "HeartLove"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}
		_ParallaxDepth  ("Parallax Depth", Range(0.0, 0.5)) = 0.01


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
			
            #define PI 3.141593

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

				// float3 bcol = float3(1.0, 0.8, 0.7 - 0.07 * coordinate.y) * ( 1.0 - 0.25 * length(coordinate));
			    float2 variable = float2(cos(_Time.y), sin(_Time.y));
				float2x2 transformation = float2x2(variable.x, -variable.y, variable.y, variable.x) * (1.0 + 0.5 * variable.x);
				
				
				// float2 value = mul(transformation,i.uv);
				float2 value = mul(transformation,coordinateScale);
                fixed3 bcol = tex2D(_TextureChannel0, 0.5 + 0.5 * value).xyz;

				// float3 bcol = tex2D(_TextureChannel0, coordinateScale);

				//animation 
				float tt = fmod(_Time.y , 1.5) / 1.5;
				float ss = pow(tt, 0.2) * 0.5 + 0.5;
				ss = 1.0 + ss * 0.5 * sin(tt * 6.2831 * 3.0 + coordinate.y * 0.5) * exp(-tt * 4.0);
				coordinate *= float2(0.5, 1.5) + ss * float2(0.5, -0.5);


				// Shape
				coordinate.y -= 0.25;
				float a = atan2(coordinate.x, coordinate.y)/PI;
				float r = length(coordinate);
				float h = abs(a);
				float d = (13.0 * h - 22.0 * h * h + 10.0 * h * h * h)/(6.0 - 5.0 * h);

				// Color
				float s = 0.75 + 0.75 * coordinate.x;
				s *= 1.0 - 0.4 * r;
				s = 0.3 + 0.7 * s;
				s *= 0.5 + 0.5 * pow(1.0 - clamp(r/d, 0.0, 1.0), 0.1);

				float3 hcol = float3(1.0, 0.4 * r, 0.3) * s;

				col = lerp(bcol, hcol, smoothstep(-0.01, 0.01 , d-r));




			    return float4(col,1.0); 

				

			}
			ENDCG
		}
	}
}




// {

//     			// fixed4 col = tex2D(_TextureChannel0, 0.5 + 0.5 * coordinate);
				

// 				// float4 col = float4(variable.xy,0,1);
// 				// float4 col = float4(coordinate,0,1);

// 				// col = float4(variable,0,1);

// 			    float r = pow(pow( coordinate.x * coordinate.x, 16.0) + pow(coordinate.y * coordinate.y, 16.0), 1.0/32.0);
// 			    float a = atan2(coordinate.y, coordinate.x);


// 			    float2 pixelDistribution = float2(0.5 * _Time.y + 0.5/r, a/3.1415927);

// 			    float h = sin(32.0 * pixelDistribution.y);

// 			    pixelDistribution.x += 0.85 * smoothstep(-0.1, 0.1, h);

// 			    float3 col = lerp(sqrt(tex2D(_TextureChannel0, 2.0*pixelDistribution).xyz), 
// 			    					   tex2D(_TextureChannel1, 1.0*pixelDistribution).xyz,
// 			    					   smoothstep(0.9,1.1, abs(coordinate.x/coordinate.y))
// 			    				);

// 			    r *= 1.0 - 0.3 * (smoothstep(0.0, 0.3, h) - smoothstep(0.3, 0.96, h));

// 			    col *= (r*r*1.2);
			    
// }