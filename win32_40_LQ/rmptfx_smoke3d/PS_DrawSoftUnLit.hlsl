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
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
	float4 gLightPointColR : packoffset(c16);
	float4 gLightPointColG : packoffset(c17);
	float4 gLightPointColB : packoffset(c18);
	float4 gLightPointPosX : packoffset(c19);
	float4 gLightPointPosY : packoffset(c20);
	float4 gLightPointPosZ : packoffset(c21);
	float4 gLightDir2X : packoffset(c22);
	float4 gLightDir2Y : packoffset(c23);
	float4 gLightDir2Z : packoffset(c24);
	float4 gLightConeScale2 : packoffset(c25);
	float4 gLightConeOffset2 : packoffset(c26);
	float4 gLightPointFallOff : packoffset(c27);
	float4 gDistFadeParams : packoffset(c28);
	float4 gAdrenoFXVars : packoffset(c29);
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
};

cbuffer CacheHybrid : register(b1)
{
	float HybridAdd : packoffset(c0);
};

cbuffer CustomVertexVariables : register(b4)
{
	float HybridAddRatio : packoffset(c0);
	float HDRIntensityMultiplier : packoffset(c0.y);
	float4 gActiveUnit : packoffset(c1);
	float4 gTexCoordScaleOffset0 : packoffset(c2);
	float4 gTexCoordScaleOffset1 : packoffset(c3);
	float4 gTexCoordScaleOffset2 : packoffset(c4);
	float4 gTexCoordScaleOffset3 : packoffset(c5);
};

SamplerState DiffuseTexSampler : register(s0);
Texture2D DiffuseTexSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord6 : TEXCOORD6;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = asint(i.texcoord1.xy * gTexCoordScaleOffset2.xy + gTexCoordScaleOffset2.zw);
	r0 = asint(DiffuseTexSampler_tex.Sample(DiffuseTexSampler, asfloat(r0.xy)));
	r1.xy = i.texcoord1.xy * gTexCoordScaleOffset0.xy + gTexCoordScaleOffset0.zw;
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, r1.xy);
	r2.xy = i.texcoord1.xy * gTexCoordScaleOffset1.xy + gTexCoordScaleOffset1.zw;
	r2 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, r2.xy);
	r3 = i.texcoord6 * gActiveUnit;
	r2 = r2 * r3.y;
	r1 = r3.x * r1 + r2;
	r0 = asint(r3.z * asfloat(r0) + r1);
	r1.xy = i.texcoord1.xy * gTexCoordScaleOffset3.xy + gTexCoordScaleOffset3.zw;
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, r1.xy);
	r0 = asint(r3.w * r1 + asfloat(r0));
	r1 = asfloat(r0.wxyz) * i.texcoord.wxyz;
	r0.w = asint(dot(r1.yzw, float3(0.212500006, 0.715399981, 0.0720999986)));
	r1.x = saturate(r1.x);
	r0.xyz = asint(asfloat(r0.xyz) * i.texcoord.xyz + -(asfloat(r0.www)));
	r1.y = gAdrenoFXVars.x * deSatContrastGamma.x;
	r0.xyz = asint(r1.yyy * asfloat(r0.xyz) + asfloat(r0.www));
	r1.yzw = -(asfloat(r0.xyz)) + i.texcoord4.xyz;
	r0.xyz = asint(i.texcoord4.www * r1.yzw + asfloat(r0.xyz));
	r0.w = (0 < HybridAdd) ? -1 : 0;
	r0.w = (r0.w != 0) ? asint(r1.x) : 1065353216;
	r1.w = r1.x * i.texcoord3.z;
	r1.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	r0 = asint(max(r1, float4(0, 0, 0, 0)));
	o = min(asfloat(r0), float4(32, 32, 32, 32));

	return o;
}
