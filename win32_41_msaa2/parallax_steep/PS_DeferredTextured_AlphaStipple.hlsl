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

cbuffer CacheZShiftandParallax : register(b4)
{
	float parallaxScaleBias : packoffset(c0);
};

cbuffer CacheMegaVariables : register(b7)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
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
	float2 r5;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r1.xyz = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xy = asint(asfloat(r0.ww) * asfloat(r1.xy));
	r1.xy = asint(-(asfloat(r1.xy)) * parallaxScaleBias);
	r1.zw = asint(i.texcoord.xy);
	r0.w = 1065353216;
	r2.xyz = r0.xyz;
	r2.w = 0;
	while (true) {
		r3.x = (r2.w >= 8) ? -1 : 0;
		if (r3.x != 0) break;
		r3.x = (asfloat(r2.z) < asfloat(r0.w)) ? -1 : 0;
		r3.yz = asint(asfloat(r1.xy) * float2(0.125, 0.125) + asfloat(r1.zw));
		r4.xyz = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r3.yz)).xyw);
		if (r3.x != 0) {
			r0.w = asint(asfloat(r0.w) + -0.125);
			r1.zw = r3.yz;
			r2.xyz = r4.xyz;
		}
		r2.w = r2.w + 1;
	}
	r0 = r1.zwzw;
	r1 = asint(ddx(asfloat(r0.zwzw)));
	r3 = asint(ddy(asfloat(r0.zwzw)));
	r3 = asint(asfloat(r3) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r3));
	r0 = asint(asfloat(r0) + asfloat(r1));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0.x = asint(asfloat(r1.y) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r3.xyz = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r3.xyz = r0.xxx & r3.xyz;
	r1.x = 1;
	r1.xy = r0.xx & r1.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r4.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r5.x = (r0.x != 0) ? 0.000000 : 0.000000;
	r0.xzw = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r3.xyz));
	r5.y = asfloat(r1.y) + asfloat(r4.w);
	r0.xzw = (r0.yyy != 0) ? r0.xzw : r3.xyz;
	r1.xy = (r0.yy != 0) ? asint(r5.xy) : r1.xy;
	r0.xyz = asint(asfloat(r0.xzw) / asfloat(r1.yyy));
	r1.zw = asint(asfloat(r2.xy) * float2(2, 2) + float2(-1, -1));
	r1.zw = asint(asfloat(r1.zw) * bumpiness);
	r0.w = asint(dot(asfloat(r1.zw), asfloat(r1.zw)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r2.z = asint(max(specularFactor, 1));
	r3.xyz = asint(asfloat(r1.zzz) * i.texcoord4.xyz);
	r3.xyz = asint(asfloat(r0.www) * i.texcoord1.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r1.www) * i.texcoord5.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r3.xyz = asint(asfloat(r0.www) * asfloat(r3.xyz));
	r0.w = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r0.w = (asfloat(r0.w) >= 0.00200000009) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.z = asint(asfloat(r0.w) * i.color.x);
	o.sv_target2.x = asfloat(r0.w) * specularColorFactor;
	r1.y = asint(asfloat(r1.y) * i.color.w);
	r1.w = asint(saturate(i.color.x * asfloat(r0.w) + -1));
	r1.w = asint(asfloat(r1.w) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r0.xyz) * asfloat(r0.www) + asfloat(r1.www);
	o.sv_target1.xyz = asfloat(r3.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.z) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = asfloat(r1.z) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r1.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.x;

	return o;
}
