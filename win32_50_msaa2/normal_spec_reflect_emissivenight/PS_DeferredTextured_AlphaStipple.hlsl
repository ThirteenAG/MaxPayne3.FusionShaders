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
	float emissiveMultiplier : packoffset(c0);
	float emissiveReflectMultiplier : packoffset(c0.y);
	float specularFactor : packoffset(c0.z);
	float3 specMapIntMask : packoffset(c1);
	float4 specMapExpMask : packoffset(c2);
	float bumpiness : packoffset(c3);
	float reflectivePower : packoffset(c3.y);
	float fresnelRolloff : packoffset(c3.z);
	float3 specMapReflectMask : packoffset(c4);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
SamplerState EnvironmentSampler : register(s3);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D EnvironmentSampler_tex : register(t3);

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
	int3 r2;
	r0 = asint(ddy_coarse(i.texcoord.xyxy));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(ddx_coarse(i.texcoord.xyxy));
	r0 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r0));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r2 = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r1.z = asint(asfloat(r1.y) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r2 = r2.xyz & r1.zzz;
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r1.w = asint(asfloat(r0.w) + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r0.xyz = (r1.www != 0) ? r0.xyz : r2.xyz;
	r1.x = 1;
	r1.xy = r1.xy & r1.zz;
	r2.x = (2 & ~1) | (r1.z & 1);
	r2.y = asint(asfloat(r0.w) + asfloat(r1.y));
	r1.xy = (r1.ww != 0) ? r2.xy : r1.xy;
	r0.xyz = asint(asfloat(r0.xyz) / asfloat(r1.yyy));
	r0.w = r1.y;
	o.sv_coverage = r1.x;
	r0 = asint(asfloat(r0) * colorize);
	r1.x = asint(saturate(globalScalars.z + -1));
	o.sv_target.xyz = asfloat(r1.xxx) * globalScalars2.zzz + asfloat(r0.xyz);
	r0.x = asint(asfloat(r0.w) * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	r0.xzw = asint(asfloat(r0.zzz) * i.texcoord1.xyz + asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r0.xzw));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r1 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.w = asint(dot(asfloat(r1), specMapExpMask));
	r0.w = asint(asfloat(r0.w) * specularFactor);
	r0.w = asint(max(asfloat(r0.w), 1));
	r0.w = asint(asfloat(r0.w) * 0.00510204071);
	r0.w = asint(min(asfloat(r0.w), 1));
	r0.w = asint(sqrt(asfloat(r0.w)));
	o.sv_target2.y = sqrt(asfloat(r0.w));
	o.sv_target2.z = globalScalars.z * gAmbientOcclusionEffect.w;
	o.sv_target2.w = 1000;
	o.sv_target2.x = dot(asfloat(r1.xyz), specMapIntMask.xyz);
	r0.w = asint(dot(asfloat(r1.xyz), specMapReflectMask.xyz));
	r1.xyz = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = asint(dot(-(asfloat(r1.xyz)), asfloat(r0.xyz)));
	r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
	r2 = asint(asfloat(r0.xyz) * -(asfloat(r1.www)) + -(asfloat(r1.xyz)));
	r0.x = asint(saturate(dot(asfloat(r1.xyz), asfloat(r0.xyz))));
	r0.x = asint(-(asfloat(r0.x)) + 1.00001001);
	r1.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r0.yz = asint(asfloat(r1.xz) * asfloat(r0.yy) + float2(1, 1));
	r0.yz = asint(asfloat(r0.yz) * float2(-0.5, -0.5));
	r1.xyz = asint(EnvironmentSampler_tex.Sample(EnvironmentSampler, asfloat(r0.yz)).xyz);
	r0.y = asint(asfloat(r0.x) * asfloat(r0.x));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.y = asint(-(fresnelRolloff) + 1);
	r0.x = asint(fresnelRolloff * asfloat(r0.x) + asfloat(r0.y));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * reflectivePower);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * globalScalars.www);
	r0.xyz = asint(saturate(asfloat(r0.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyz));

	return o;
}
