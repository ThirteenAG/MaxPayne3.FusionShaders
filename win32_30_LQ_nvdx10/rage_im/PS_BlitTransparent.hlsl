sampler2D TransparentSrcMapSampler : register(s2);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = tex2D(TransparentSrcMapSampler, texcoord.xy);

	return o;
}
