sampler2D RenderMapPointSamplerMSAA : register(s5);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = tex2D(RenderMapPointSamplerMSAA, texcoord.xy);

	return o;
}
