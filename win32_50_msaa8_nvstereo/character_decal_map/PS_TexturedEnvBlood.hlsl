SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int2 r0;
	float4 r1;
	r0.x = asint(-(i.color.z) + 0.999899983);
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	r0.x = (r1.z >= asfloat(r0.x)) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.y = asint(r1.w * i.color.w);
	o.w = asfloat(r0.x) * asfloat(r0.y);
	o.z = r1.w * r1.x;
	o.xy = r1.xy;

	return o;
}
