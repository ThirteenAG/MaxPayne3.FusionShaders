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
	noperspective centroid float4 sv_position : SV_Position;
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
	float4 r4;
	int4 r5;
	int4 r6;
	float4 r7;
	int4 r8;
	int4 r9;
	int4 r10;
	r0.x = 1;
	r1.xyz = asint(i.texcoord7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r1 = asint(asfloat(r0.z) * asfloat(r1.xyxy));
	r0.z = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).w);
	r0.w = asint(parallaxScaleBias * 0.5);
	r0.z = asint(asfloat(r0.z) * parallaxScaleBias + -(asfloat(r0.w)));
	r1 = asint(asfloat(r0.z) * asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(ddy_coarse(asfloat(r1.zwzw)));
	r3 = asint(asfloat(r2.zwzw) * float4(-0.1875, -0.1875, 0.1875, 0.1875));
	r4 = ddx_coarse(asfloat(r1.zwzw));
	r3 = asint(r4.zwzw * float4(0.0625, 0.0625, -0.0625, -0.0625) + asfloat(r3));
	r3 = asint(asfloat(r1.zwzw) + asfloat(r3));
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)));
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw)));
	r0.y = r5.w;
	r0.z = asint(asfloat(r5.w) + -0.5);
	r5.xyz = asint(asfloat(r5.www) * asfloat(r5.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = r0.xy & r0.zz;
	r6.y = asint(asfloat(r3.w) + asfloat(r0.y));
	r0.w = asint(asfloat(r3.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r6.x = (2 & ~1) | (r0.z & 1);
	r5.xyz = r5.xyz & r0.zzz;
	r0.xy = (r0.ww != 0) ? r6.xy : r0.xy;
	r6 = asint(asfloat(r2.zwzw) * float4(0.0625, 0.0625, -0.3125, -0.3125));
	r6 = asint(r4.zwzw * float4(0.3125, 0.3125, -0.1875, -0.1875) + asfloat(r6));
	r6 = asint(asfloat(r1.zwzw) + asfloat(r6));
	r7 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r6.xy));
	r6 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r6.zw)));
	r8.y = asint(asfloat(r0.y) + r7.w);
	r8.x = r0.x + 4;
	r0.z = asint(r7.w + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r8.xy : r0.xy;
	r8.x = r0.x + 8;
	r8.y = asint(asfloat(r6.w) + asfloat(r0.y));
	r5.w = asint(asfloat(r6.w) + -0.5);
	r5.w = (asfloat(r5.w) >= 0) ? -1 : 0;
	r0.xy = (r5.ww != 0) ? r8.xy : r0.xy;
	r8 = asint(asfloat(r2.zwzw) * float4(0.3125, 0.3125, -0.0625, -0.0625));
	r2 = asint(asfloat(r2) * float4(0.4375, 0.4375, -0.4375, -0.4375));
	r2 = asint(r4 * float4(0.1875, 0.1875, 0.4375, 0.4375) + asfloat(r2));
	r4 = r4.zwzw * float4(-0.3125, -0.3125, -0.4375, -0.4375) + asfloat(r8);
	r4 = asfloat(r1.zwzw) + r4;
	r2 = asint(asfloat(r1) + asfloat(r2));
	r1.xy = asint(BumpSampler_tex.Sample(BumpSampler, asfloat(r1.zw)).xy);
	r8 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, r4.xy));
	r4 = DiffuseSampler_tex.Sample(DiffuseSampler, r4.zw);
	r9.y = asint(asfloat(r0.y) + asfloat(r8.w));
	r9.x = r0.x + 16;
	r1.z = asint(asfloat(r8.w) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r0.xy = (r1.zz != 0) ? r9.xy : r0.xy;
	r9.x = r0.x + 32;
	r9.y = asint(r4.w + asfloat(r0.y));
	r1.w = asint(r4.w + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r0.xy = (r1.ww != 0) ? r9.xy : r0.xy;
	r9 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw)));
	r10.y = asint(asfloat(r0.y) + asfloat(r9.w));
	r10.x = r0.x + 64;
	r10.z = asint(asfloat(r9.w) + -0.5);
	r10.z = (asfloat(r10.z) >= 0) ? -1 : 0;
	r0.xy = (r10.zz != 0) ? r10.xy : r0.xy;
	r10.x = r0.x + 128;
	r10.y = asint(asfloat(r2.w) + asfloat(r0.y));
	r10.w = asint(asfloat(r2.w) + -0.5);
	r10.w = (asfloat(r10.w) >= 0) ? -1 : 0;
	r0.xy = (r10.ww != 0) ? r10.xy : r0.xy;
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r5.xyz));
	r3.xyz = (r0.www != 0) ? r3.xyz : r5.xyz;
	r5.xyz = asint(r7.xyz * r7.www + asfloat(r3.xyz));
	r3.xyz = (r0.zzz != 0) ? r5.xyz : r3.xyz;
	r5.xyz = asint(asfloat(r6.xyz) * asfloat(r6.www) + asfloat(r3.xyz));
	r3.xyz = (r5.www != 0) ? r5.xyz : r3.xyz;
	r5.xyz = asint(asfloat(r8.xyz) * asfloat(r8.www) + asfloat(r3.xyz));
	r3.xyz = (r1.zzz != 0) ? r5.xyz : r3.xyz;
	r4.xyz = r4.xyz * r4.www + asfloat(r3.xyz);
	r3.xyz = (r1.www != 0) ? asint(r4.xyz) : r3.xyz;
	r4.xyz = asfloat(r9.xyz) * asfloat(r9.www) + asfloat(r3.xyz);
	r3.xyz = (r10.zzz != 0) ? asint(r4.xyz) : r3.xyz;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r2.xyz = (r10.www != 0) ? r2.xyz : r3.xyz;
	r2.xyz = asint(asfloat(r2.xyz) / asfloat(r0.yyy));
	r0.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.xy = asint(asfloat(r1.xy) * float2(2, 2) + float2(-1, -1));
	r1.xy = asint(asfloat(r1.xy) * bumpiness);
	r0.z = (asfloat(r0.z) >= 0.00200000009) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	r0.w = asint(saturate(i.color.x * asfloat(r0.z) + -1));
	r0.w = asint(asfloat(r0.w) * globalScalars2.z);
	o.sv_target.xyz = asfloat(r2.xyz) * asfloat(r0.zzz) + asfloat(r0.www);
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.y);
	o.sv_coverage = r0.x;
	r0.x = ((uint)r0.x < 255) ? -1 : 0;
	r0.w = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.xzw = asint(asfloat(r1.xxx) * i.texcoord4.xyz);
	r1.xzw = asint(asfloat(r0.www) * i.texcoord1.xyz + asfloat(r1.xzw));
	r1.xyz = asint(asfloat(r1.yyy) * i.texcoord5.xyz + asfloat(r1.xzw));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = asfloat(r0.y);
	o.sv_target3.w = asfloat(r0.y);
	r0.yw = asint(frac(i.sv_position.xy));
	r0.yw = asint(asfloat(r0.yw) + float2(-0.5, -0.5));
	r0.y = asint(dot(abs(asfloat(r0.yw)), float2(1000, 1000)));
	o.sv_target2.w = (r0.x != 0) ? 1000 : asfloat(r0.y);
	r0.x = asint(asfloat(r0.z) * i.color.x);
	o.sv_target2.x = asfloat(r0.z) * specularColorFactor;
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.x = asint(max(specularFactor, 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
