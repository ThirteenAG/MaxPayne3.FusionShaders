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

	float4 r0;
	int4 r1;
	r0.xy = i.color.yz * float2(2, 2) + float2(-1, -1);
	r0.xy = r0.xy * float2(-2.5, 2.5);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.zw = asfloat(r1.yz) * float2(2, 2) + float2(-1, -1);
	r0.x = dot(r0.zw, r0.xy);
	r0.y = r0.x * r0.x;
	r0.x = saturate(r0.x * r0.y);
	r0.y = asfloat(r1.w) * i.color.w;
	r0.w = r0.x * r0.y;
	r0.xyz = float3(0.5, 0.0500000007, 0.5);
	r1.y = asint(-(i.color.x) + 1);
	r1.x = (asfloat(r1.x) >= asfloat(r1.y)) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	o = r0 * asfloat(r1.x);

	return o;
}
