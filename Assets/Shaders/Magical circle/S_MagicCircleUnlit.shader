Shader "Unlit/S_MagicCircleUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollSpeeds ("ScrollSpeeds", Float) = 1
        _AlphaOffset ("Alpha Offset", Float) = 0
        _AlphaGradient ("Alpha Gradient", Vector) = (1,0,0,0)
        _Color ("Color (RGBA)", Color) = (1, 1, 1, 1) // add _Color property

    }
    SubShader
    {
        

        Pass
        {
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZTest LEqual
            ZWrite Off


            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha

            // Render State
            #define _SURFACE_TYPE_TRANSPARENT 1

            #include "UnityCG.cginc"

            //Vertex
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normals:NORMAL;
                float2 uv : TEXCOORD0;
            };

            //Fragment
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 vertex_object_space : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _AlphaOffset;
            float _ScrollSpeeds;
            float2 _AlphaGradient;


            //Vertex Phase
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex_object_space = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.y += _ScrollSpeeds * _Time.y;
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            //Fragment phase
            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);


                //Y Alpha gradient
                float alphagradient = i.vertex_object_space.y;
                alphagradient = alphagradient + _AlphaOffset;
                alphagradient = smoothstep(_AlphaGradient.x, _AlphaGradient.y, alphagradient);
                alphagradient = saturate(alphagradient);
                //return alphagradient;

                //col.a = smoothstep(_)
                
                //Update alpha channel
                col.a = col.a * alphagradient;

                //Multiply color
                col *= _Color;

                return col;
            }
            ENDCG
        }
    }
}