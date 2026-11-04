cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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

cbuffer DeferredLight : register(b4)
{
	float gDeferredLightType : packoffset(c0);
	float3 gDeferredLightPosition : packoffset(c0.y);
	float3 gDeferredLightDirection : packoffset(c1);
	float3 gDeferredLightTangent : packoffset(c2);
	float4 gDeferredLightRadiusProjShearParams : packoffset(c3);
	float gDeferredLightInvSqrRadius : packoffset(c4);
	float gDeferredVolumeRadiusScale : packoffset(c4.y);
	float gDeferredLightConeAngleI : packoffset(c4.z);
	float gDeferredLightConeAngle : packoffset(c4.w);
	float gDeferredLightConeOffset : packoffset(c5);
	float gDeferredLightConeScale : packoffset(c5.y);
	float4 gDeferredLightColourAndIntensity : packoffset(c6);
	float4 gooDeferredLightScreenSize : packoffset(c7);
	float4 gDeferredProjParams : packoffset(c8);
};

SamplerState gDeferredLightSampler : register(s0);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float2 r2;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.x = asint(asfloat(r0.x) * i.texcoord.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.xxx) + gViewInverse[3].xyz);
	r0.xyz = asint(-(asfloat(r0.xyz)) + gDeferredLightPosition.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r0.w = asint(dot(gDeferredLightDirection.xyz, asfloat(r1.xyz)));
	r1.x = asint(dot(-(gDeferredLightDirection.xyz), asfloat(r0.xyz)));
	r1.y = (0 < -(asfloat(r1.x))) ? -1 : 0;
	r1.z = (-(asfloat(r1.x)) < 0) ? -1 : 0;
	r1.x = asint(asfloat(r1.x) + -(gDeferredLightRadiusProjShearParams.x));
	r1.y = r1.z + -(r1.y);
	r1.y = asint((float)r1.y);
	r0.w = asint(saturate(asfloat(r0.w) * asfloat(r1.y)));
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r1.yzw = asint(gDeferredLightDirection.zxy * gDeferredLightTangent.yzx);
	r1.yzw = asint(gDeferredLightDirection.yzx * gDeferredLightTangent.zxy + -(asfloat(r1.yzw)));
	r1.y = asint(dot(asfloat(r1.yzw), asfloat(r0.xyz)));
	r0.x = asint(dot(gDeferredLightTangent.xyz, asfloat(r0.xyz)));
	r0.yz = asint(float2(gDeferredLightConeOffset, gDeferredLightConeScale) * float2(2.20000005, 1.79999995));
	r2.x = asfloat(r1.y) / asfloat(r0.y);
	r2.y = asfloat(r0.x) / asfloat(r0.z);
	r0.xy = asint(r2.xy * float2(0.5, 0.5) + float2(0.5, 0.5));
	r0.x = asint(gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, asfloat(r0.xy), 0).x);
	r0.x = asint(asfloat(r0.w) * asfloat(r0.x));
	r0.y = asint(gDeferredLightRadiusProjShearParams.x + gDeferredLightRadiusProjShearParams.x);
	r0.y = asint(asfloat(r1.x) / asfloat(r0.y));
	r0.y = asint(saturate(-(asfloat(r0.y)) + 1));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * gDeferredLightColourAndIntensity.w);
	o.w = gAmbientOcclusionEffect.x * asfloat(r0.x) + asfloat(r0.x);
	o.xyz = float3(0, 0, 0);

	return o;
}
