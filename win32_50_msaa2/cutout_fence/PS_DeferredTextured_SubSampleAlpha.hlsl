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
	float HardAlphaBlend : packoffset(c0);
};

SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
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
	float4 r1;
	r0.xy = asint(floor(i.sv_position.xy));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) + 1);
	r0.x = (uint)asfloat(r0.x);
	r0.x = r0.x & 1;
	r0.x = (r0.x == 0) ? -1 : 0;
	r0.y = asint(-(g_AlphaRef) + 1);
	r0.y = asint(asfloat(r0.y) * 0.100000001);
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.z = asint(r1.w * globalScalars.x + -(g_AlphaRef));
	r0.y = asint(asfloat(r0.z) / asfloat(r0.y));
	r0.y = asint(-(r1.w) * globalScalars.x + asfloat(r0.y));
	r0.z = asint(r1.w * globalScalars.x);
	r0.y = asint(HardAlphaBlend * asfloat(r0.y) + asfloat(r0.z));
	r0.z = (asfloat(r0.y) < 0.949999988) ? -1 : 0;
	r0.y = (0.00392156886 >= asfloat(r0.y)) ? -1 : 0;
	r0.x = r0.x & r0.z;
	r0.x = r0.y | r0.x;
	if (r0.x != 0) discard;
	r0.x = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r0.xxx) * globalScalars2.zzz + r1.xyz;
	r0.x = asint(r1.w * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	o.sv_target.w = 0;
	o.sv_coverage = 255;
	r0.yzw = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0.yzw), asfloat(r0.yzw));
	r1.x = rsqrt(r1.x);
	r0.yzw = asint(asfloat(r0.yzw) * r1.xxx);
	o.sv_target1.xyz = asfloat(r0.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target2.xy = float2(0, 0.25);
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
