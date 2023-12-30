Shader "DiscoBall"
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

			    float2 m = float2(sin(TIME), sin(TIME + PI));

			    float a1 = atan2(coordinate.y - m.y, coordinate.x - m.x); 
			    float r1 = length(coordinate-m);
			    float a2 = atan2(coordinate.y + m.y, coordinate.x - m.x);
			    float r2 = length(coordinate+m);

			    float2 coordinateDistribution = float2( 0.2 * (r1 - r2) + 0.2 * TIME, asin(sin(a1 - a2))/PI);

			    col = tex2D(_TextureChannel0, 0.125 * coordinateDistribution).xyz;

			    float w = exp2(-18.0 * r1 * r1 ) + exp2(-18.0 * r2 * r2);

			    w += 0.25 * smoothstep(0.93, 1.0, sin(128.0 * coordinateDistribution.x));
			    w += 0.25 * smoothstep(0.93, 1.0, sin(128.0 * coordinateDistribution.y));

			    return float4(col + w ,1.0); 

				

			}
			ENDCG
		}
	}
}

























