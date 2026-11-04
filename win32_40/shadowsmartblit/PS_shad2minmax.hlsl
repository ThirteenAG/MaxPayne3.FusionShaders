cbuffer SmartBlit : register(b4)
{
	float4 clearcol : packoffset(c0);
};

SamplerState SmartBlitSampler : register(s1);
Texture2D SmartBlitSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = clearcol.xyxy * float4(0.5, 0.5, 0.5, 0.5) + i.texcoord.xyxy;
	r1 = clearcol.xyxy * float4(-0.5, -0.5, 0.5, 0.5) + r0.zwzw;
	r0 = clearcol.xyxy * float4(0.5, -0.5, -0.5, 0.5) + r0;
	r2 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy);
	r1 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw);
	r3 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.xy);
	r0 = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.zw);
	r0.y = min(r2.x, r3.x);
	r0.z = max(r2.x, r3.x);
	r0.z = max(r0.x, r0.z);
	r0.x = min(r0.x, r0.y);
	o.x = min(r1.x, r0.x);
	o.y = max(r1.x, r0.z);
	o.zw = float2(0, 1);

	return o;
}
