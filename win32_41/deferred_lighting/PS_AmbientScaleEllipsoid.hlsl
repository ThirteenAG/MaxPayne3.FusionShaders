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

	float4 r0;
	int4 r1;
	float3 r2;
	r0.xyz = gDeferredLightDirection.xyz + gDeferredLightTangent.xyz;
	r1.xyz = asint(-(r0.xyz) * float3(0.5, 0.5, 0.5) + gDeferredLightTangent.xyz);
	r0.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.w = sqrt(r0.w);
	r0.w = r0.w + gDeferredLightConeOffset;
	r0.w = gDeferredLightConeOffset / r0.w;
	r1.xy = (int2)i.sv_position.xy;
	r1.zw = int2(0, 0);
	r2.x = gbufferTextureDepth.Load(r1.xyw).x;
	r1.xyz = asint(gbufferTexture1.Load(r1.xyz).xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.w = asint(r2.x * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.w = asint(asfloat(r1.w) * i.texcoord.w);
	r1.w = asint(1 / asfloat(r1.w));
	r2 = -(i.texcoord.xyz) * asfloat(r1.www) + gViewInverse[3].xyz;
	r0.xyz = -(r0.xyz) * float3(0.5, 0.5, 0.5) + r2.xyz;
	r2 = -(gDeferredLightDirection.xyz) + gDeferredLightTangent.xyz;
	r2 = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r2.xyz, r2.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2 = asfloat(r1.www) * r2.xyz;
	r1.w = asint(dot(r0.xyz, r2.xyz));
	r0.w = asfloat(r1.w) * r0.w + -(asfloat(r1.w));
	r0.xyz = r2.xyz * r0.www + r0.xyz;
	r0.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.w = rsqrt(r0.w);
	r1.xyz = asint(r0.www * asfloat(r1.xyz));
	r0.w = dot(asfloat(r1.xyz), -(r0.xyz));
	r0.x = dot(-(r0.xyz), -(r0.xyz));
	r0.x = sqrt(r0.x);
	r0.y = saturate(asfloat(r1.z) * 4);
	r0.z = saturate(r0.w / r0.x);
	r0.x = r0.x / gDeferredLightConeOffset;
	r0.x = saturate(-(r0.x) + 1);
	r0.z = r0.z * r0.z;
	r0.x = r0.z * r0.x;
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	r0.x = r0.y * r0.x;
	o.w = r0.x * gAmbientOcclusionEffect.x;
	o.xyz = float3(0, 0, 0);

	return o;
}
