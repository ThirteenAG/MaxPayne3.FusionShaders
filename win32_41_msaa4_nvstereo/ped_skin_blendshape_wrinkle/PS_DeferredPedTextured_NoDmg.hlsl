cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
};

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

cbuffer CacheSubSurface : register(b4)
{
	float4 SubColor : packoffset(c0);
	float SubScatWrap : packoffset(c1);
	float SubScatWidth : packoffset(c1.y);
};

cbuffer CachePedParam : register(b7)
{
	float ArmourStrength : packoffset(c0);
	float reflectivePower : packoffset(c0.y);
	float3 specMapReflectMask : packoffset(c1);
	float fresnelRolloff : packoffset(c1.w);
	float bumpiness : packoffset(c2);
	float displacementScale : packoffset(c2.y);
	float specularFactor : packoffset(c2.z);
	float3 specMapIntMask : packoffset(c3);
	float4 specMapExpMask : packoffset(c4);
	float4 matMaterialColorScale : packoffset(c5);
};

cbuffer Details : register(b9)
{
	float4 detailSettings : packoffset(c0);
};

cbuffer Wrinkles : register(b12)
{
	float4 wrinkleMaskStrengths0 : packoffset(c0);
	float4 wrinkleMaskStrengths1 : packoffset(c1);
	float4 wrinkleMaskStrengths2 : packoffset(c2);
	float4 wrinkleMaskStrengths3 : packoffset(c3);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s4);
