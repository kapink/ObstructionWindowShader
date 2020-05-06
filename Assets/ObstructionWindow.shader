Shader "Custom/ObstructionWindow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_MaskAlpha("Mask Alpha", Range(0,1)) = 1
		_Size ("Size", Float) = 1
		_RotateSpeed("Rotate Speed", Float) = 1
		_ScreenPosition("Screen Position (XY)", Vector) = (0.5,0.5,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			//#pragma enable_d3d11_debug_symbols

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float4 screenPosition : TEXCOORD2;
            };

			sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
			sampler2D _Mask;
			float _MaskAlpha;
			float _Size;
			float _RotateSpeed;
			float4 _ScreenPosition;

            v2f vert (appdata v)
            {
				// Fix Ratio. The screen size may change, but the ratio fix 
				float ratio = _ScreenParams.x / _ScreenParams.y;

				// Rotate
				float s = sin(_RotateSpeed * _Time);
				float c = cos(_RotateSpeed * _Time);
				float2x2 rotationMatrix = float2x2(c, -s, s, c);
				// Adjust the UV coordinates for the rotation application below.
				float offsetX = 0.5;
				float offsetY = 0.5;
				float x = (v.uv.x - _ScreenPosition.x) * ratio;
				float y = v.uv.y - _ScreenPosition.y;

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.uv2 = (mul(float2(x, y), rotationMatrix) + float2(offsetX, offsetY) * _Size) / _Size;
				o.screenPosition = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the textures
                fixed4 col = tex2D(_MainTex, i.uv);
				float mask = tex2D(_Mask, i.uv2).a;

				fixed4 output = lerp(col, col * mask, _MaskAlpha);
				return output;
            }
            ENDCG
        }
    }
}
