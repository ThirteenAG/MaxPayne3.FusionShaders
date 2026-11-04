cbuffer _Globals : register(b1)
{
	float g_fSSAOBilateralCoef : packoffset(c122);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
};

SamplerState gDeferredLightSampler1 : register(s1);
SamplerState deferredLightDownsampleDepthSampler : register(s3);
Texture2D gDeferredLightSampler1_tex : register(t1);
Texture2D deferredLightDownsampleDepthSampler_tex : register(t3);

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
	r0.x = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, i.texcoord.xy).x;
	r1 = float4(1, 1, 1, 1) / globalScreenSize.xyxy;
	r2 = r1.zwzw * float4(0, -4, 0, -2) + i.texcoord.xyxy;
	r1 = r1 * float4(0, 2, 0, 4) + i.texcoord.xyxy;
	r3.x = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r2.xy).x;
	r3.y = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r2.zw).x;
	r3.z = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r1.xy).x;
	r3.w = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r1.zw).x;
	r0 = -(r0.x) + r3;
	r0 = r0 / g_fSSAOBilateralCoef;
	r0 = abs(r0) * abs(r0);
	r0 = r0 * float4(-0.721347511, -0.721347511, -0.721347511, -0.721347511);
	r0 = exp2(r0);
	r0 = r0 * float4(0.5, 0.75, 0.75, 0.5);
	r3.x = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.xy).x;
	r3.y = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.zw).x;
	r3.z = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.xy).x;
	r3.w = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.zw).x;
	r1.x = dot(r3, r0);
	r0.x = dot(float4(1, 1, 1, 1), r0);
	r0.x = r0.x + 1;
	r0.y = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, i.texcoord.xy).x;
	r0.y = r1.x + r0.y;
	o = r0.y / r0.x;

	return o;
}
