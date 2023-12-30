# Unity Shaders Compilation Study Case
Repo on Unity Shaders Study Case

![](InGameShaders.gif)

# CHECK
This repository contain shaders, and elements that would be used in the future for the creation of more mathematical representations, on the game I want to implement the game I want to create right now, the game I want to modify.

```c++

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
  			// fixed4 col = tex2D(_TextureChannel0, 0.5 + 0.5 * coordinate);
		
		// float4 col = float4(variable.xy,0,1);
		// float4 col = float4(coordinate,0,1);
		// col = float4(variable,0,1);
	    float r = pow(pow( coordinate.x * coordinate.x, 16.0) + pow(coordinate.y * coordinate.y, 16.0), 1.0/32.0);
	    float a = atan2(coordinate.y, coordinate.x);
	
	    float2 pixelDistribution = float2(0.5 * _Time.y + 0.5/r, a/3.1415927);
	
	    float h = sin(32.0 * pixelDistribution.y);
	
	    pixelDistribution.x += 0.85 * smoothstep(-0.1, 0.1, h);
	
	    float3 col = lerp(sqrt(tex2D(_TextureChannel0, 2.0*pixelDistribution).xyz), 
	    					   tex2D(_TextureChannel1, 1.0*pixelDistribution).xyz,
	    					   smoothstep(0.9,1.1, abs(coordinate.x/coordinate.y))
	    				);
	
	    r *= 1.0 - 0.3 * (smoothstep(0.0, 0.3, h) - smoothstep(0.3, 0.96, h));
	
	    col *= (r*r*1.2);
	    
		return float4(col,1.0);
		
	}
```