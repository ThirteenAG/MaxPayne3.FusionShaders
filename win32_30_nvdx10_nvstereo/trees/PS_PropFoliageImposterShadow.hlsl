sampler2D DiffuseSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DiffuseSampler, texcoord.xy);
	o = r0.w + r0.w;

	return o;
}
