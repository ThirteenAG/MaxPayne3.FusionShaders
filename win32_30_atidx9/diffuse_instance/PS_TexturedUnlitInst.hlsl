sampler2D DiffuseSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = tex2D(DiffuseSampler, texcoord.xy);

	return o;
}
