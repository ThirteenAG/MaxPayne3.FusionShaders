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
	float specularColorFactor : packoffset(c0.w);
	float reflectivePower : packoffset(c1);
	float fresnelRolloff : packoffset(c1.y);
};

SamplerState DiffuseSampler : register(s0);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
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
	int4 r5;
	float2 r6;
	r0 = asint(ddx(i.texcoord.xyxy));
	r1 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.1875, -0.1875, 0.1875, 0.1875));
	r2 = asint(asfloat(r0.zwzw) * float4(0.0625, 0.0625, -0.0625, -0.0625) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)).xwyz);
	r2.x = asint(asfloat(r3.y) + -0.5);
	r2.x = (asfloat(r2.x) >= 0) ? -1 : 0;
	r4.xyz = asint(asfloat(r3.yyy) * asfloat(r3.xzw));
	r4.xyz = r2.xxx & r4.xyz;
	r3.x = 1;
	r3.xy = r2.xx & r3.xy;
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw)));
	r2.y = asint(asfloat(r5.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r6.x = (r2.x != 0) ? 3 : 2;
	r2.xzw = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r4.xyz));
	r6.y = asfloat(r3.y) + asfloat(r5.w);
	r2.xzw = (r2.yyy != 0) ? r2.xzw : r4.xyz;
	r3.xy = (r2.yy != 0) ? asint(r6.xy) : r3.xy;
	r4 = asint(asfloat(r1.zwzw) * float4(0.0625, 0.0625, -0.3125, -0.3125));
	r4 = asint(asfloat(r0.zwzw) * float4(0.3125, 0.3125, -0.1875, -0.1875) + asfloat(r4));
	r4 = asint(asfloat(r4) + i.texcoord.xyxy);
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)));
	r2.y = asint(asfloat(r5.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r4.x = r3.x + 4;
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r2.xzw));
	r4.y = asint(asfloat(r3.y) + asfloat(r5.w));
	r2.xzw = (r2.yyy != 0) ? r5.xyz : r2.xzw;
	r3.xy = (r2.yy != 0) ? r4.xy : r3.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r2.y = asint(asfloat(r4.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r5.x = r3.x + 8;
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xzw));
	r5.y = asint(asfloat(r3.y) + asfloat(r4.w));
	r2.xzw = (r2.yyy != 0) ? r4.xyz : r2.xzw;
	r3.xy = (r2.yy != 0) ? r5.xy : r3.xy;
	r4 = asint(asfloat(r1.zwzw) * float4(0.3125, 0.3125, -0.0625, -0.0625));
	r4 = asint(asfloat(r0.zwzw) * float4(-0.3125, -0.3125, -0.4375, -0.4375) + asfloat(r4));
	r4 = asint(asfloat(r4) + i.texcoord.xyxy);
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)));
	r2.y = asint(asfloat(r5.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r4.x = r3.x + 16;
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r2.xzw));
	r4.y = asint(asfloat(r3.y) + asfloat(r5.w));
	r2.xzw = (r2.yyy != 0) ? r5.xyz : r2.xzw;
	r3.xy = (r2.yy != 0) ? r4.xy : r3.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r2.y = asint(asfloat(r4.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r5.x = r3.x + 32;
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xzw));
	r5.y = asint(asfloat(r3.y) + asfloat(r4.w));
	r2.xzw = (r2.yyy != 0) ? r4.xyz : r2.xzw;
	r3.xy = (r2.yy != 0) ? r5.xy : r3.xy;
	r1 = asint(asfloat(r1) * float4(0.4375, 0.4375, -0.4375, -0.4375));
	r0 = asint(asfloat(r0) * float4(0.1875, 0.1875, 0.4375, 0.4375) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r4.x = r3.x + 64;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xzw));
	r4.y = asint(asfloat(r1.w) + asfloat(r3.y));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r2.xzw;
	r0.xy = (r0.xx != 0) ? r4.xy : r3.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.z = asint(asfloat(r2.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r3.x = r0.x + 128;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r1.xyz));
	r3.y = asint(asfloat(r0.y) + asfloat(r2.w));
	r1.xyz = (r0.zzz != 0) ? r2.xyz : r1.xyz;
	r0.xy = (r0.zz != 0) ? r3.xy : r0.xy;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r2.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r2.xyz = asint(asfloat(r0.zzz) * asfloat(r2.xyz));
	r0.z = asint(max(specularFactor, 1));
	r0.w = (0 < reflectivePower) ? -1 : 0;
	if (r0.w != 0) {
		r0.w = asint(asfloat(r0.z) * 0.015625);
		r0.w = asint(min(asfloat(r0.w), 1));
		r0.w = asint(-(asfloat(r0.w)) * 4 + 4);
		r3.xyz = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r2.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
		r2.w = asint(rsqrt(asfloat(r2.w)));
		r3.xyz = asint(asfloat(r2.www) * asfloat(r3.xyz));
		r2.w = asint(dot(-(asfloat(r3.xyz)), asfloat(r2.xyz)));
		r2.w = asint(asfloat(r2.w) + asfloat(r2.w));
		r4.xyz = asint(asfloat(r2.xyz) * -(asfloat(r2.www)) + -(asfloat(r3.xyz)));
		r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r2.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
		r2.w = asint(rsqrt(asfloat(r2.w)));
		r4.xyz = asint(asfloat(r2.www) * asfloat(r4.zxy));
		r4.x = asint(saturate(asfloat(r4.x)));
		r2.w = asint(asfloat(r4.x) + 1);
		r2.w = asint(asfloat(r2.w) + asfloat(r2.w));
		r4.xy = asint(asfloat(r4.yz) / asfloat(r2.ww));
		r4.xy = asint(asfloat(r4.xy) + float2(0.5, 0.5));
		r4.xy = asint(-(asfloat(r4.xy)) + float2(1, 1));
		r4.xyz = asint(DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, asfloat(r4.xy), asfloat(r0.w)).xyz);
		r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.xyz));
		r4.xyz = asint(asfloat(r4.xyz) * float3(16, 16, 16));
		r0.w = asint(saturate(dot(asfloat(r3.xyz), asfloat(r2.xyz))));
		r2.w = asint(-(fresnelRolloff) + 1);
		r0.w = asint(-(asfloat(r0.w)) + 1.00001001);
		r3.x = asint(asfloat(r0.w) * asfloat(r0.w));
		r3.x = asint(asfloat(r3.x) * asfloat(r3.x));
		r0.w = asint(asfloat(r0.w) * asfloat(r3.x));
		r0.w = asint(fresnelRolloff * asfloat(r0.w) + asfloat(r2.w));
		r3.xyz = asint(asfloat(r0.www) * asfloat(r4.xyz));
	} else {
		r3.xyz = int3(0, 0, 0);
	}
	r3.xyz = asint(asfloat(r3.xyz) * reflectivePower);
	r0.w = asint(saturate(globalScalars.w));
	r3.xyz = asint(asfloat(r0.www) * asfloat(r3.xyz));
	r1.w = r0.y;
	r1 = asint(asfloat(r1) * colorize);
	r0.y = asint(asfloat(r1.w) * i.color.w);
	r0.w = asint(saturate(globalScalars.z + -1));
	o.sv_target.xyz = asfloat(r0.www) * globalScalars2.zzz + asfloat(r1.xyz);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.z = asint(asfloat(r0.z) * 0.00510204071);
	r0.z = asint(min(asfloat(r0.z), 1));
	r0.z = asint(sqrt(asfloat(r0.z)));
	o.sv_target2.y = sqrt(asfloat(r0.z));
	o.sv_target2.z = globalScalars.z * gAmbientOcclusionEffect.w;
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	r1.xyz = asint(saturate(asfloat(r3.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r1.xyz));
	r0.zw = asint(frac(i.sv_position.xy));
	r0.zw = asint(asfloat(r0.zw) + float2(-0.5, -0.5));
	r0.z = asint(dot(abs(asfloat(r0.zw)), float2(1000, 1000)));
	r0.w = ((uint)r0.x < 255) ? -1 : 0;
	o.sv_target2.w = (r0.w != 0) ? 1000 : asfloat(r0.z);
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	o.sv_target2.x = specularColorFactor;
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r0.x;

	return o;
}
