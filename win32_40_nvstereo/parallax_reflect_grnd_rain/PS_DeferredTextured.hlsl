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
SamplerState EnvironmentSampler : register(s3);
SamplerState WaterRainRippleNormalSampler : register(s14);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D PuddleMaskSampler_tex : register(t2);
Texture2D EnvironmentSampler_tex : register(t3);
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
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	r0 = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy);
	r0.xyz = i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r0.z = parallaxScaleBias * 0.5;
	r0.z = r0.w * parallaxScaleBias + -(r0.z);
	r0.xy = r0.zz * r0.xy + i.texcoord.xy;
	r1 = asint(BumpSampler_tex.Sample(BumpSampler, r0.xy));
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, r0.xy);
	r1.zw = asint(asfloat(r1.xy) * float2(2, 2) + float2(-1, -1));
	r2.xy = asint(asfloat(r1.zw) * bumpiness);
	r1.z = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(max(asfloat(r1.z), 0));
	r2.z = asint(sqrt(asfloat(r1.z)));
	r1.z = asint(max(specularFactor, 1));
	r1.w = (0 < i.color.y) ? -1 : 0;
	r3.xy = i.texcoord6.xy * WetDarken.ww;
	r3 = PuddleMaskSampler_tex.Sample(PuddleMaskSampler, r3.xy);
	r3.yz = i.texcoord6.xy * float2(0.300000012, 0.300000012);
	r4 = WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, r3.yz);
	if (r1.w != 0) {
		r1.w = asint(r3.x + gWaterGlobals.y);
		r1.w = asint(saturate(asfloat(r1.w) + -(i.color.y)));
		r2.w = (0 < asfloat(r1.w)) ? -1 : 0;
		if (r2.w != 0) {
			r0.xyz = r0.xyz * WetDarken.xyz;
			r2.w = asint(gWaterGlobals.z + -(specularColorFactor));
			r2.w = asint(asfloat(r1.w) * asfloat(r2.w) + specularColorFactor);
			r3.x = -(asfloat(r1.z)) + gWaterGlobals.w;
			r1.z = asint(asfloat(r1.w) * r3.x + asfloat(r1.z));
			r3.xyz = r4.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
			r3.xyz = r3.xyz * i.texcoord1.zzz + -(asfloat(r2.xyz));
			r3.xyz = asfloat(r1.www) * r3.xyz + asfloat(r2.xyz);
			r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
			r1.w = asint(dot(r3.xyz, r3.xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r2.xyz = asint(asfloat(r1.www) * r3.xyz);
		} else {
			r1.w = asint(saturate(gWaterGlobals.y));
			r3.xyz = r0.xyz * WetDarken.xyz + -(r0.xyz);
			r0.xyz = asfloat(r1.www) * r3.xyz + r0.xyz;
			r2.w = asint(specularColorFactor);
		}
	} else {
		r2.w = asint(specularColorFactor);
	}
	r3.xyz = asfloat(r2.xxx) * i.texcoord4.xyz;
	r3.xyz = asfloat(r2.zzz) * i.texcoord1.xyz + r3.xyz;
	r2.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz + r3.xyz);
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyz = asint(asfloat(r1.www) * asfloat(r2.xyz));
	r3.xyz = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r3.xyz, r3.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.xyz = asfloat(r1.www) * r3.xyz;
	r1.w = asint(dot(-(r3.xyz), asfloat(r2.xyz)));
	r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
	r4.xyz = asfloat(r2.xyz) * -(asfloat(r1.www)) + -(r3.xyz);
	r4.xyz = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r4.xyz, r4.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4.xy = r4.xz * asfloat(r1.ww) + float2(1, 1);
	r4.xy = r4.xy * float2(-0.5, -0.5);
	r4 = EnvironmentSampler_tex.Sample(EnvironmentSampler, r4.xy);
	r1.w = asint(saturate(dot(r3.xyz, asfloat(r2.xyz))));
	r3.x = -(fresnelRolloff) + 1;
	r1.w = asint(-(asfloat(r1.w)) + 1.00001001);
	r3.y = asfloat(r1.w) * asfloat(r1.w);
	r3.y = r3.y * r3.y;
	r1.w = asint(asfloat(r1.w) * r3.y);
	r1.w = asint(fresnelRolloff * asfloat(r1.w) + r3.x);
	r3.xyz = asfloat(r1.www) * r4.xyz;
	r3.xyz = r3.xyz * reflectivePower;
	r3.xyz = r3.xyz * globalScalars.www;
	r1.x = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.x = (asfloat(r1.x) >= 0.00200000009) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r1.y = asint(asfloat(r1.x) * i.color.x);
	o.sv_target2.x = asfloat(r1.x) * asfloat(r2.w);
	r0.w = r0.w * i.color.w;
	r1.w = asint(saturate(i.color.x * asfloat(r1.x) + -1));
	r1.w = asint(asfloat(r1.w) * globalScalars2.z);
	o.sv_target.xyz = r0.xyz * asfloat(r1.xxx) + asfloat(r1.www);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = saturate(asfloat(r1.z) * 0.00510204071);
	r0.x = sqrt(r0.x);
	o.sv_target2.y = sqrt(r0.x);
	o.sv_target2.z = asfloat(r1.y) * gAmbientOcclusionEffect.w;
	r0.x = r0.w * globalScalars.x;
	r0.yzw = saturate(r3.xyz * float3(0.0625, 0.0625, 0.0625));
	o.sv_target3.xyz = sqrt(r0.yzw);
	o.sv_target.w = r0.x;
	o.sv_target1.w = r0.x;
	o.sv_target2.w = r0.x;
	o.sv_target3.w = r0.x;

	return o;
}
