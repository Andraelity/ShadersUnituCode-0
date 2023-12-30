Shader "WhormHole"
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
                // UNITY_DEFINE_INSTANCED_PROP(sampler2D, _TextureFocus)
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
			


			fixed4 frag (pixel i) : SV_Target
			{
			
			    UNITY_SETUP_INSTANCE_ID(i);
			    
			    float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   

				float2 variable = i.uv + 1;
    			
    			float2 coordinateScale = variable.xy/float2(2, 2);
			    
			    float2 coordinate = i.uv;

				return float4(coordinate, 1.0,1.0);
				

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