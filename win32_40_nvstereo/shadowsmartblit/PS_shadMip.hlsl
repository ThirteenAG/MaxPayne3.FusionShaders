cbuffer SmartBlit : register(b4)
{
	float4 clearcol : packoffset(c0);
};

SamplerState SmartBlitSampler : register(s1);
Texture2D SmartBlitSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = SmartBlitSampler_tex.Sample(SmartBlitSampler, i.texcoord.xy);
	r1 = clearcol.x * float4(0.5, -0.5, 0.5, 0.5) + i.texcoord.xyxy;
	r2 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy);
	r1 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw);
	r0.xyz = max(r0.xyz, r2.xyz);
	r0.xyz = max(r1.xyz, r0.xyz);
	r1 = clearcol.x * float4(-0.5, 0.5, -0.5, -0.5) + i.texcoord.xyxy;
	r2 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy);
	r1 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw);
	r0.xyz = max(r0.xyz, r2.xyz);
	o.xyz = max(r1.xyz, r0.xyz);
	o.w = 1;

	return o;
}
