cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
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

cbuffer rage_SoftParticleBuffer : register(b4)
{
	float4 NearFarPlane : packoffset(c0);
	float4 gInvScreenSize : packoffset(c1);
};

cbuffer Softness : register(b7)
{
	float gSoftness : packoffset(c0);
};

cbuffer CacheHybrid : register(b8)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleGlobals : register(b9)
{
	float4 gBloodLightingTuners : packoffset(c0);
};

cbuffer ParticleSprite : register(b12)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gSpecularIntensity : packoffset(c1);
	float gSpecularExponent : packoffset(c1.y);
	float gExtraLights : packoffset(c1.z);
	float gAmbientAmount : packoffset(c1.w);
	float gSuperAlpha : packoffset(c2);
	float gNormalArc : packoffset(c2.y);
	float gScaleFade : packoffset(c2.z);
	float gUseShadows : packoffset(c2.w);
	float gAmbientShadow : packoffset(c3);
	float gLightIntensityClamp : packoffset(c3.y);
};

SamplerState DiffuseTexSampler : register(s0);
SamplerState NormalMapTexSampler : register(s1);
SamplerState DepthMapTexSampler : register(s12);
Texture2D DiffuseTexSampler_tex : register(t0);
Texture2D NormalMapTexSampler_tex : register(t1);
Texture2D DepthMapTexSampler_tex : register(t12);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0 = asint(-(i.texcoord7.x) + gLightPosX);
	r1 = asfloat(r0) * asfloat(r0);
	r2 = -(i.texcoord7.y) + gLightPosY;
	r1 = r2 * r2 + r1;
	r3 = -(i.texcoord7.z) + gLightPosZ;
	r1 = r3 * r3 + r1;
	r4 = saturate(-(r1) * gLightFallOff + float4(1, 1, 1, 1));
	r1 = r1 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1 = rsqrt(r1);
	r4 = r4 * r4;
	r4 = r4 * r4 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r4 = max(r4, float4(0, 0, 0, 0));
	r4 = r4 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r2 = r1 * r2;
	r0 = asint(asfloat(r0) * r1);
	r1 = r1 * r3;
	r3.xyz = NormalMapTexSampler_tex.Sample(NormalMapTexSampler, i.texcoord1.zw).xyz;
	r3.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r5.xyz = NormalMapTexSampler_tex.Sample(NormalMapTexSampler, i.texcoord1.xy).xyz;
	r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r3.xyz = r3.xyz + -(r5.xyz);
	r3.w = saturate(i.texcoord3.x);
	r5.xyz = r3.www * r3.xyz + r5.xyz;
	r5.w = -(r5.y);
	r3.xyz = r5.xwz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r5.x = dot(r3.xyz, r3.xyz);
	r5.x = rsqrt(r5.x);
	r3.xyz = r3.xyz * r5.xxx;
	r5 = asfloat(r0) * r3.x;
	r5 = r2 * r3.y + r5;
	r5 = r1 * r3.z + r5;
	r6 = -(r5) + float4(1, 1, 1, 1);
	r5 = gNormalArc * r6 + r5;
	r4 = saturate(r4 * r5);
	r5 = asfloat(r0) * -(gLightDirX);
	r5 = r2 * -(gLightDirY) + r5;
	r5 = r1 * -(gLightDirZ) + r5;
	r5 = saturate(r5 * gLightConeScale + gLightConeOffset);
	r4 = r4 * r5;
	r5.x = r3.z * -2;
	r5.xyz = r3.xyz * -(r5.xxx) + float3(0, 0, -1);
	r0 = asint(asfloat(r0) * r5.x);
	r0 = asint(r5.y * r2 + asfloat(r0));
	r0 = asint(saturate(r5.z * r1 + asfloat(r0)));
	r1.x = saturate(dot(r5.xyz, -(gDirectionalLight.xyz)));
	r1.x = r1.x + 0.00000999999975;
	r1.x = log2(r1.x);
	r0 = asint(asfloat(r0) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0 = asint(log2(asfloat(r0)));
	r1.y = gSpecularExponent + 0.00000999999975;
	r0 = asint(asfloat(r0) * r1.y);
	r1.x = r1.x * r1.y;
	r1.x = exp2(r1.x);
	r1.x = r1.x * gWrapScale + gWrapBias;
	r1.x = r1.x * gDirectionalColour.x;
	r1.x = r1.x * gSpecularIntensity;
	r0 = asint(exp2(asfloat(r0)));
	r0 = asint(r4 * asfloat(r0));
	r2.x = dot(gLightColR, asfloat(r0));
	r2.y = dot(gLightColG, asfloat(r0));
	r2.z = dot(gLightColB, asfloat(r0));
	r0.xyz = asint(r2.xyz * gSpecularIntensity);
	r0.xyz = asint(max(asfloat(r0.xyz), float3(0, 0, 0)));
	r2.x = dot(gLightColR, r4);
	r2.y = dot(gLightColG, r4);
	r2.z = dot(gLightColB, r4);
	r1.yzw = max(r2.xyz, gBloodLightingTuners.xxx);
	r1.yzw = min(r1.yzw, gBloodLightingTuners.yyy);
	r1.yzw = r1.yzw * i.texcoord.xyz;
	r1 = max(r1, float4(0, 0, 0, 0));
	r0.xyz = asint(asfloat(r0.xyz) + r1.yzw);
	r0.w = asint(dot(r3.xyz, -(gDirectionalLight.xyz)));
	r0.w = asint(max(asfloat(r0.w), -(gLightIntensityClamp)));
	r0.w = asint(min(asfloat(r0.w), gLightIntensityClamp));
	r1.y = -(asfloat(r0.w)) + 1;
	r0.w = asint(gNormalArc * r1.y + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gWrapScale + gWrapBias);
	r0.w = asint(asfloat(r0.w) * gDirectionalColour.x);
	r0.w = asint(asfloat(r0.w) * gDiffuse);
	r0.w = asint(max(asfloat(r0.w), gBloodLightingTuners.x));
	r0.w = asint(min(asfloat(r0.w), gBloodLightingTuners.y));
	r1.yzw = asfloat(r0.www) * i.texcoord.xyz;
	r1.yzw = max(r1.yzw, float3(0, 0, 0));
	r1.xyz = r1.xxx + r1.yzw;
	r0.xyz = asint(asfloat(r0.xyz) + r1.xyz);
	r0.w = asint(dot(gLightAmbientDir1.xyz, r3.xyz));
	r1.x = dot(gLightAmbientDir0.xyz, r3.xyz);
	r1.x = saturate(r1.x + gLightAmbientDir0.w);
	r0.w = asint(saturate(asfloat(r0.w) + gLightAmbientDir0.w));
	r1.yzw = asfloat(r0.www) * gLightAmbient1.xyz;
	r1.xyz = r1.xxx * gLightAmbient0.xyz + r1.yzw;
	r1.xyz = r1.xyz * gBloodLightingTuners.zzz;
	r1.xyz = r1.xyz * i.texcoord.xyz;
	r1.xyz = max(r1.xyz, float3(0, 0, 0));
	r0.xyz = asint(r1.xyz * gAmbientShadow + asfloat(r0.xyz));
	r1.xy = i.sv_position.xy * gInvScreenSize.xy + gInvScreenSize.zw;
	r1.x = DepthMapTexSampler_tex.Sample(DepthMapTexSampler, r1.xy).x;
	r1.x = -(r1.x) + 1;
	r1.x = r1.x * NearFarPlane.z + NearFarPlane.w;
	r1.x = 1 / r1.x;
	r1.x = r1.x + -(i.texcoord3.y);
	r1.x = r1.x * r1.x;
	r1.x = saturate(r1.x * gSoftness);
	r1.y = saturate(i.texcoord.w * gSuperAlpha);
	r0.w = asint(r1.x * r1.y);
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.zw);
	r2 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.xy);
	r1 = r1 + -(r2);
	r1 = r3.w * r1 + r2;
	r2 = asfloat(r0.wxyz) * r1.wxyz;
	r0.w = asint(dot(r2.yzw, float3(0.212500006, 0.715399981, 0.0720999986)));
	r2.x = saturate(r2.x);
	r0.xyz = asint(asfloat(r0.xyz) * r1.xyz + -(asfloat(r0.www)));
	r1.x = gAdrenoFXVars.x * deSatContrastGamma.x;
	r0.xyz = asint(r1.xxx * asfloat(r0.xyz) + asfloat(r0.www));
	r1.xyz = -(asfloat(r0.xyz)) + i.texcoord4.xyz;
	r0.xyz = asint(i.texcoord4.www * r1.xyz + asfloat(r0.xyz));
	r0.w = (0 < HybridAdd) ? -1 : 0;
	r0.w = (r0.w != 0) ? asint(r2.x) : 1065353216;
	o.w = r2.x * i.texcoord3.z;
	o.xyz = asfloat(r0.www) * asfloat(r0.xyz);

	return o;
}
