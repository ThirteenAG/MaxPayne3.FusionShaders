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
	r0 = clearcol.xyxy * float4(0.5, 0.5, 0.5, 0.5) + i.texcoord.xyxy;
	r1 = clearcol.xyxy * float4(-0.5, -0.5, 0.5, 0.5) + r0.zwzw;
	r0 = clearcol.xyxy * float4(0.5, -0.5, -0.5, 0.5) + r0;
	r1.x = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).x;
	r1.y = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).x;
	r0.x = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.xy).x;
	r0.y = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.zw).x;
	r0.z = min(r0.x, r1.x);
	r0.x = max(r0.x, r1.x);
	r0.x = max(r0.y, r0.x);
	r0.y = min(r0.y, r0.z);
	o.x = min(r1.y, r0.y);
	o.y = max(r1.y, r0.x);
	o.zw = float2(0, 1);

	return o;
}
