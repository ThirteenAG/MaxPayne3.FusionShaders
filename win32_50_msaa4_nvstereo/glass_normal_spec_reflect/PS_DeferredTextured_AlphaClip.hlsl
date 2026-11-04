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
	float4 r2;
	int4 r3;
	int4 r4;
	float4 r5;
	int4 r6;
	int4 r7;
	float3 r8;
	float3 r9;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx_coarse(i.texcoord.xyxy));
	r2 = ddy_coarse(i.texcoord.xyxy);
	r3 = asint(r2.zwzw * float4(-0.375, -0.375, -0.125, -0.125));
	r3 = asint(asfloat(r1.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r3));
	r3 = asint(asfloat(r3) + i.texcoord.xyxy);
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
	r2 = r2 * float4(0.125, 0.125, 0.375, 0.375);
	r1 = asint(asfloat(r1) * float4(-0.375, -0.375, 0.125, 0.125) + r2);
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy));
	r1.x = asint(r2.w + -0.5);
	r1.x = (asfloat(r1.x) >= 0) ? -1 : 0;
	r6.x = r3.x + 4;
	r6.y = asint(r2.w + asfloat(r3.y));
	r3.xy = (r1.xx != 0) ? r6.xy : r3.xy;
	r6 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r1.y = asint(asfloat(r6.w) + -0.5);
	r1.y = (asfloat(r1.y) >= 0) ? -1 : 0;
	r7.x = r3.x + 8;
	r7.y = asint(asfloat(r3.y) + asfloat(r6.w));
	r1.zw = (r1.yy != 0) ? r7.xy : r3.xy;
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r3.x = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r3.x = asint(-(asfloat(r3.x)) + 1);
	r3.x = asint(max(asfloat(r3.x), 0));
	r3.x = asint(sqrt(asfloat(r3.x)));
	r7 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r3.y = asint(dot(asfloat(r7), specMapExpMask));
	r3.y = asint(asfloat(r3.y) * specularFactor);
	r3.y = asint(max(asfloat(r3.y), 1));
	r8 = asfloat(r0.xxx) * i.texcoord4.xyz;
	r3.xzw = asint(asfloat(r3.xxx) * i.texcoord1.xyz + r8.xyz);
	r3.xzw = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r3.xzw));
	r3.xzw = asint(asfloat(r3.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xzw), asfloat(r3.xzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r3.xzw = asint(asfloat(r0.xxx) * asfloat(r3.xzw));
	r0.x = (0 < reflectivePower) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(asfloat(r3.y) * 0.015625);
		r0.x = asint(min(asfloat(r0.x), 1));
		r0.x = asint(-(asfloat(r0.x)) * 4 + 4);
		r8 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r0.y = asint(dot(r8.xyz, r8.xyz));
		r0.y = asint(rsqrt(asfloat(r0.y)));
		r8 = asfloat(r0.yyy) * r8.xyz;
		r0.y = asint(dot(-(r8.xyz), asfloat(r3.xzw)));
		r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
		r9 = asfloat(r3.xzw) * -(asfloat(r0.yyy)) + -(r8.xyz);
		r9 = r9.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r0.y = asint(dot(r9.xyz, r9.xyz));
		r0.y = asint(rsqrt(asfloat(r0.y)));
		r9 = asfloat(r0.yyy) * r9.zxy;
		r9.x = saturate(r9.x);
		r0.y = asint(r9.x + 1);
		r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
		r9.xy = r9.yz / asfloat(r0.yy);
		r9.xy = r9.xy + float2(0.5, 0.5);
		r9.xy = -(r9.xy) + float2(1, 1);
		r9 = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r9.xy, asfloat(r0.x)).xyz;
		r9 = r9.xyz * r9.xyz;
		r9 = r9.xyz * float3(16, 16, 16);
		r0.x = asint(saturate(dot(r8.xyz, asfloat(r3.xzw))));
		r0.y = asint(-(fresnelRolloff) + 1);
		r0.x = asint(-(asfloat(r0.x)) + 1.00001001);
		r7.w = asint(asfloat(r0.x) * asfloat(r0.x));
		r7.w = asint(asfloat(r7.w) * asfloat(r7.w));
		r0.x = asint(asfloat(r0.x) * asfloat(r7.w));
		r0.x = asint(fresnelRolloff * asfloat(r0.x) + asfloat(r0.y));
		r8 = asfloat(r0.xxx) * r9.xyz;
	} else {
		r8 = float3(0, 0, 0);
	}
	r0.x = asint(asfloat(r1.w) * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	r0.y = (g_AlphaRef >= asfloat(r0.x)) ? -1 : 0;
	if (r0.y != 0) discard;
	r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r4.xyz = r0.zzz & r4.xyz;
	r5.xyz = r5.xyz * r5.www + asfloat(r4.xyz);
	r0.yzw = (r0.www != 0) ? asint(r5.xyz) : r4.xyz;
	r2.xyz = r2.xyz * r2.www + asfloat(r0.yzw);
	r0.yzw = (r1.xxx != 0) ? asint(r2.xyz) : r0.yzw;
	r2.xyz = asfloat(r6.xyz) * asfloat(r6.www) + asfloat(r0.yzw);
	r0.yzw = (r1.yyy != 0) ? asint(r2.xyz) : r0.yzw;
	r0.yzw = asint(asfloat(r0.yzw) / asfloat(r1.www));
	o.sv_target2.x = dot(asfloat(r7.xyz), specMapIntMask);
	r1.xyw = asint(r8.xyz * reflectivePower);
	r2.x = dot(asfloat(r7.xyz), specMapReflectMask.xyz);
	r1.xyw = asint(asfloat(r1.xyw) * r2.xxx);
	r2.x = saturate(globalScalars.w);
	r1.xyw = asint(asfloat(r1.xyw) * r2.xxx);
	r2.x = saturate(i.color.x + -1);
	o.sv_target.xyz = r2.xxx * globalScalars2.zzz + asfloat(r0.yzw);
	o.sv_target1.xyz = asfloat(r3.xzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.y = asint(asfloat(r3.y) * 0.00510204071);
	r0.y = asint(min(asfloat(r0.y), 1));
	r0.y = asint(sqrt(asfloat(r0.y)));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r0.yzw = asint(saturate(asfloat(r1.xyw) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.yzw));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target2.w = 1000;
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.z;

	return o;
}
