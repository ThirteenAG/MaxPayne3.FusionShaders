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
	float4 gWaterGlobals : packoffset(c19);
};

cbuffer CacheZShiftandParallax : register(b4)
{
	float parallaxScaleBias : packoffset(c0);
};

cbuffer CacheMegaVariables : register(b7)
{
	float specularFactor : packoffset(c0);
	float3 specMapIntMask : packoffset(c0.y);
	float4 specMapExpMask : packoffset(c1);
	float bumpiness : packoffset(c2);
	float reflectivePower : packoffset(c2.y);
	float fresnelRolloff : packoffset(c2.z);
	float3 specMapReflectMask : packoffset(c3);
};

cbuffer Wet : register(b9)
{
	float4 WetDarken : packoffset(c0);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState PuddleMaskSampler : register(s2);
SamplerState SpecSampler : register(s3);
SamplerState DynamicEnvironmentSampler : register(s13);
SamplerState WaterRainRippleNormalSampler : register(s14);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D PuddleMaskSampler_tex : register(t2);
Texture2D SpecSampler_tex : register(t3);
Texture2D DynamicEnvironmentSampler_tex : register(t13);
Texture2D WaterRainRippleNormalSampler_tex : register(t14);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
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
	int4 r5;
	int3 r6;
	int2 r7;
	r0.x = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).w);
	r0.yzw = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1 = asint(asfloat(r0.w) * asfloat(r0.yzyz));
	r0.y = asint(parallaxScaleBias * 0.5);
	r0.x = asint(asfloat(r0.x) * parallaxScaleBias + -(asfloat(r0.y)));
	r0 = asint(asfloat(r0.x) * asfloat(r1) + i.texcoord.xyxy);
	r1.xy = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r0.zw)).xy);
	r2 = asint(ddx_coarse(asfloat(r0.zwzw)));
	r3 = asint(ddy_coarse(asfloat(r0.zwzw)));
	r4 = asint(asfloat(r3.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r4 = asint(asfloat(r2.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r4));
	r4 = asint(asfloat(r0.zwzw) + asfloat(r4));
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)).xwyz);
	r1.z = asint(asfloat(r5.y) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r6 = asint(asfloat(r5.yyy) * asfloat(r5.xzw));
	r6 = r1.zzz & r6.xyz;
	r5.x = 1;
	r4.xy = r1.zz & r5.xy;
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r1.w = asint(asfloat(r5.w) + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r7.x = (2 & ~1) | (r1.z & 1);
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r6.xyz));
	r7.y = asint(asfloat(r4.y) + asfloat(r5.w));
	r5.xyz = (r1.www != 0) ? r5.xyz : r6.xyz;
	r1.zw = (r1.ww != 0) ? r7.xy : r4.xy;
	r3 = asint(asfloat(r3) * float4(0.125, 0.125, 0.375, 0.375));
	r2 = asint(asfloat(r2) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r3));
	r0 = asint(asfloat(r0) + asfloat(r2));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r2.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r3.x = r1.z + 4;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r5.xyz));
	r3.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.xyz = (r0.xxx != 0) ? r2.xyz : r5.xyz;
	r0.xy = (r0.xx != 0) ? r3.xy : r1.zw;
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.z = asint(asfloat(r3.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r4.x = r0.x + 8;
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r2.xyz));
	r4.y = asint(asfloat(r0.y) + asfloat(r3.w));
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r2.xyz = asint(asfloat(r2.xyz) / asfloat(r0.yyy));
	r0.zw = asint(asfloat(r1.xy) * float2(2, 2) + float2(-1, -1));
	r3.xy = asint(asfloat(r0.zw) * bumpiness);
	r0.z = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r3.z = asint(sqrt(asfloat(r0.z)));
	r4 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.z = asint(dot(asfloat(r4), specMapExpMask));
	r0.z = asint(asfloat(r0.z) * specularFactor);
	r0.w = asint(dot(asfloat(r4.xyz), specMapIntMask));
	r0.z = asint(max(asfloat(r0.z), 1));
	r1.z = (0 < i.color.y) ? -1 : 0;
	r5.xy = asint(i.texcoord6.xy * WetDarken.ww);
	r1.w = asint(PuddleMaskSampler_tex.Sample(PuddleMaskSampler, asfloat(r5.xy)).x);
	r5.xy = asint(i.texcoord6.xy * float2(0.300000012, 0.300000012));
	r5.xyz = asint(WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, asfloat(r5.xy)).xyz);
	if (r1.z != 0) {
		r1.z = asint(asfloat(r1.w) + gWaterGlobals.y);
		r1.z = asint(saturate(asfloat(r1.z) + -(i.color.y)));
		r1.w = (0 < asfloat(r1.z)) ? -1 : 0;
		if (r1.w != 0) {
			r2.xyz = asint(asfloat(r2.xyz) * WetDarken.xyz);
			r1.w = asint(-(asfloat(r0.w)) + gWaterGlobals.z);
			r0.w = asint(asfloat(r1.z) * asfloat(r1.w) + asfloat(r0.w));
			r1.w = asint(-(asfloat(r0.z)) + gWaterGlobals.w);
			r0.z = asint(asfloat(r1.z) * asfloat(r1.w) + asfloat(r0.z));
			r5.xyz = asint(asfloat(r5.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
			r5.xyz = asint(asfloat(r5.xyz) * i.texcoord1.zzz + -(asfloat(r3.xyz)));
			r5.xyz = asint(asfloat(r1.zzz) * asfloat(r5.xyz) + asfloat(r3.xyz));
			r5.xyz = asint(asfloat(r5.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
			r1.z = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
			r1.z = asint(rsqrt(asfloat(r1.z)));
			r3.xyz = asint(asfloat(r1.zzz) * asfloat(r5.xyz));
		} else {
			r1.z = asint(saturate(gWaterGlobals.y));
			r5.xyz = asint(asfloat(r2.xyz) * WetDarken.xyz + -(asfloat(r2.xyz)));
			r2.xyz = asint(asfloat(r1.zzz) * asfloat(r5.xyz) + asfloat(r2.xyz));
		}
	}
	r5.xyz = asint(asfloat(r3.xxx) * i.texcoord4.xyz);
	r3.xzw = asint(asfloat(r3.zzz) * i.texcoord1.xyz + asfloat(r5.xyz));
	r3.xyz = asint(asfloat(r3.yyy) * i.texcoord5.xyz + asfloat(r3.xzw));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.z = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r3.xyz = asint(asfloat(r1.zzz) * asfloat(r3.xyz));
	r1.z = (0 < reflectivePower) ? -1 : 0;
	if (r1.z != 0) {
		r1.z = asint(saturate(asfloat(r0.z) * 0.015625));
		r1.z = asint(-(asfloat(r1.z)) * 4 + 4);
		r5.xyz = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r1.w = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r5.xyz = asint(asfloat(r1.www) * asfloat(r5.xyz));
		r1.w = asint(dot(-(asfloat(r5.xyz)), asfloat(r3.xyz)));
		r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
		r6 = asint(asfloat(r3.xyz) * -(asfloat(r1.www)) + -(asfloat(r5.xyz)));
		r6 = asint(asfloat(r6.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r1.w = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r6 = asint(asfloat(r1.www) * asfloat(r6.zxy));
		r6.x = asint(saturate(asfloat(r6.x)));
		r1.w = asint(asfloat(r6.x) + 1);
		r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
		r6.xy = asint(asfloat(r6.yz) / asfloat(r1.ww));
		r6.xy = asint(asfloat(r6.xy) + float2(0.5, 0.5));
		r6.xy = asint(-(asfloat(r6.xy)) + float2(1, 1));
		r6 = asint(DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, asfloat(r6.xy), asfloat(r1.z)).xyz);
		r6 = asint(asfloat(r6.xyz) * asfloat(r6.xyz));
		r6 = asint(asfloat(r6.xyz) * float3(16, 16, 16));
		r1.z = asint(saturate(dot(asfloat(r5.xyz), asfloat(r3.xyz))));
		r1.w = asint(-(fresnelRolloff) + 1);
		r1.z = asint(-(asfloat(r1.z)) + 1.00001001);
		r2.w = asint(asfloat(r1.z) * asfloat(r1.z));
		r2.w = asint(asfloat(r2.w) * asfloat(r2.w));
		r1.z = asint(asfloat(r1.z) * asfloat(r2.w));
		r1.z = asint(fresnelRolloff * asfloat(r1.z) + asfloat(r1.w));
		r5.xyz = asint(asfloat(r1.zzz) * asfloat(r6.xyz));
	} else {
		r5.xyz = int3(0, 0, 0);
	}
	r5.xyz = asint(asfloat(r5.xyz) * reflectivePower);
	r1.z = asint(dot(asfloat(r4.xyz), specMapReflectMask.xyz));
	r4.xyz = asint(asfloat(r1.zzz) * asfloat(r5.xyz));
	r4.xyz = asint(asfloat(r4.xyz) * globalScalars.www);
	r1.x = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.x = (asfloat(r1.x) >= 0.00200000009) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r1.y = asint(asfloat(r1.x) * i.color.x);
	o.sv_target2.x = asfloat(r0.w) * asfloat(r1.x);
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r0.w = asint(saturate(i.color.x * asfloat(r1.x) + -1));
	r0.w = asint(asfloat(r0.w) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r2.xyz) * asfloat(r1.xxx) + asfloat(r0.www);
	o.sv_target1.xyz = asfloat(r3.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.z = asint(saturate(asfloat(r0.z) * 0.00510204071));
	r0.z = asint(sqrt(asfloat(r0.z)));
	o.sv_target2.y = sqrt(asfloat(r0.z));
	o.sv_target2.z = asfloat(r1.y) * gAmbientOcclusionEffect.w;
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	r1.xyz = asint(saturate(asfloat(r4.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r1.xyz));
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r0.x;

	return o;
}
