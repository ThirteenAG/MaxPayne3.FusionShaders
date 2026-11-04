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
	r0.xy = i.texcoord.xy + -(clearcol.xy);
	r0.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.xy).xy;
	r0.x = min(r0.x, 1);
	r0.y = max(r0.y, 0);
	r1 = clearcol.xyxy * float4(0, -1, 1, -1) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r1 = clearcol.xyxy * float4(2, -1, -1, 0) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, i.texcoord.xy).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r1 = clearcol.xyxy * float4(1, 0, 2, 0) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r1 = clearcol.xyxy * float4(-1, 1, 0, 1) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r0.zw = i.texcoord.xy + clearcol.xy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r1 = clearcol.xyxy * float4(2, 1, -1, 2) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r1 = clearcol.xyxy * float4(0, 2, 1, 2) + i.texcoord.xyxy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.xy).xy;
	r1.xy = SmartBlitSampler_tex.Sample(SmartBlitSampler, r1.zw).xy;
	r0.x = min(r0.z, r0.x);
	r0.y = max(r0.w, r0.y);
	r0.y = max(r1.y, r0.y);
	r0.x = min(r1.x, r0.x);
	r0.zw = clearcol.xy * float2(2, 2) + i.texcoord.xy;
	r0.zw = SmartBlitSampler_tex.Sample(SmartBlitSampler, r0.zw).xy;
	o.x = min(r0.z, r0.x);
	o.y = max(r0.w, r0.y);
	o.zw = float2(0, 1);

	return o;
}
