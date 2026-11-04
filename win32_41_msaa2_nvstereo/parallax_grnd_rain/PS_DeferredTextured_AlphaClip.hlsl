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

cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
};

cbuffer CacheZShiftandParallax : register(b4)
{
	float parallaxScaleBias : packoffset(c0);
};

cbuffer CacheMegaVariables : register(b7)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
	float reflectivePower : packoffset(c0.w);
	float fresnelRolloff : packoffset(c1);
};

cbuffer Wet : register(b9)
{
	float4 WetDarken : packoffset(c0);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState PuddleMaskSampler : register(s2);
SamplerState DynamicEnvironmentSampler : register(s13);
SamplerState WaterRainRippleNormalSampler : register(s14);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D PuddleMaskSampler_tex : register(t2);
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
	float4 r4;
	r0.x = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).w);
	r0.yzw = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1 = asint(asfloat(r0.w) * asfloat(r0.yzyz));
	r0.y = asint(parallaxScaleBias * 0.5);
	r0.x = asint(asfloat(r0.x) * parallaxScaleBias + -(asfloat(r0.y)));
	r0 = asint(asfloat(r0.x) * asfloat(r1) + i.texcoord.xyxy);
	r1.xy = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r0.zw)).xy);
	r2 = asint(ddx(asfloat(r0.zwzw)));
	r3 = asint(ddy(asfloat(r0.zwzw)));
	r3 = asint(asfloat(r3) * float4(0.25, 0.25, -0.25, -0.25));
	r2 = asint(asfloat(r2) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r3));
	r0 = asint(asfloat(r0) + asfloat(r2));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0.x = asint(asfloat(r2.y) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r3.xyz = asint(asfloat(r2.yyy) * asfloat(r2.xzw));
	r3.xyz = r0.xxx & r3.xyz;
	r2.x = 1;
	r1.zw = r0.xx & r2.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r2.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (r0.x != 0) ? 0.000000 : 0.000000;
	r0.xzw = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r4.y = asfloat(r1.w) + asfloat(r2.w);
	r0.xzw = (r0.yyy != 0) ? r0.xzw : r3.xyz;
	r1.zw = (r0.yy != 0) ? asint(r4.xy) : r1.zw;
	r0.xyz = asint(asfloat(r0.xzw) / asfloat(r1.www));
	r2.xy = asint(asfloat(r1.xy) * float2(2, 2) + float2(-1, -1));
	r2.xy = asint(asfloat(r2.xy) * bumpiness);
	r0.w = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r2.z = asint(sqrt(asfloat(r0.w)));
	r0.w = asint(max(specularFactor, 1));
	r2.w = (0 < i.color.y) ? -1 : 0;
	r3.xy = asint(i.texcoord6.xy * WetDarken.ww);
	r3.x = asint(PuddleMaskSampler_tex.Sample(PuddleMaskSampler, asfloat(r3.xy)).x);
	r3.yz = asint(i.texcoord6.xy * float2(0.300000012, 0.300000012));
	r3.yzw = asint(WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, asfloat(r3.yz)).xyz);
	if (r2.w != 0) {
		r2.w = asint(asfloat(r3.x) + gWaterGlobals.y);
		r2.w = asint(saturate(asfloat(r2.w) + -(i.color.y)));
		r3.x = (0 < asfloat(r2.w)) ? -1 : 0;
		if (r3.x != 0) {
			r0.xyz = asint(asfloat(r0.xyz) * WetDarken.xyz);
			r3.x = asint(gWaterGlobals.z + -(specularColorFactor));
			r3.x = asint(asfloat(r2.w) * asfloat(r3.x) + specularColorFactor);
			r4.x = -(asfloat(r0.w)) + gWaterGlobals.w;
			r0.w = asint(asfloat(r2.w) * r4.x + asfloat(r0.w));
			r3.yzw = asint(asfloat(r3.yzw) * float3(2, 2, 2) + float3(-1, -1, -1));
			r3.yzw = asint(asfloat(r3.yzw) * i.texcoord1.zzz + -(asfloat(r2.xyz)));
			r3.yzw = asint(asfloat(r2.www) * asfloat(r3.yzw) + asfloat(r2.xyz));
			r3.yzw = asint(asfloat(r3.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
			r2.w = asint(dot(asfloat(r3.yzw), asfloat(r3.yzw)));
			r2.w = asint(rsqrt(asfloat(r2.w)));
			r2.xyz = asint(asfloat(r2.www) * asfloat(r3.yzw));
		} else {
			r2.w = asint(saturate(gWaterGlobals.y));
			r3.yzw = asint(asfloat(r0.xyz) * WetDarken.xyz + -(asfloat(r0.xyz)));
			r0.xyz = asint(asfloat(r2.www) * asfloat(r3.yzw) + asfloat(r0.xyz));
			r3.x = asint(specularColorFactor);
		}
	} else {
		r3.x = asint(specularColorFactor);
	}
	r3.yzw = asint(asfloat(r2.xxx) * i.texcoord4.xyz);
	r2.xzw = asint(asfloat(r2.zzz) * i.texcoord1.xyz + asfloat(r3.yzw));
	r2.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz + asfloat(r2.xzw));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r2.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz));
	r2.w = (0 < reflectivePower) ? -1 : 0;
	if (r2.w != 0) {
		r2.w = asint(saturate(asfloat(r0.w) * 0.015625));
		r2.w = asint(-(asfloat(r2.w)) * 4 + 4);
		r3.yzw = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r4.x = dot(asfloat(r3.yzw), asfloat(r3.yzw));
		r4.x = rsqrt(r4.x);
		r3.yzw = asint(asfloat(r3.yzw) * r4.xxx);
		r4.x = dot(-(asfloat(r3.yzw)), asfloat(r2.xyz));
		r4.x = r4.x + r4.x;
		r4.xyz = asfloat(r2.xyz) * -(r4.xxx) + -(asfloat(r3.yzw));
		r4.xyz = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r4.w = dot(r4.xyz, r4.xyz);
		r4.w = rsqrt(r4.w);
		r4.xyz = r4.www * r4.zxy;
		r4.x = saturate(r4.x);
		r4.x = r4.x + 1;
		r4.x = r4.x + r4.x;
		r4.xy = r4.yz / r4.xx;
		r4.xy = r4.xy + float2(0.5, 0.5);
		r4.xy = -(r4.xy) + float2(1, 1);
		r4.xyz = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r4.xy, asfloat(r2.w)).xyz;
		r4.xyz = r4.xyz * r4.xyz;
		r4.xyz = r4.xyz * float3(16, 16, 16);
		r2.w = asint(saturate(dot(asfloat(r3.yzw), asfloat(r2.xyz))));
		r3.y = asint(-(fresnelRolloff) + 1);
		r2.w = asint(-(asfloat(r2.w)) + 1.00001001);
		r3.z = asint(asfloat(r2.w) * asfloat(r2.w));
		r3.z = asint(asfloat(r3.z) * asfloat(r3.z));
		r2.w = asint(asfloat(r2.w) * asfloat(r3.z));
		r2.w = asint(fresnelRolloff * asfloat(r2.w) + asfloat(r3.y));
		r3.yzw = asint(asfloat(r2.www) * r4.xyz);
	} else {
		r3.yzw = int3(0, 0, 0);
	}
	r1.w = asint(asfloat(r1.w) * i.color.w);
	r1.w = asint(asfloat(r1.w) * globalScalars.x);
	r2.w = (g_AlphaRef >= asfloat(r1.w)) ? -1 : 0;
	if (r2.w != 0) discard;
	r3.yzw = asint(asfloat(r3.yzw) * reflectivePower);
	r3.yzw = asint(asfloat(r3.yzw) * globalScalars.www);
	r1.x = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.x = (asfloat(r1.x) >= 0.00200000009) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r1.y = asint(asfloat(r1.x) * i.color.x);
	o.sv_target2.x = asfloat(r1.x) * asfloat(r3.x);
	r2.w = asint(saturate(i.color.x * asfloat(r1.x) + -1));
	r2.w = asint(asfloat(r2.w) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r0.xyz) * asfloat(r1.xxx) + asfloat(r2.www);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(saturate(asfloat(r0.w) * 0.00510204071));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = asfloat(r1.y) * gAmbientOcclusionEffect.w;
	r0.xyz = asint(saturate(asfloat(r3.yzw) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyz));
	o.sv_target.w = asfloat(r1.w);
	o.sv_target1.w = asfloat(r1.w);
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r1.w);
	o.sv_coverage = r1.z;

	return o;
}
