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
	float4 r1;
	r0.x = 1;
	r0.z = i.color.w;
	r0.yw = i.texcoord.xy * float2(0.200000003, 0.200000003) + float2(0.0250000004, 0.800000012);
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, r0.yw);
	o.yzw = r0.xxz * r1.yzw;
	o.x = saturate(r1.x + r1.x);

	return o;
}
