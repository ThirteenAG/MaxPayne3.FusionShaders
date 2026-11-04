sampler2D TextureSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = tex2D(TextureSampler, texcoord.xy);

	return o;
}
