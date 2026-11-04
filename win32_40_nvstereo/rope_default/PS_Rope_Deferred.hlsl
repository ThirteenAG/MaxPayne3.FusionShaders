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
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
	float sv_clipdistance : SV_ClipDistance;
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

	int4 r0;
	float4 r1;
	r0.x = asint(saturate(i.color.x + -1));
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	o.sv_target.xyz = asfloat(r0.xxx) * globalScalars2.zzz + r1.xyz;
	r0.x = asint(r1.w * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	r1 = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy);
	r0.y = asint(-(r1.w) + 1);
	r0.y = (asfloat(r0.y) < r1.x) ? -1 : 0;
	r0.y = r0.y & 1065353216;
	r0.zw = asint(-(r1.wy) + r1.xy);
	r0.yz = asint(asfloat(r0.yy) * asfloat(r0.zw) + r1.wy);
	r0.yz = asint(asfloat(r0.yz) * float2(2, 2) + float2(-1, -1));
	r0.yz = asint(asfloat(r0.yz) * bumpiness);
	r0.w = asint(dot(asfloat(r0.yz), asfloat(r0.yz)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.xyz = asfloat(r0.yyy) * i.texcoord4.xyz;
	r1.xyz = asfloat(r0.www) * i.texcoord1.xyz + r1.xyz;
	r0.yzw = asint(asfloat(r0.zzz) * i.texcoord5.xyz + r1.xyz);
	r0.yzw = asint(asfloat(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0.yzw), asfloat(r0.yzw));
	r1.x = rsqrt(r1.x);
	r0.yzw = asint(asfloat(r0.yzw) * r1.xxx);
	o.sv_target1.xyz = asfloat(r0.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target2.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r0.x = asint(max(specularFactor, 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target2.x = specularColorFactor;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
