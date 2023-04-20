Shader "USB/Toggle_example_shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [Toggle] _Enable ("Enable?", Float) = 0
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma  shader_feature _ENABLE_ON
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            float4 _Color;

            half4 frag(v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                #if _ENABLE_ON
                return col;
                #else
                return col * _Color;
                #endif
            }
            ENDCG
        }
    }
}