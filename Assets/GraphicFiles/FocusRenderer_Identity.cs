using UnityEngine;
using UnityEngine.Rendering;

using System;
using System.IO;
using System.Collections.Generic;


using ShaderCode_Identity;

namespace AttachScript
{
	
	public class FocusRenderer_Identity : MonoBehaviour {
		
		public Color FillColor;
		public string Path;
		public string TextureChannel0;
		public string TextureChannel1;
		public string TextureChannel2;
		public string TextureChannel3;
		
		[Range(1f, 10f)] public float Radius = 2f;
		


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
				textureToChannel3 = TextureToShaderChannel3

			};

			
			DrawMesh_Identity.DrawStart(meshToPaint);
			
		}

		 
		private void Update()
		{
			meshToPaint.radius = Radius;
			
			DrawMesh_Identity.DrawStart(meshToPaint);
		}


		void Awake()
		{
		}

	}
}
