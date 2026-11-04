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
	float3 specMapIntMask : packoffset(c0.y);
	float4 specMapExpMask : packoffset(c1);
	float bumpiness : packoffset(c2);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);

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
	float4 r2;
	float4 r3;
	int4 r4;
	float4 r5;
	r0.x = 1;
	r1.xyz = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r1 = asint(asfloat(r0.z) * asfloat(r1.xyxy));
	r0.z = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).w);
	r0.w = asint(parallaxScaleBias * 0.5);
	r0.z = asint(asfloat(r0.z) * parallaxScaleBias + -(asfloat(r0.w)));
	r1 = asint(asfloat(r0.z) * asfloat(r1) + i.texcoord.xyxy);
	r2 = ddy_coarse(asfloat(r1.zwzw));
	r3 = r2.zwzw * float4(-0.375, -0.375, -0.125, -0.125);
	r2 = r2 * float4(0.125, 0.125, 0.375, 0.375);
	r4 = asint(ddx_coarse(asfloat(r1.zwzw)));
	r3 = asfloat(r4.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + r3;
	r2 = asfloat(r4) * float4(-0.375, -0.375, 0.125, 0.125) + r2;
	r2 = asfloat(r1) + r2;
	r3 = asfloat(r1.zwzw) + r3;
	r0.zw = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r1.zw)).xy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, r3.xy));
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, r3.zw);
	r0.y = r1.w;
	r4.x = asint(asfloat(r1.w) + -0.5);
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = (asfloat(r4.x) >= 0) ? -1 : 0;
	r0.xy = r0.xy & r1.ww;
	r4.y = asint(r3.w + asfloat(r0.y));
	r4.z = asint(r3.w + -0.5);
	r4.z = (asfloat(r4.z) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r1.w & 1);
	r1.xyz = r1.xyz & r1.www;
	r0.xy = (r4.zz != 0) ? r4.xy : r0.xy;
	r5 = DiffuseSampler_tex.Sample(DiffuseSampler, r2.xy);
	r2 = DiffuseSampler_tex.Sample(DiffuseSampler, r2.zw);
	r4.y = asint(asfloat(r0.y) + r5.w);
	r4.x = r0.x + 4;
	r1.w = asint(r5.w + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r0.xy = (r1.ww != 0) ? r4.xy : r0.xy;
	r4.x = r0.x + 8;
	r4.y = asint(r2.w + asfloat(r0.y));
	r4.w = asint(r2.w + -0.5);
	r4.w = (asfloat(r4.w) >= 0) ? -1 : 0;
	r0.xy = (r4.ww != 0) ? r4.xy : r0.xy;
	r3.xyz = r3.xyz * r3.www + asfloat(r1.xyz);
	r1.xyz = (r4.zzz != 0) ? asint(r3.xyz) : r1.xyz;
	r3.xyz = r5.xyz * r5.www + asfloat(r1.xyz);
	r1.xyz = (r1.www != 0) ? asint(r3.xyz) : r1.xyz;
	r2.xyz = r2.xyz * r2.www + asfloat(r1.xyz);
	r1.xyz = (r4.www != 0) ? asint(r2.xyz) : r1.xyz;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r1.w = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r0.zw = asint(asfloat(r0.zw) * float2(2, 2) + float2(-1, -1));
	r0.zw = asint(asfloat(r0.zw) * bumpiness);
	r1.w = (asfloat(r1.w) >= 0.00200000009) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.x = saturate(i.color.x * asfloat(r1.w) + -1);
	r2.x = r2.x * globalScalars2.z;
	o.sv_target.xyz = asfloat(r1.xyz) * asfloat(r1.www) + r2.xxx;
	r0.y = asint(asfloat(r0.y) * i.color.w);
	o.sv_coverage = r0.x;
	r0.x = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	r0.y = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r1.xyz = asint(asfloat(r0.zzz) * i.texcoord4.xyz);
	r1.xyz = asint(asfloat(r0.yyy) * i.texcoord1.xyz + asfloat(r1.xyz));
	r0.yzw = asint(asfloat(r0.www) * i.texcoord5.xyz + asfloat(r1.xyz));
	r0.yzw = asint(asfloat(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.yzw = asint(asfloat(r0.yzw) * asfloat(r1.xxx));
	o.sv_target1.xyz = asfloat(r0.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r0.x = asint(asfloat(r1.w) * i.color.x);
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r1.x = asint(dot(asfloat(r0.xyz), specMapIntMask));
	r0.x = asint(dot(asfloat(r0), specMapExpMask));
	r0.x = asint(asfloat(r0.x) * specularFactor);
	r0.x = asint(max(asfloat(r0.x), 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.x = asfloat(r1.w) * asfloat(r1.x);
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
