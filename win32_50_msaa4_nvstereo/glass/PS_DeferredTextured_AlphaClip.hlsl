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
	int4 r3;
	int4 r4;
	float4 r5;
	int4 r6;
	float3 r7;
	float3 r8;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r2 = asint(asfloat(r0.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2.x = asint(asfloat(r3.w) + -0.5);
	r2.x = (asfloat(r2.x) >= 0) ? -1 : 0;
	r4.x = 1;
	r4.y = r3.w;
	r4.xy = r2.xx & r4.xy;
	r5 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw));
	r2.y = asint(r5.w + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r6.x = (2 & ~1) | (r2.x & 1);
	r6.y = asint(asfloat(r4.y) + r5.w);
	r2.zw = (r2.yy != 0) ? r6.xy : r4.xy;
	r1 = asint(asfloat(r1) * float4(0.125, 0.125, 0.375, 0.375));
	r0 = asint(asfloat(r0) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r4.x = r2.z + 4;
	r4.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.zw = (r0.xx != 0) ? r4.xy : r2.zw;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r4.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r6.x = r2.z + 8;
	r6.y = asint(asfloat(r2.w) + asfloat(r4.w));
	r0.zw = (r0.yy != 0) ? r6.xy : r2.zw;
	r6.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.z = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
	r2.z = asint(rsqrt(asfloat(r2.z)));
	r6.xyz = asint(asfloat(r2.zzz) * asfloat(r6.xyz));
	r2.z = asint(max(specularFactor, 1));
	r2.w = (0 < reflectivePower) ? -1 : 0;
	if (r2.w != 0) {
		r2.w = asint(asfloat(r2.z) * 0.015625);
		r2.w = asint(min(asfloat(r2.w), 1));
		r2.w = asint(-(asfloat(r2.w)) * 4 + 4);
		r7 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r6.w = asint(dot(r7.xyz, r7.xyz));
		r6.w = asint(rsqrt(asfloat(r6.w)));
		r7 = asfloat(r6.www) * r7.xyz;
		r6.w = asint(dot(-(r7.xyz), asfloat(r6.xyz)));
		r6.w = asint(asfloat(r6.w) + asfloat(r6.w));
		r8 = asfloat(r6.xyz) * -(asfloat(r6.www)) + -(r7.xyz);
		r8 = r8.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r6.w = asint(dot(r8.xyz, r8.xyz));
		r6.w = asint(rsqrt(asfloat(r6.w)));
		r8 = asfloat(r6.www) * r8.zxy;
		r8.x = saturate(r8.x);
		r6.w = asint(r8.x + 1);
		r6.w = asint(asfloat(r6.w) + asfloat(r6.w));
		r8.xy = r8.yz / asfloat(r6.ww);
		r8.xy = r8.xy + float2(0.5, 0.5);
		r8.xy = -(r8.xy) + float2(1, 1);
		r8 = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r8.xy, asfloat(r2.w)).xyz;
		r8 = r8.xyz * r8.xyz;
		r8 = r8.xyz * float3(16, 16, 16);
		r2.w = asint(saturate(dot(r7.xyz, asfloat(r6.xyz))));
		r6.w = asint(-(fresnelRolloff) + 1);
		r2.w = asint(-(asfloat(r2.w)) + 1.00001001);
		r7.x = asfloat(r2.w) * asfloat(r2.w);
		r7.x = r7.x * r7.x;
		r2.w = asint(asfloat(r2.w) * r7.x);
		r2.w = asint(fresnelRolloff * asfloat(r2.w) + asfloat(r6.w));
		r7 = asfloat(r2.www) * r8.xyz;
	} else {
		r7 = float3(0, 0, 0);
	}
	r2.w = asint(asfloat(r0.w) * i.color.w);
	r2.w = asint(asfloat(r2.w) * globalScalars.x);
	r6.w = (g_AlphaRef >= asfloat(r2.w)) ? -1 : 0;
	if (r6.w != 0) discard;
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r3.xyz = r2.xxx & r3.xyz;
	r5.xyz = r5.xyz * r5.www + asfloat(r3.xyz);
	r3.xyz = (r2.yyy != 0) ? asint(r5.xyz) : r3.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r3.xyz));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r3.xyz;
	r3.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r1.xyz));
	r1.xyz = (r0.yyy != 0) ? r3.xyz : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xyz = asint(r7.xyz * reflectivePower);
	r1.w = asint(saturate(globalScalars.w));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r1.www) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r6.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.z) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r0.xyw = asint(saturate(asfloat(r1.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyw));
	o.sv_target.w = asfloat(r2.w);
	o.sv_target1.w = asfloat(r2.w);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r2.w);
	o.sv_coverage = r0.z;

	return o;
}
