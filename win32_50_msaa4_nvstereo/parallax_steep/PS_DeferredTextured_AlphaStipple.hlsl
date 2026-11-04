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
	int4 r5;
	int3 r6;
	int2 r7;
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
	r1 = asint(ddx_coarse(asfloat(r0.zwzw)));
	r3 = asint(ddy_coarse(asfloat(r0.zwzw)));
	r4 = asint(asfloat(r3.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r4 = asint(asfloat(r1.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r4));
	r4 = asint(asfloat(r0.zwzw) + asfloat(r4));
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)).xwyz);
	r2.z = asint(asfloat(r5.y) + -0.5);
	r2.z = (asfloat(r2.z) >= 0) ? -1 : 0;
	r6 = asint(asfloat(r5.yyy) * asfloat(r5.xzw));
	r6 = r2.zzz & r6.xyz;
	r5.x = 1;
	r4.xy = r2.zz & r5.xy;
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r2.w = asint(asfloat(r5.w) + -0.5);
	r2.w = (asfloat(r2.w) >= 0) ? -1 : 0;
	r7.x = (2 & ~1) | (r2.z & 1);
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r6.xyz));
	r7.y = asint(asfloat(r4.y) + asfloat(r5.w));
	r5.xyz = (r2.www != 0) ? r5.xyz : r6.xyz;
	r2.zw = (r2.ww != 0) ? r7.xy : r4.xy;
	r3 = asint(asfloat(r3) * float4(0.125, 0.125, 0.375, 0.375));
	r1 = asint(asfloat(r1) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r3));
	r0 = asint(asfloat(r0) + asfloat(r1));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r3.x = r2.z + 4;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r5.xyz));
	r3.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r5.xyz;
	r0.xy = (r0.xx != 0) ? r3.xy : r2.zw;
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.z = asint(asfloat(r3.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r4.x = r0.x + 8;
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r1.xyz));
	r4.y = asint(asfloat(r0.y) + asfloat(r3.w));
	r1.xyz = (r0.zzz != 0) ? r3.xyz : r1.xyz;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r0.zw = asint(asfloat(r2.xy) * float2(2, 2) + float2(-1, -1));
	r0.zw = asint(asfloat(r0.zw) * bumpiness);
	r1.w = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2.z = asint(max(specularFactor, 1));
	r3.xyz = asint(asfloat(r0.zzz) * i.texcoord4.xyz);
	r3.xyz = asint(asfloat(r1.www) * i.texcoord1.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r0.www) * i.texcoord5.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r3.xyz = asint(asfloat(r0.zzz) * asfloat(r3.xyz));
	r0.z = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
	r0.z = (asfloat(r0.z) >= 0.00200000009) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	r0.w = asint(asfloat(r0.z) * i.color.x);
	o.sv_target2.x = asfloat(r0.z) * specularColorFactor;
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r1.w = asint(saturate(i.color.x * asfloat(r0.z) + -1));
	r1.w = asint(asfloat(r1.w) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r1.xyz) * asfloat(r0.zzz) + asfloat(r1.www);
	o.sv_target1.xyz = asfloat(r3.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.z = asint(asfloat(r2.z) * 0.00510204071);
	r0.z = asint(min(asfloat(r0.z), 1));
	r0.z = asint(sqrt(asfloat(r0.z)));
	o.sv_target2.y = sqrt(asfloat(r0.z));
	o.sv_target2.z = asfloat(r0.w) * gAmbientOcclusionEffect.w;
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r0.x;

	return o;
}
