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

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
};

cbuffer WallWet : register(b7)
{
	float4 WetDarken : packoffset(c0);
	float4 RainNormalControls : packoffset(c1);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState RainNormalSampler : register(s2);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D RainNormalSampler_tex : register(t2);

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
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx_coarse(i.texcoord.xyxy));
	r2 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r2) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)).xwyz);
	r0.z = asint(asfloat(r2.y) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r3.xyz = asint(asfloat(r2.yyy) * asfloat(r2.xzw));
	r3.xyz = r0.zzz & r3.xyz;
	r2.x = 1;
	r1.xy = r0.zz & r2.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r0.w = asint(asfloat(r2.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.z & 1);
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r4.y = asint(asfloat(r1.y) + asfloat(r2.w));
	r2.xyz = (r0.www != 0) ? r2.xyz : r3.xyz;
	r0.zw = (r0.ww != 0) ? r4.xy : r1.xy;
	r1.xyz = asint(asfloat(r2.xyz) / asfloat(r0.www));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r2.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.x = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r2.z = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(max(specularFactor, 1));
	r0.y = (0 < i.color.y) ? -1 : 0;
	r3.xy = asint(globalScalars2.yy * RainNormalControls.zw);
	r3.xy = asint(i.texcoord.xy * RainNormalControls.xy + asfloat(r3.xy));
	r3.xyz = asint(RainNormalSampler_tex.Sample(RainNormalSampler, asfloat(r3.xy)).xyw);
	if (r0.y != 0) {
		r0.y = asint(saturate(-(i.color.y) + gWaterGlobals.y));
		r1.w = (0 < asfloat(r0.y)) ? -1 : 0;
		if (r1.w != 0) {
			r1.xyz = asint(asfloat(r1.xyz) * WetDarken.xyz);
			r1.w = asint(gWaterGlobals.z + -(specularColorFactor));
			r4.x = asint(asfloat(r0.y) * asfloat(r1.w) + specularColorFactor);
			r1.w = asint(-(asfloat(r0.x)) + gWaterGlobals.w);
			r0.x = asint(asfloat(r0.y) * asfloat(r1.w) + asfloat(r0.x));
			r1.w = asint(-(asfloat(r3.z)) + 1);
			r1.w = (asfloat(r1.w) < asfloat(r3.x)) ? -1 : 0;
			r1.w = r1.w & 1065353216;
			r3.xw = asint(-(asfloat(r3.zy)) + asfloat(r3.xy));
			r3.xy = asint(asfloat(r1.ww) * asfloat(r3.xw) + asfloat(r3.zy));
			r3.xy = asint(asfloat(r3.xy) * float2(2, 2) + float2(-1, -1));
			r3.xy = asint(asfloat(r3.xy) * WetDarken.ww);
			r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
			r1.w = asint(-(asfloat(r1.w)) + 1);
			r1.w = asint(max(asfloat(r1.w), 0));
			r3.z = asint(sqrt(asfloat(r1.w)));
			r3.xyz = asint(-(asfloat(r2.xyz)) + asfloat(r3.xyz));
			r3.xyz = asint(asfloat(r0.yyy) * asfloat(r3.xyz) + asfloat(r2.xyz));
			r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
			r0.y = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
			r0.y = asint(rsqrt(asfloat(r0.y)));
			r2.xyz = asint(asfloat(r0.yyy) * asfloat(r3.xyz));
		} else {
			r0.y = asint(saturate(gWaterGlobals.y));
			r3.xyz = asint(asfloat(r1.xyz) * WetDarken.xyz + -(asfloat(r1.xyz)));
			r1.xyz = asint(asfloat(r0.yyy) * asfloat(r3.xyz) + asfloat(r1.xyz));
			r4.x = asint(specularColorFactor);
		}
	} else {
		r4.x = asint(specularColorFactor);
	}
	r0.y = asint(asfloat(r0.w) * i.color.w);
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	r0.w = (g_AlphaRef >= asfloat(r0.y)) ? -1 : 0;
	if (r0.w != 0) discard;
	r3.xyz = asint(asfloat(r2.xxx) * i.texcoord4.xyz);
	r2.xzw = asint(asfloat(r2.zzz) * i.texcoord1.xyz + asfloat(r3.xyz));
	r2.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz + asfloat(r2.xzw));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asint(asfloat(r0.www) * asfloat(r2.xyz));
	r0.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r0.www) * globalScalars2.zzz + asfloat(r1.xyz);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(saturate(asfloat(r0.x) * 0.00510204071));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r4.y = asint(sqrt(asfloat(r0.x)));
	r4.z = asint(i.color.x * gAmbientOcclusionEffect.w);
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	r4.w = 1148846080;
	o.sv_target2 = asfloat(r4);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r0.z;

	return o;
}
