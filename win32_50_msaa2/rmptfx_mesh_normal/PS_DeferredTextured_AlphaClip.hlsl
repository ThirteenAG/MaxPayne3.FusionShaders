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
	float4 r3;
	int2 r4;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0.x = asint(asfloat(r1.y) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r2.xyz = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r2.xyz = r0.xxx & r2.xyz;
	r1.x = 1;
	r1.xy = r0.xx & r1.xy;
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw));
	r0.y = asint(r3.w + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.x & 1);
	r0.xzw = asint(r3.xyz * r3.www + asfloat(r2.xyz));
	r4.y = asint(asfloat(r1.y) + r3.w);
	r0.xzw = (r0.yyy != 0) ? r0.xzw : r2.xyz;
	r1.xy = (r0.yy != 0) ? r4.xy : r1.xy;
	r0.xyz = asint(asfloat(r0.xzw) / asfloat(r1.yyy));
	r0.w = r1.y;
	r0 = asint(asfloat(r0) * colorize);
	r0.w = asint(asfloat(r0.w) * i.color.w);
	r0.w = asint(asfloat(r0.w) * globalScalars.x);
	r1.y = (g_AlphaRef >= asfloat(r0.w)) ? -1 : 0;
	if (r1.y != 0) discard;
	r1.yzw = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r2.x = asint(-(asfloat(r1.w)) + 1);
	r2.x = (asfloat(r2.x) < asfloat(r1.y)) ? -1 : 0;
	r2.x = r2.x & 1065353216;
	r2.yz = asint(-(asfloat(r1.wz)) + asfloat(r1.yz));
	r1.yz = asint(asfloat(r2.xx) * asfloat(r2.yz) + asfloat(r1.wz));
	r1.yz = asint(asfloat(r1.yz) * float2(2, 2) + float2(-1, -1));
	r1.yz = asint(asfloat(r1.yz) * bumpiness);
	r1.w = asint(dot(asfloat(r1.yz), asfloat(r1.yz)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2.x = asint(max(specularFactor, 1));
	r2.yzw = asint(asfloat(r1.yyy) * i.texcoord4.xyz);
	r2.yzw = asint(asfloat(r1.www) * i.texcoord1.xyz + asfloat(r2.yzw));
	r1.yzw = asint(asfloat(r1.zzz) * i.texcoord5.xyz + asfloat(r2.yzw));
	r1.yzw = asint(asfloat(r1.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.y = asint(dot(asfloat(r1.yzw), asfloat(r1.yzw)));
	r2.y = asint(rsqrt(asfloat(r2.y)));
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r2.yyy));
	r2.y = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r2.yyy) * globalScalars2.zzz + asfloat(r0.xyz);
	o.sv_target1.xyz = asfloat(r1.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target.w = asfloat(r0.w);
	o.sv_target1.w = asfloat(r0.w);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.w);
	o.sv_coverage = r1.x;

	return o;
}
