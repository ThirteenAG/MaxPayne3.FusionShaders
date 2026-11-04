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
Texture2D gDeferredLightSampler1_tex : register(t1);
Texture2DMS<float4> deferredLightTexture2 : register(t2);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float r1;
	float3 dimensions0;
	deferredLightTexture2.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r1 = deferredLightTexture2.Load(r0.xy, 0).w;
	r0.x = asint(deferredLightTexture2.Load(r0.xy, 1).w);
	r0.x = asint(asfloat(r0.x) + r1.x);
	r0.x = asint(asfloat(r0.x) * 0.5);
	r0.yz = asint(float2(1, 1) / globalScreenSize.xy);
	r0.yz = asint(asfloat(r0.yz) * float2(0.5, 0.5) + i.texcoord.xy);
	r0.y = asint(gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, asfloat(r0.yz)).x);
	r0.y = asint(asfloat(r0.y) + -1);
	r0.y = asint(gAmbientOcclusionEffect.x * asfloat(r0.y) + 1);
	o.z = asfloat(r0.y) * asfloat(r0.x);
	o.xyw = float3(0, 0, 0);

	return o;
}
