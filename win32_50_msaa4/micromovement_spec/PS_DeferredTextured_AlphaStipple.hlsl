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

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float3 specMapIntMask : packoffset(c0.y);
	float4 specMapExpMask : packoffset(c1);
};

SamplerState DiffuseSampler : register(s0);
SamplerState SpecSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D SpecSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
	uint sv_coverage : SV_Coverage;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int2 r5;
	r0.x = 1;
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r1 = asint(asfloat(r1) * float4(0.125, 0.125, 0.375, 0.375));
	r3 = asint(ddx_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r3.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r2));
	r1 = asint(asfloat(r3) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r1));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw)));
	r0.y = r3.w;
	r0.z = asint(asfloat(r3.w) + -0.5);
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = r0.xy & r0.zz;
	r4.y = asint(asfloat(r2.w) + asfloat(r0.y));
	r0.w = asint(asfloat(r2.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.z & 1);
	r3.xyz = r3.xyz & r0.zzz;
	r0.xy = (r0.ww != 0) ? r4.xy : r0.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r5.y = asint(asfloat(r0.y) + asfloat(r4.w));
	r5.x = r0.x + 4;
	r0.z = asint(asfloat(r4.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r5.x = r0.x + 8;
	r5.y = asint(asfloat(r1.w) + asfloat(r0.y));
	r3.w = asint(asfloat(r1.w) + -0.5);
	r3.w = (asfloat(r3.w) >= 0) ? -1 : 0;
	r0.xy = (r3.ww != 0) ? r5.xy : r0.xy;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r2.xyz = (r0.www != 0) ? r2.xyz : r3.xyz;
	r3.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xyz));
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyz));
	r1.xyz = (r3.www != 0) ? r1.xyz : r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r0.z = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r0.zzz) * globalScalars2.zzz + asfloat(r1.xyz);
	r0.y = asint(asfloat(r0.y) * i.color.w);
	o.sv_coverage = r0.x;
	r0.x = asint(asfloat(r0.y) * globalScalars.x);
	r0.yzw = asint(i.texcoord6.xyz + -(gViewInverse[3].xyz));
	r0.y = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) + -0.649999976);
	r0.y = asint(max(asfloat(r0.y), 0.25));
	r0.y = asint(min(asfloat(r0.y), 1));
	r0.y = asint(asfloat(r0.y) + -1);
	r0.y = asint(gDistFadeParams.x * asfloat(r0.y) + 1);
	o.sv_target.w = asfloat(r0.y) * asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r0.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.w = asint(dot(asfloat(r0), specMapExpMask));
	o.sv_target2.x = dot(asfloat(r0.xyz), specMapIntMask);
	r0.x = asint(asfloat(r0.w) * specularFactor);
	r0.x = asint(max(asfloat(r0.x), 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
