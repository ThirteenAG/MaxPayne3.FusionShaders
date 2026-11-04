cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
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

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D gbufferTexture1 : register(t12);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float3 r2;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r0.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r1.yz = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(-(asfloat(r1.z)) + asfloat(r1.x));
		r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r1.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r2 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r1.xyz = asint(r2.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.w = asint(saturate(asfloat(r0.z) * -0.5 + 0.5));
	r0.w = asint(asfloat(r0.w) * gLightAmbient1.w + gLightAmbient0.w);
	r0.w = asint(max(asfloat(r0.w), 8));
	r1.xyz = asint(-(asfloat(r1.xyz)) + i.texcoord2.xyz);
	r2 = asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r2.xyz, r2.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2 = asfloat(r1.www) * r2.xyz;
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(saturate(-(asfloat(r1.x)) * gDeferredLightRadiusProjShearParams.y + 1));
	r1.x = asint(asfloat(r1.x) * gAmbientOcclusionEffect.y);
	r0.w = asint(asfloat(r1.x) / asfloat(r0.w));
	r0.x = asint(dot(r2.xyz, asfloat(r0.xyz)));
	r0.y = asint(asfloat(r0.w) * gDeferredLightColourAndIntensity.w);
	r0.z = asint(asfloat(r0.x) + 0.5);
	r0.z = asint(saturate(asfloat(r0.z) * 0.25));
	r0.x = asint(saturate(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + asfloat(r0.z));
	o.w = asfloat(r0.x) * asfloat(r0.y);
	o.xyz = float3(1, 1, 1);

	return o;
}
