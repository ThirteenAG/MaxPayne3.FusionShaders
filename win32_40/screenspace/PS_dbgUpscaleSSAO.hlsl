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
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

SamplerState gDeferredLightSampler1 : register(s1);
SamplerState gDeferredLightSampler2 : register(s2);
Texture2D gDeferredLightSampler1_tex : register(t1);
Texture2D gDeferredLightSampler2_tex : register(t2);

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
	r0.xy = float2(1, 1) / globalScreenSize.xy;
	r0.xy = r0.xy * float2(0.5, 0.5) + i.texcoord.xy;
	r0 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r0.xy);
	r0.x = r0.x + -1;
	r0.x = gAmbientOcclusionEffect.x * r0.x + 1;
	r1 = gDeferredLightSampler2_tex.Sample(gDeferredLightSampler2, i.texcoord.xy);
	o.z = r0.x * r1.w;
	o.xyw = float3(0, 0, 0);

	return o;
}
