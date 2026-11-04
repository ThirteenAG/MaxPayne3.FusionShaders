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
	float4 r5;
	int4 r6;
	int2 r7;
	r0.x = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).w);
	r0.yzw = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.yz = asint(asfloat(r0.ww) * asfloat(r0.yz));
	r0.w = asint(parallaxScaleBias * 0.5);
	r0.x = asint(asfloat(r0.x) * parallaxScaleBias + -(asfloat(r0.w)));
	r0.xy = asint(asfloat(r0.xx) * asfloat(r0.yz) + i.texcoord.xy);
	r1 = asint(ddx_coarse(asfloat(r0.xyxy)));
	r2 = asint(ddy_coarse(asfloat(r0.xyxy)));
	r3 = asint(asfloat(r2.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r3 = asint(asfloat(r1.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r3));
	r3 = asint(asfloat(r0.xyxy) + asfloat(r3));
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)));
	r0.z = asint(asfloat(r4.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r3.x = 1;
	r3.y = r4.w;
	r3.xy = r0.zz & r3.xy;
	r5 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw));
	r0.w = asint(r5.w + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r6.x = (2 & ~1) | (r0.z & 1);
	r6.y = asint(asfloat(r3.y) + r5.w);
	r3.xy = (r0.ww != 0) ? r6.xy : r3.xy;
	r2 = asint(asfloat(r2) * float4(0.125, 0.125, 0.375, 0.375));
	r1 = asint(asfloat(r1) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r2));
	r1 = asint(asfloat(r0.xyxy) + asfloat(r1));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1.x = asint(asfloat(r2.w) + -0.5);
	r1.x = (asfloat(r1.x) >= 0) ? -1 : 0;
	r6.x = r3.x + 4;
	r6.y = asint(asfloat(r2.w) + asfloat(r3.y));
	r3.xy = (r1.xx != 0) ? r6.xy : r3.xy;
	r6 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r1.y = asint(asfloat(r6.w) + -0.5);
	r1.y = (asfloat(r1.y) >= 0) ? -1 : 0;
	r7.x = r3.x + 8;
	r7.y = asint(asfloat(r3.y) + asfloat(r6.w));
	r1.zw = (r1.yy != 0) ? r7.xy : r3.xy;
	r3.x = asint(asfloat(r1.w) * i.color.w);
	r3.x = asint(asfloat(r3.x) * globalScalars.x);
	r3.y = (g_AlphaRef >= asfloat(r3.x)) ? -1 : 0;
	if (r3.y != 0) discard;
	r0.xy = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r0.xy)).xy);
	r3.yzw = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r3.yzw = r0.zzz & r3.yzw;
	r4.xyz = asint(r5.xyz * r5.www + asfloat(r3.yzw));
	r3.yzw = (r0.www != 0) ? r4.xyz : r3.yzw;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.yzw));
	r2.xyz = (r1.xxx != 0) ? r2.xyz : r3.yzw;
	r3.yzw = asint(asfloat(r6.xyz) * asfloat(r6.www) + asfloat(r2.xyz));
	r2.xyz = (r1.yyy != 0) ? r3.yzw : r2.xyz;
	r1.xyw = asint(asfloat(r2.xyz) / asfloat(r1.www));
	r0.zw = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.zw = asint(asfloat(r0.zw) * bumpiness);
	r2.x = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r2.x = asint(-(asfloat(r2.x)) + 1);
	r2.x = asint(max(asfloat(r2.x), 0));
	r2.x = asint(sqrt(asfloat(r2.x)));
	r2.y = asint(max(specularFactor, 1));
	r3.yzw = asint(asfloat(r0.zzz) * i.texcoord4.xyz);
	r2.xzw = asint(asfloat(r2.xxx) * i.texcoord1.xyz + asfloat(r3.yzw));
	r2.xzw = asint(asfloat(r0.www) * i.texcoord5.xyz + asfloat(r2.xzw));
	r2.xzw = asint(asfloat(r2.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r2.xzw), asfloat(r2.xzw)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r2.xzw = asint(asfloat(r0.zzz) * asfloat(r2.xzw));
	r0.x = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.x = (asfloat(r0.x) >= 0.00200000009) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.y = asint(asfloat(r0.x) * i.color.x);
	o.sv_target2.x = asfloat(r0.x) * specularColorFactor;
	r0.z = asint(saturate(i.color.x * asfloat(r0.x) + -1));
	r0.z = asint(asfloat(r0.z) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r1.xyw) * asfloat(r0.xxx) + asfloat(r0.zzz);
	o.sv_target1.xyz = asfloat(r2.xzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.y) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = asfloat(r0.y) * gAmbientOcclusionEffect.w;
	o.sv_target.w = asfloat(r3.x);
	o.sv_target1.w = asfloat(r3.x);
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r3.x);
	o.sv_coverage = r1.z;

	return o;
}