SamplerState SpecSampler : register(s5);
SamplerState VolumeSampler : register(s6);
SamplerState WrinkleMaskSampler_0 : register(s7);
SamplerState WrinkleMaskSampler_1 : register(s8);
SamplerState WrinkleSampler_A : register(s9);
SamplerState WrinkleSampler_B : register(s10);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t4);
Texture2D SpecSampler_tex : register(t5);
Texture3D VolumeSampler_tex : register(t6);
Texture2D WrinkleMaskSampler_0_tex : register(t7);
Texture2D WrinkleMaskSampler_1_tex : register(t8);
Texture2D WrinkleSampler_A_tex : register(t9);
Texture2D WrinkleSampler_B_tex : register(t10);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
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
	float3 r6;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx(i.texcoord.xyxy));
	r2 = asint(ddy(i.texcoord.xyxy));
	r3 = asint(asfloat(r2.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r3 = asint(asfloat(r1.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r3));
	r3 = asint(asfloat(r3) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)).xwyz);
	r0.z = asint(asfloat(r4.y) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r5.xyz = asint(asfloat(r4.yyy) * asfloat(r4.xzw));
	r5.xyz = r0.zzz & r5.xyz;
	r4.x = 1;
	r3.xy = r0.zz & r4.xy;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw)));
	r0.w = asint(asfloat(r4.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r6.x = (r0.z != 0) ? 3 : 2;
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r5.xyz));
	r6.y = asfloat(r3.y) + asfloat(r4.w);
	r4.xyz = (r0.www != 0) ? r4.xyz : r5.xyz;
	r0.zw = (r0.ww != 0) ? asint(r6.xy) : r3.xy;
	r2 = asint(asfloat(r2) * float4(0.125, 0.125, 0.375, 0.375));
	r1 = asint(asfloat(r1) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1.x = asint(asfloat(r2.w) + -0.5);
	r1.x = (asfloat(r1.x) >= 0) ? -1 : 0;
	r3.x = r0.z + 4;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r4.xyz));
	r3.y = asint(asfloat(r0.w) + asfloat(r2.w));
	r2.xyz = (r1.xxx != 0) ? r2.xyz : r4.xyz;
	r0.zw = (r1.xx != 0) ? r3.xy : r0.zw;
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r2.w = asint(asfloat(r1.w) + -0.5);
	r2.w = (asfloat(r2.w) >= 0) ? -1 : 0;
	r3.x = r0.z + 8;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyz));
	r3.y = asint(asfloat(r0.w) + asfloat(r1.w));
	r1.xyz = (r2.www != 0) ? r1.xyz : r2.xyz;
	r0.zw = (r2.ww != 0) ? r3.xy : r0.zw;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r2 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r1.w = asint(dot(asfloat(r2), specMapExpMask));
	r1.w = asint(asfloat(r1.w) * specularFactor);
	r2.w = asint(dot(asfloat(r2.xyz), specMapIntMask.xyz));
	r1.w = asint(max(asfloat(r1.w), 1));
	r3.x = (0 < reflectivePower) ? -1 : 0;
	if (r3.x != 0) {
		r3.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
		r3.xy = asint(asfloat(r3.xy) * bumpiness);
		r3.z = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
		r3.z = asint(-(asfloat(r3.z)) + 1);
		r3.z = asint(max(asfloat(r3.z), 0));
		r3.z = asint(sqrt(asfloat(r3.z)));
		r4.xyz = asint(asfloat(r3.xxx) * i.texcoord4.xyz);
		r3.xzw = asint(asfloat(r3.zzz) * i.texcoord1.xyz + asfloat(r4.xyz));
		r3.xyz = asint(asfloat(r3.yyy) * i.texcoord5.xyz + asfloat(r3.xzw));
		r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r3.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
		r3.w = asint(rsqrt(asfloat(r3.w)));
		r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
		r3.w = asint(asfloat(r1.w) * 0.015625);
		r3.w = asint(min(asfloat(r3.w), 1));
		r3.w = asint(-(asfloat(r3.w)) * 4 + 4);
		r4.xyz = asint(i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r4.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
		r4.w = asint(rsqrt(asfloat(r4.w)));
		r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
		r4.w = asint(dot(-(asfloat(r4.xyz)), asfloat(r3.xyz)));
		r4.w = asint(asfloat(r4.w) + asfloat(r4.w));
		r5.xyz = asint(asfloat(r3.xyz) * -(asfloat(r4.www)) + -(asfloat(r4.xyz)));
		r5.xyz = asint(asfloat(r5.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r4.w = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
		r4.w = asint(rsqrt(asfloat(r4.w)));
		r5.xyz = asint(asfloat(r4.www) * asfloat(r5.zxy));
		r5.x = asint(saturate(asfloat(r5.x)));
		r4.w = asint(asfloat(r5.x) + 1);
		r4.w = asint(asfloat(r4.w) + asfloat(r4.w));
		r5.xy = asint(asfloat(r5.yz) / asfloat(r4.ww));
		r5.xy = asint(asfloat(r5.xy) + float2(0.5, 0.5));
		r5.xy = asint(-(asfloat(r5.xy)) + float2(1, 1));
		r5.xyz = asint(DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, asfloat(r5.xy), asfloat(r3.w)).xyz);
		r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.xyz));
		r5.xyz = asint(asfloat(r5.xyz) * float3(16, 16, 16));
		r3.x = asint(saturate(dot(asfloat(r4.xyz), asfloat(r3.xyz))));
		r3.y = asint(-(fresnelRolloff) + 1);
		r3.x = asint(-(asfloat(r3.x)) + 1.00001001);
		r3.z = asint(asfloat(r3.x) * asfloat(r3.x));
		r3.z = asint(asfloat(r3.z) * asfloat(r3.z));
		r3.x = asint(asfloat(r3.z) * asfloat(r3.x));
		r3.x = asint(fresnelRolloff * asfloat(r3.x) + asfloat(r3.y));
		r3.xyz = asint(asfloat(r3.xxx) * asfloat(r5.xyz));
	} else {
		r3.xyz = int3(0, 0, 0);
	}
	r3.xyz = asint(asfloat(r3.xyz) * reflectivePower);
	r2.x = asint(dot(asfloat(r2.xyz), specMapReflectMask.xyz));
	r3.xyz = asint(asfloat(r2.xxx) * asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) * ColorCorrectTopAndPedReflectScale.www);
	r4 = asint(WrinkleMaskSampler_0_tex.Sample(WrinkleMaskSampler_0, i.texcoord.xy));
	r5 = asint(WrinkleMaskSampler_1_tex.Sample(WrinkleMaskSampler_1, i.texcoord.xy));
	r2.x = asint(dot(wrinkleMaskStrengths0, asfloat(r4)));
	r2.y = asint(dot(wrinkleMaskStrengths1, asfloat(r5)));
	r2.x = asint(asfloat(r2.y) + asfloat(r2.x));
	r2.y = asint(dot(wrinkleMaskStrengths2, asfloat(r4)));
	r3.w = asint(dot(wrinkleMaskStrengths3, asfloat(r5)));
	r2.y = asint(asfloat(r2.y) + asfloat(r3.w));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.xy = asint(asfloat(r0.xy) + asfloat(r0.xy));
	r4.xyz = asint(WrinkleSampler_A_tex.Sample(WrinkleSampler_A, i.texcoord.xy).xyw);
	r3.w = asint(-(asfloat(r4.z)) + 1);
	r3.w = (asfloat(r3.w) < asfloat(r4.x)) ? -1 : 0;
	r3.w = r3.w & 1065353216;
	r4.xw = asint(-(asfloat(r4.zy)) + asfloat(r4.xy));
	r4.xy = asint(asfloat(r3.ww) * asfloat(r4.xw) + asfloat(r4.zy));
	r5.xyz = asint(WrinkleSampler_B_tex.Sample(WrinkleSampler_B, i.texcoord.xy).xyw);
	r3.w = asint(-(asfloat(r5.z)) + 1);
	r3.w = (asfloat(r3.w) < asfloat(r5.x)) ? -1 : 0;
	r3.w = r3.w & 1065353216;
	r4.zw = asint(-(asfloat(r5.zy)) + asfloat(r5.xy));
	r4.zw = asint(asfloat(r3.ww) * asfloat(r4.zw) + asfloat(r5.zy));
	r4 = asint(asfloat(r4) + float4(-0.5, -0.5, -0.5, -0.5));
	r4.xy = asint(asfloat(r4.xy) * float2(2, 2) + -(asfloat(r0.xy)));
	r0.xy = asint(asfloat(r2.xx) * asfloat(r4.xy) + asfloat(r0.xy));
	r4.xy = asint(asfloat(r4.zw) * float2(2, 2) + -(asfloat(r0.xy)));
	r4.xy = asint(asfloat(r2.yy) * asfloat(r4.xy) + asfloat(r0.xy));
	r0.x = asint(dot(asfloat(r4.xy), asfloat(r4.xy)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r4.z = asint(sqrt(asfloat(r0.x)));
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r4.xyz = asint(asfloat(r0.xxx) * asfloat(r4.xyz));
	r5.xyz = asint(asfloat(r4.xxx) * i.texcoord4.xyz);
	r4.xzw = asint(i.texcoord1.xyz * asfloat(r4.zzz) + asfloat(r5.xyz));
	r4.xyz = asint(i.texcoord5.xyz * asfloat(r4.yyy) + asfloat(r4.xzw));
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r5.xyz = asint(asfloat(r0.xxx) * asfloat(r4.xyz));
	r0.y = asint(dot(gDirectionalLight.xyz, asfloat(r5.xyz)));
	r0.y = asint(asfloat(r0.y) + SubScatWrap);
	r2.x = asint(SubScatWrap + 1);
	r0.y = asint(asfloat(r0.y) / asfloat(r2.x));
	r0.y = asint(max(asfloat(r0.y), 0));
	r2.x = asint(1 / SubScatWidth);
	r2.x = asint(saturate(asfloat(r0.y) * asfloat(r2.x)));
	r2.y = asint(asfloat(r2.x) * -2 + 3);
	r2.x = asint(asfloat(r2.x) * asfloat(r2.x));
	r2.x = asint(asfloat(r2.x) * asfloat(r2.y));
	r0.y = asint(-(SubScatWidth) * 2 + asfloat(r0.y));
	r2.y = asint(1 / -(SubScatWidth));
	r0.y = asint(saturate(asfloat(r0.y) * asfloat(r2.y)));
	r2.y = asint(asfloat(r0.y) * -2 + 3);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) * asfloat(r2.y));
	r0.y = asint(asfloat(r0.y) * asfloat(r2.x));
	r6 = asfloat(r0.yyy) * SubColor.xyz;
	r6 = asfloat(r0.www) * r6.xyz;
	r1.xyz = asint(r6.xyz * float3(0.5, 0.5, 0.5) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * matMaterialColorScale.xxx);
	r3.xyz = asint(asfloat(r3.xyz) * matMaterialColorScale.zzz);
	r0.y = asint(asfloat(r2.w) * matMaterialColorScale.w);
	r0.w = asint(asfloat(r1.w) * matMaterialColorScale.w);
	r2.xyw = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r2.xyw = asint(asfloat(r2.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyw = asint(asfloat(r1.www) * asfloat(r2.xyw));
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r4.xyz = asint(asfloat(r0.xxx) * asfloat(r4.xyz));
	r0.x = asint(dot(asfloat(r2.xyw), asfloat(r4.xyz)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r1.w = asint(saturate(asfloat(r0.y) * 5));
	r0.x = asint(asfloat(r0.x) * asfloat(r1.w));
	r2.x = asint(asfloat(r0.w) * 0.00510204071);
	r0.w = asint(saturate(-(asfloat(r0.w)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r0.w) * asfloat(r0.x) + asfloat(r0.y));
	r0.y = asint(asfloat(r2.z) * 16);
	r0.y = asint(trunc(asfloat(r0.y)));
	r4.xy = asint(i.texcoord.xy * detailSettings.zw);
	r0.y = asint(asfloat(r0.y) + 0.5);
	r4.z = asint(asfloat(r0.y) * 0.0625);
	r2.yzw = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r4.xyz)).xyz);
	r2.yzw = asint(asfloat(r2.zwy) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.y = asint(i.texcoord2.w * detailSettings.x);
	r0.y = asint(asfloat(r2.w) * asfloat(r0.y) + 1);
	o.sv_target.xyz = asfloat(r0.yyy) * asfloat(r1.xyz);
	r1.xyz = asint(asfloat(r2.zzz) * i.texcoord5.xyz);
	r1.xyz = asint(i.texcoord4.xyz * asfloat(r2.yyy) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * detailSettings.yyy);
	r1.xyz = asint(asfloat(r1.xyz) * i.texcoord2.www + asfloat(r5.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	o.sv_target2.x = saturate(asfloat(r0.y) * asfloat(r0.x));
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r2.x = asint(saturate(asfloat(r2.x)));
	r0.y = asint(sqrt(asfloat(r2.x)));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.x = asint(i.texcoord2.w * globalScalars.x);
	r1.xyz = asint(saturate(asfloat(r3.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r1.xyz));
	r0.yw = asint(frac(i.sv_position.xy));
	r0.yw = asint(asfloat(r0.yw) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yw)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r0.z;

	return o;
}
