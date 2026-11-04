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
	float reflectivePower : packoffset(c0.z);
	float fresnelRolloff : packoffset(c0.w);
};

SamplerState DiffuseSampler : register(s0);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	float4 sv_position : SV_Position;
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
	float4 r3;
	int4 r4;
	int4 r5;
	r0 = asint(ddx(i.texcoord.xyxy));
	r1 = asint(ddy(i.texcoord.xyxy));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r2.x = 1;
	r2.y = r1.w;
	r2.xy = r0.xx & r2.xy;
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw));
	r0.y = asint(r3.w + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (r0.x != 0) ? 3 : 2;
	r4.y = asint(asfloat(r2.y) + r3.w);
	r0.zw = (r0.yy != 0) ? r4.xy : r2.xy;
	r2.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r2.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz));
	r2.w = asint(max(specularFactor, 1));
	r4.x = (0 < reflectivePower) ? -1 : 0;
	if (r4.x != 0) {
		r4.x = asint(asfloat(r2.w) * 0.015625);
		r4.x = asint(min(asfloat(r4.x), 1));
		r4.x = asint(-(asfloat(r4.x)) * 4 + 4);
		r4.yzw = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r5.x = asint(dot(asfloat(r4.yzw), asfloat(r4.yzw)));
		r5.x = asint(rsqrt(asfloat(r5.x)));
		r4.yzw = asint(asfloat(r4.yzw) * asfloat(r5.xxx));
		r5.x = asint(dot(-(asfloat(r4.yzw)), asfloat(r2.xyz)));
		r5.x = asint(asfloat(r5.x) + asfloat(r5.x));
		r5.xyz = asint(asfloat(r2.xyz) * -(asfloat(r5.xxx)) + -(asfloat(r4.yzw)));
		r5.xyz = asint(asfloat(r5.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r5.w = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
		r5.w = asint(rsqrt(asfloat(r5.w)));
		r5.xyz = asint(asfloat(r5.www) * asfloat(r5.zxy));
		r5.x = asint(saturate(asfloat(r5.x)));
		r5.x = asint(asfloat(r5.x) + 1);
		r5.x = asint(asfloat(r5.x) + asfloat(r5.x));
		r5.xy = asint(asfloat(r5.yz) / asfloat(r5.xx));
		r5.xy = asint(asfloat(r5.xy) + float2(0.5, 0.5));
		r5.xy = asint(-(asfloat(r5.xy)) + float2(1, 1));
		r5.xyz = asint(DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, asfloat(r5.xy), asfloat(r4.x)).xyz);
		r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.xyz));
		r5.xyz = asint(asfloat(r5.xyz) * float3(16, 16, 16));
		r4.x = asint(saturate(dot(asfloat(r4.yzw), asfloat(r2.xyz))));
		r4.y = asint(-(fresnelRolloff) + 1);
		r4.x = asint(-(asfloat(r4.x)) + 1.00001001);
		r4.z = asint(asfloat(r4.x) * asfloat(r4.x));
		r4.z = asint(asfloat(r4.z) * asfloat(r4.z));
		r4.x = asint(asfloat(r4.z) * asfloat(r4.x));
		r4.x = asint(fresnelRolloff * asfloat(r4.x) + asfloat(r4.y));
		r4.xyz = asint(asfloat(r4.xxx) * asfloat(r5.xyz));
	} else {
		r4.xyz = int3(0, 0, 0);
	}
	r4.w = asint(asfloat(r0.w) * i.color.w);
	r4.w = asint(asfloat(r4.w) * globalScalars.x);
	r5.x = (g_AlphaRef >= asfloat(r4.w)) ? -1 : 0;
	if (r5.x != 0) discard;
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.xyz = r0.xxx & r1.xyz;
	r3.xyz = r3.xyz * r3.www + asfloat(r1.xyz);
	r1.xyz = (r0.yyy != 0) ? asint(r3.xyz) : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xyz = asint(asfloat(r4.xyz) * reflectivePower);
	r1.w = asint(saturate(globalScalars.w));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r1.www) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.w) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r0.xyw = asint(saturate(asfloat(r1.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyw));
	o.sv_target.w = asfloat(r4.w);
	o.sv_target1.w = asfloat(r4.w);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r4.w);
	o.sv_coverage = r0.z;

	return o;
}
