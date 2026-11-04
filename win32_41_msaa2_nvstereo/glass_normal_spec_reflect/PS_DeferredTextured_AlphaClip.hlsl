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
	float3 specMapIntMask : packoffset(c0.y);
	float4 specMapExpMask : packoffset(c1);
	float bumpiness : packoffset(c2);
	float reflectivePower : packoffset(c2.y);
	float fresnelRolloff : packoffset(c2.z);
	float3 specMapReflectMask : packoffset(c3);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

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
	int4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float3 r6;
	float3 r7;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx(i.texcoord.xyxy));
	r2 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r2) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r0.z = asint(asfloat(r2.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r1.x = 1;
	r1.y = r2.w;
	r1.xy = r0.zz & r1.xy;
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw));
	r0.w = asint(r3.w + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r4.x = (r0.z != 0) ? 0.000000 : 0.000000;
	r4.y = asfloat(r1.y) + r3.w;
	r1.xy = (r0.ww != 0) ? asint(r4.xy) : r1.xy;
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r1.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(max(asfloat(r1.z), 0));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r4 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r1.w = asint(dot(r4, specMapExpMask));
	r1.w = asint(asfloat(r1.w) * specularFactor);
	r1.w = asint(max(asfloat(r1.w), 1));
	r5 = asfloat(r0.xxx) * i.texcoord4.xyz;
	r5 = asfloat(r1.zzz) * i.texcoord1.xyz + r5.xyz;
	r5 = asfloat(r0.yyy) * i.texcoord5.xyz + r5.xyz;
	r5 = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.x = asint(dot(r5.xyz, r5.xyz));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r5 = asfloat(r0.xxx) * r5.xyz;
	r0.x = (0 < reflectivePower) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(asfloat(r1.w) * 0.015625);
		r0.x = asint(min(asfloat(r0.x), 1));
		r0.x = asint(-(asfloat(r0.x)) * 4 + 4);
		r6 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r0.y = asint(dot(r6.xyz, r6.xyz));
		r0.y = asint(rsqrt(asfloat(r0.y)));
		r6 = asfloat(r0.yyy) * r6.xyz;
		r0.y = asint(dot(-(r6.xyz), r5.xyz));
		r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
		r7 = r5.xyz * -(asfloat(r0.yyy)) + -(r6.xyz);
		r7 = r7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r0.y = asint(dot(r7.xyz, r7.xyz));
		r0.y = asint(rsqrt(asfloat(r0.y)));
		r7 = asfloat(r0.yyy) * r7.zxy;
		r7.x = saturate(r7.x);
		r0.y = asint(r7.x + 1);
		r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
		r7.xy = r7.yz / asfloat(r0.yy);
		r7.xy = r7.xy + float2(0.5, 0.5);
		r7.xy = -(r7.xy) + float2(1, 1);
		r7 = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r7.xy, asfloat(r0.x)).xyz;
		r7 = r7.xyz * r7.xyz;
		r7 = r7.xyz * float3(16, 16, 16);
		r0.x = asint(saturate(dot(r6.xyz, r5.xyz)));
		r0.y = asint(-(fresnelRolloff) + 1);
		r0.x = asint(-(asfloat(r0.x)) + 1.00001001);
		r1.z = asint(asfloat(r0.x) * asfloat(r0.x));
		r1.z = asint(asfloat(r1.z) * asfloat(r1.z));
		r0.x = asint(asfloat(r0.x) * asfloat(r1.z));
		r0.x = asint(fresnelRolloff * asfloat(r0.x) + asfloat(r0.y));
		r6 = asfloat(r0.xxx) * r7.xyz;
	} else {
		r6 = float3(0, 0, 0);
	}
	r0.x = asint(asfloat(r1.y) * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	r0.y = (g_AlphaRef >= asfloat(r0.x)) ? -1 : 0;
	if (r0.y != 0) discard;
	r2.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz));
	r2.xyz = r0.zzz & r2.xyz;
	r3.xyz = r3.xyz * r3.www + asfloat(r2.xyz);
	r0.yzw = (r0.www != 0) ? asint(r3.xyz) : r2.xyz;
	r0.yzw = asint(asfloat(r0.yzw) / asfloat(r1.yyy));
	o.sv_target2.x = dot(r4.xyz, specMapIntMask);
	r2.xyz = asint(r6.xyz * reflectivePower);
	r1.y = asint(dot(r4.xyz, specMapReflectMask.xyz));
	r2.xyz = asint(asfloat(r1.yyy) * asfloat(r2.xyz));
	r1.y = asint(saturate(globalScalars.w));
	r2.xyz = asint(asfloat(r1.yyy) * asfloat(r2.xyz));
	r1.y = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r1.yyy) * globalScalars2.zzz + asfloat(r0.yzw);
	o.sv_target1.xyz = r5.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.y = asint(asfloat(r1.w) * 0.00510204071);
	r0.y = asint(min(asfloat(r0.y), 1));
	r0.y = asint(sqrt(asfloat(r0.y)));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r0.yzw = asint(saturate(asfloat(r2.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.yzw));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.x;

	return o;
}
