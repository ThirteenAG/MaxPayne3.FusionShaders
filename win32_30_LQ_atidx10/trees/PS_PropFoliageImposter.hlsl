sampler2D DiffuseSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = float4(1, 1, 0, 0) * texcoord.xyxx;
	o = tex2Dlod(DiffuseSampler, r0);

	return o;
}
