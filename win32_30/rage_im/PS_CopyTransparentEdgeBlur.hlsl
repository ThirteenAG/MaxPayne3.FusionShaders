sampler2D TransparentSrcMapSampler : register(s2);

half4 main(float2 texcoord : TEXCOORD) : COLOR
{
	half4 o;

	o = tex2D(TransparentSrcMapSampler, texcoord.xy);

	return o;
}
