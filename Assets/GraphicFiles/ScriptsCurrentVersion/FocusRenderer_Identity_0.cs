using UnityEngine;
using UnityEngine.Rendering;

using System;
using System.IO;
using System.Collections.Generic;


using ShaderCode_Identity_0;

namespace AttachScript_0
{
	
	public class FocusRenderer_Identity : MonoBehaviour {
		
		public Color FillColor;
		public string Path;
		public string TextureChannel0;
		public string TextureChannel1;
		public string TextureChannel2;
		public string TextureChannel3;
		
		[Range(1f, 10f)] public float Radius = 2f;
		[Range(0f, 10f)] public float RangeZero_Ten = 2f;
		[Range(-1f, 1f)] public float RangeSOne_One = 1f;
		[Range(0f, 100f)] public float RangeZoro_OneH = 2f;


		private Texture2D TextureToShaderChannel0;
		private Texture2D TextureToShaderChannel1;
		private Texture2D TextureToShaderChannel2;
		private Texture2D TextureToShaderChannel3;
		
		MeshInfo_Identity meshToPaint;

		void Start()
		{
			
			TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
			TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
			TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
			TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);

			meshToPaint = new MeshInfo_Identity
			{
				center = transform.position,
				forward = transform.forward,
				radius = Radius,
				fillColor = FillColor,
				pathShader = Path,
				textureToChannel0 = TextureToShaderChannel0,
				textureToChannel1 = TextureToShaderChannel1,
				textureToChannel2 = TextureToShaderChannel2,
				textureToChannel3 = TextureToShaderChannel3,
				rangeZero_Ten = RangeZero_Ten,
				rangeSOne_One = RangeSOne_One,
				rangeZoro_OneH = RangeZoro_OneH

			};

			
			DrawMesh_Identity.DrawStart(meshToPaint);
			
		}

		 
		private void Update()
		{
			meshToPaint.radius = Radius;
			meshToPaint.rangeZero_Ten = RangeZero_Ten;
			meshToPaint.rangeSOne_One = RangeSOne_One;
			meshToPaint.rangeZoro_OneH = RangeZoro_OneH;
			DrawMesh_Identity.DrawStart(meshToPaint);
		}


		void Awake()
		{
		}

	}
}
