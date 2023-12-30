Shader "FlowerStyle"
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
			
            float3 deform( in float2 coordinate, in float t)
            {
            	t *= 2.0;
            	coordinate += 0.5*sin(t*float2(1.1,1.3) + float2(0.0, 0.5));

            	float a = atan2(coordinate.y, coordinate.x);
            	float r  = length(coordinate);

            	float s = r * (1.0 + 0.5 * cos(t*1.7));

            	float2 pixelDistribution = 0.1 * t + 0.05 * coordinate.yx + 0.05 * float2(cos(t+a * 2.0), sin(t+a * 2.0))/s;

            	float3 output = tex2D(_TextureChannel0, 0.5*pixelDistribution).xyz;
            	return output;
            }

			fixed4 frag (pixel i) : SV_Target
			{
			
			    UNITY_SETUP_INSTANCE_ID(i);
			    
			    float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   

				float2 variable = i.uv + 1;
    			
    			float2 coordinateScale = variable.xy/float2(2, 2);
			    
			    float2 coordinate = i.uv;

			    float3 col = 0.0;
			    

			    float a = atan2(coordinate.x, coordinate.y);

			    float r = length(coordinate) * (0.8 + 0.2 * sin(0.3 * _Time.y));

			    float w = cos(2.0 * _Time.y - r * 2.0);

			    float h = 0.5  + 0.5 * cos(12.0 * a - w * 7.0 + r * 8.0 + 0.7 * _Time.y);

			    float d = 0.25 + 0.75 * pow(h, 1.0 * r ) * (0.7  + 0.3 * w);

			    float f = sqrt(1.0 - r/d) * r * 2.5;

			    f *= 1.25 + 0.25 * cos((12.0 * a - w * 7.0 + r * 8.0)/2.0);

			    f *= 1.0 - 0.35 * (0.5 + 0.5 * sin(r*30.0)) * (0.5 + 0.5 * cos(12.0 * a - w * 7.0 + r * 8.0));

			    col = float3(	f,
			    					f - h * 0.5 + r * 0.2 + 0.35 * h * (1.0 - r),
			    					f - h * r + 0.1 * h * (1.0 - r)
							);

			    float3 bcol = lerp(0.5 * float3(0.8,0.9,1.0), float3(1.0,1.0,1.0), 0.5 + 0.5 * coordinate.y );

			    col = lerp(col, bcol, smoothstep(-0.3, 0.6, r-d));

			    if( col.x > 0.01)
			    {
					return float4(col,1.0);
			    }
			    else
			    {
			    	return 0.0;
			    }
				

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