sampler2D DiffuseTexSampler : register(s0);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r0 = r0 * i.texcoord;
	r0.w = saturate(r0.w);
	r1 = max(r0, 0);
	o = min(r1, 32);

	return o;
}
