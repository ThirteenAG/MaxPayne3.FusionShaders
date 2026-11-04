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

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float3 specMapIntMask : packoffset(c0.y);
	float4 specMapExpMask : packoffset(c1);
	float bumpiness : packoffset(c2);
};

cbuffer Wet : register(b7)
{
	float4 WetDarken : packoffset(c0);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState PuddleMaskSampler : register(s2);
SamplerState SpecSampler : register(s3);
SamplerState WaterRainRippleNormalSampler : register(s14);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D PuddleMaskSampler_tex : register(t2);
Texture2D SpecSampler_tex : register(t3);
Texture2D WaterRainRippleNormalSampler_tex : register(t14);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	int3 r5;
	float2 r6;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx(i.texcoord.xyxy));
	r2 = asint(ddy(i.texcoord.xyxy));
	r3 = asint(asfloat(r2.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r3 = asint(asfloat(r1.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r3));
	r3 = asint(asfloat(r3) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)).xwyz);
	r0.z = asint(asfloat(r4.y) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r5 = asint(asfloat(r4.yyy) * asfloat(r4.xzw));
	r5 = r0.zzz & r5.xyz;
	r4.x = 1;
	r3.xy = r0.zz & r4.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw)));
	r0.w = asint(asfloat(r4.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r6.x = (r0.z != 0) ? 3 : 2;
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r5.xyz));
	r6.y = asfloat(r3.y) + asfloat(r4.w);
	r4.xyz = (r0.www != 0) ? r4.xyz : r5.xyz;
	r0.zw = (r0.ww != 0) ? asint(r6.xy) : r3.xy;
	r2 = asint(asfloat(r2) * float4(0.125, 0.125, 0.375, 0.375));
	r1 = asint(asfloat(r1) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1.x = asint(asfloat(r2.w) + -0.5);
	r1.x = (asfloat(r1.x) >= 0) ? -1 : 0;
	r3.x = r0.z + 4;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r4.xyz));
	r3.y = asint(asfloat(r0.w) + asfloat(r2.w));
	r2.xyz = (r1.xxx != 0) ? r2.xyz : r4.xyz;
	r0.zw = (r1.xx != 0) ? r3.xy : r0.zw;
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r2.w = asint(asfloat(r1.w) + -0.5);
	r2.w = (asfloat(r2.w) >= 0) ? -1 : 0;
	r3.x = r0.z + 8;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyz));
	r3.y = asint(asfloat(r0.w) + asfloat(r1.w));
	r1.xyz = (r2.www != 0) ? r1.xyz : r2.xyz;
	r0.zw = (r2.ww != 0) ? r3.xy : r0.zw;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r2.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.x = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r2.z = asint(sqrt(asfloat(r0.x)));
	r3 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.x = asint(dot(asfloat(r3), specMapExpMask));
	r0.x = asint(asfloat(r0.x) * specularFactor);
	r3.x = asint(dot(asfloat(r3.xyz), specMapIntMask));
	r0.x = asint(max(asfloat(r0.x), 1));
	r0.y = (0 < i.color.y) ? -1 : 0;
	r4.xy = asint(i.texcoord6.xy * WetDarken.ww);
	r1.w = asint(PuddleMaskSampler_tex.Sample(PuddleMaskSampler, asfloat(r4.xy)).x);
	r4.xy = asint(i.texcoord6.xy * float2(0.300000012, 0.300000012));
	r4.xyz = asint(WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, asfloat(r4.xy)).xyz);
	if (r0.y != 0) {
		r0.y = asint(asfloat(r1.w) + gWaterGlobals.y);
		r0.y = asint(saturate(asfloat(r0.y) + -(i.color.y)));
		r1.w = (0 < asfloat(r0.y)) ? -1 : 0;
		if (r1.w != 0) {
			r1.xyz = asint(asfloat(r1.xyz) * WetDarken.xyz);
			r1.w = asint(-(asfloat(r3.x)) + gWaterGlobals.z);
			r3.x = asint(asfloat(r0.y) * asfloat(r1.w) + asfloat(r3.x));
			r1.w = asint(-(asfloat(r0.x)) + gWaterGlobals.w);
			r0.x = asint(asfloat(r0.y) * asfloat(r1.w) + asfloat(r0.x));
			r4.xyz = asint(asfloat(r4.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
			r4.xyz = asint(asfloat(r4.xyz) * i.texcoord1.zzz + -(asfloat(r2.xyz)));
			r4.xyz = asint(asfloat(r0.yyy) * asfloat(r4.xyz) + asfloat(r2.xyz));
			r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
			r0.y = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
			r0.y = asint(rsqrt(asfloat(r0.y)));
			r2.xyz = asint(asfloat(r0.yyy) * asfloat(r4.xyz));
		} else {
			r0.y = asint(saturate(gWaterGlobals.y));
			r4.xyz = asint(asfloat(r1.xyz) * WetDarken.xyz + -(asfloat(r1.xyz)));
			r1.xyz = asint(asfloat(r0.yyy) * asfloat(r4.xyz) + asfloat(r1.xyz));
		}
	}
	r4.xyz = asint(asfloat(r2.xxx) * i.texcoord4.xyz);
	r2.xzw = asint(asfloat(r2.zzz) * i.texcoord1.xyz + asfloat(r4.xyz));
	r2.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz + asfloat(r2.xzw));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r2.xyz = asint(asfloat(r0.yyy) * asfloat(r2.xyz));
	r0.y = asint(asfloat(r0.w) * i.color.w);
	r0.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r0.www) * globalScalars2.zzz + asfloat(r1.xyz);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(saturate(asfloat(r0.x) * 0.00510204071));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r3.y = asint(sqrt(asfloat(r0.x)));
	r3.z = asint(i.color.x * gAmbientOcclusionEffect.w);
	r0.x = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	r3.w = 1148846080;
	o.sv_target2 = asfloat(r3);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r0.z;

	return o;
}
