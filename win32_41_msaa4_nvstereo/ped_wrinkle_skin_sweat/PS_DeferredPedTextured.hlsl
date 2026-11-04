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
	float bumpiness : packoffset(c0.y);
	float displacementScale : packoffset(c0.z);
	float specularFactor : packoffset(c0.w);
	float3 specMapIntMask : packoffset(c1);
	float4 specMapExpMask : packoffset(c2);
	float4 matMaterialColorScale : packoffset(c3);
	float4 gBloodData : packoffset(c4);
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

cbuffer SweatDetail : register(b13)
{
	float4 vNoiseParams : packoffset(c0);
	float4 SkinParams : packoffset(c1);
	float4 vSkinSweat : packoffset(c2);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BloodSampler : register(s2);
SamplerState BumpSampler : register(s4);
SamplerState SpecSampler : register(s5);
SamplerState VolumeSampler : register(s6);
SamplerState WrinkleMaskSampler_0 : register(s7);
SamplerState WrinkleMaskSampler_1 : register(s8);
SamplerState WrinkleSampler_A : register(s9);
SamplerState WrinkleSampler_B : register(s10);
SamplerState SweatMapSampler : register(s11);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BloodSampler_tex : register(t2);
Texture2D BumpSampler_tex : register(t4);
Texture2D SpecSampler_tex : register(t5);
Texture3D VolumeSampler_tex : register(t6);
Texture2D WrinkleMaskSampler_0_tex : register(t7);
Texture2D WrinkleMaskSampler_1_tex : register(t8);
Texture2D WrinkleSampler_A_tex : register(t9);
Texture2D WrinkleSampler_B_tex : register(t10);
Texture2D SweatMapSampler_tex : register(t11);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
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
	float4 r5;
	float2 r6;
	r0 = asint(ddx(i.texcoord.xyxy));
	r1 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r2 = asint(asfloat(r0.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)).xwyz);
	r2.x = asint(asfloat(r3.y) + -0.5);
	r2.x = (asfloat(r2.x) >= 0) ? -1 : 0;
	r4.xyz = asint(asfloat(r3.yyy) * asfloat(r3.xzw));
	r4.xyz = r2.xxx & r4.xyz;
	r3.x = 1;
	r3.xy = r2.xx & r3.xy;
	r5 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw));
	r2.y = asint(r5.w + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r6.x = (r2.x != 0) ? 3 : 2;
	r2.xzw = asint(r5.xyz * r5.www + asfloat(r4.xyz));
	r6.y = asfloat(r3.y) + r5.w;
	r2.xzw = (r2.yyy != 0) ? r2.xzw : r4.xyz;
	r3.xy = (r2.yy != 0) ? asint(r6.xy) : r3.xy;
	r1 = asint(asfloat(r1) * float4(0.125, 0.125, 0.375, 0.375));
	r0 = asint(asfloat(r0) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r4.x = r3.x + 4;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xzw));
	r4.y = asint(asfloat(r1.w) + asfloat(r3.y));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r2.xzw;
	r0.xy = (r0.xx != 0) ? r4.xy : r3.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.z = asint(asfloat(r2.w) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r3.x = r0.x + 8;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r1.xyz));
	r3.y = asint(asfloat(r0.y) + asfloat(r2.w));
	r1.xyz = (r0.zzz != 0) ? r2.xyz : r1.xyz;
	r0.xy = (r0.zz != 0) ? r3.xy : r0.xy;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r2 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.z = asint(dot(asfloat(r2), specMapExpMask));
	r0.z = asint(asfloat(r0.z) * specularFactor);
	r0.w = asint(dot(asfloat(r2.xyz), specMapIntMask.xyz));
	r0.z = asint(max(asfloat(r0.z), 1));
	r3 = asint(WrinkleMaskSampler_0_tex.Sample(WrinkleMaskSampler_0, i.texcoord.xy));
	r4 = asint(WrinkleMaskSampler_1_tex.Sample(WrinkleMaskSampler_1, i.texcoord.xy));
	r1.w = asint(dot(wrinkleMaskStrengths0, asfloat(r3)));
	r2.x = asint(dot(wrinkleMaskStrengths1, asfloat(r4)));
	r1.w = asint(asfloat(r1.w) + asfloat(r2.x));
	r2.x = asint(dot(wrinkleMaskStrengths2, asfloat(r3)));
	r2.y = asint(dot(wrinkleMaskStrengths3, asfloat(r4)));
	r2.x = asint(asfloat(r2.y) + asfloat(r2.x));
	r3.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r2.y = asint(-(asfloat(r3.z)) + 1);
	r2.y = (asfloat(r2.y) < asfloat(r3.x)) ? -1 : 0;
	r2.y = r2.y & 1065353216;
	r3.xw = asint(-(asfloat(r3.zy)) + asfloat(r3.xy));
	r2.yw = asint(asfloat(r2.yy) * asfloat(r3.xw) + asfloat(r3.zy));
	r2.yw = asint(asfloat(r2.yw) + float2(-0.5, -0.5));
	r2.yw = asint(asfloat(r2.yw) * bumpiness);
	r2.yw = asint(asfloat(r2.yw) + asfloat(r2.yw));
	r3.xyz = asint(WrinkleSampler_A_tex.Sample(WrinkleSampler_A, i.texcoord.xy).xyw);
	r3.w = asint(-(asfloat(r3.z)) + 1);
	r3.w = (asfloat(r3.w) < asfloat(r3.x)) ? -1 : 0;
	r3.w = r3.w & 1065353216;
	r4.xy = asint(-(asfloat(r3.zy)) + asfloat(r3.xy));
	r3.xy = asint(asfloat(r3.ww) * asfloat(r4.xy) + asfloat(r3.zy));
	r4.xyz = asint(WrinkleSampler_B_tex.Sample(WrinkleSampler_B, i.texcoord.xy).xyw);
	r3.z = asint(-(asfloat(r4.z)) + 1);
	r3.z = (asfloat(r3.z) < asfloat(r4.x)) ? -1 : 0;
	r3.z = r3.z & 1065353216;
	r4.xw = asint(-(asfloat(r4.zy)) + asfloat(r4.xy));
	r3.zw = asint(asfloat(r3.zz) * asfloat(r4.xw) + asfloat(r4.zy));
	r3 = asint(asfloat(r3) + float4(-0.5, -0.5, -0.5, -0.5));
	r3.xy = asint(asfloat(r3.xy) * float2(2, 2) + -(asfloat(r2.yw)));
	r2.yw = asint(asfloat(r1.ww) * asfloat(r3.xy) + asfloat(r2.yw));
	r3.xy = asint(asfloat(r3.zw) * float2(2, 2) + -(asfloat(r2.yw)));
	r3.xy = asint(asfloat(r2.xx) * asfloat(r3.xy) + asfloat(r2.yw));
	r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r3.z = asint(sqrt(asfloat(r1.w)));
	r2.xyw = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyw = asint(asfloat(r1.www) * asfloat(r2.xyw));
	r3.xyz = asint(asfloat(r2.xxx) * i.texcoord4.xyz);
	r3.xyz = asint(i.texcoord1.xyz * asfloat(r2.www) + asfloat(r3.xyz));
	r2.xyw = asint(i.texcoord5.xyz * asfloat(r2.yyy) + asfloat(r3.xyz));
	r2.xyw = asint(asfloat(r2.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.x = (0 < gBloodData.w) ? -1 : 0;
	if (r3.x != 0) {
		r3.xyw = asint(BloodSampler_tex.Sample(BloodSampler, i.texcoord.zw).xyw);
		r3.z = asint(min(asfloat(r3.y), asfloat(r3.x)));
		r3.w = asint(saturate(asfloat(r3.x) * 0.5 + asfloat(r3.w)));
		r3.xyz = asint(-(asfloat(r1.xyz)) + asfloat(r3.xyz));
		r1.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz) + asfloat(r1.xyz));
	}
	r2.xyw = asint(asfloat(r2.xyw) * asfloat(r1.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.xyz = asint(asfloat(r1.www) * asfloat(r2.xyw));
	r3.w = asint(dot(gDirectionalLight.xyz, asfloat(r3.xyz)));
	r3.w = asint(asfloat(r3.w) + SubScatWrap);
	r4.x = asint(SubScatWrap + 1);
	r3.w = asint(asfloat(r3.w) / asfloat(r4.x));
	r3.w = asint(max(asfloat(r3.w), 0));
	r4.x = asint(1 / SubScatWidth);
	r4.x = asint(saturate(asfloat(r3.w) * asfloat(r4.x)));
	r4.y = asint(asfloat(r4.x) * -2 + 3);
	r4.x = asint(asfloat(r4.x) * asfloat(r4.x));
	r4.x = asint(asfloat(r4.x) * asfloat(r4.y));
	r3.w = asint(-(SubScatWidth) * 2 + asfloat(r3.w));
	r4.y = asint(1 / -(SubScatWidth));
	r3.w = asint(saturate(asfloat(r3.w) * asfloat(r4.y)));
	r4.y = asint(asfloat(r3.w) * -2 + 3);
	r3.w = asint(asfloat(r3.w) * asfloat(r3.w));
	r3.w = asint(asfloat(r3.w) * asfloat(r4.y));
	r3.w = asint(asfloat(r3.w) * asfloat(r4.x));
	r4.xyz = asint(asfloat(r3.www) * SubColor.xyz);
	r4.xyz = asint(asfloat(r0.yyy) * asfloat(r4.xyz));
	r1.xyz = asint(asfloat(r4.xyz) * float3(0.5, 0.5, 0.5) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * matMaterialColorScale.xxx);
	r0.yz = asint(asfloat(r0.wz) * matMaterialColorScale.ww);
	r4.xyz = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r4.xyz = asint(asfloat(r0.www) * asfloat(r4.xyz));
	r2.xyw = asint(asfloat(r2.xyw) * asfloat(r1.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyw = asint(asfloat(r0.www) * asfloat(r2.xyw));
	r0.w = asint(dot(asfloat(r4.xyz), asfloat(r2.xyw)));
	r0.w = asint(asfloat(r0.w) * -1.5);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(asfloat(r0.w) * i.texcoord2.y);
	r1.w = asint(saturate(asfloat(r0.y) * 5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.w));
	r1.w = asint(saturate(-(asfloat(r0.z)) * 0.00999999978 + 1));
	r0.y = asint(asfloat(r1.w) * asfloat(r0.w) + asfloat(r0.y));
	r0.w = asint(asfloat(r2.z) * 16);
	r0.w = asint(trunc(asfloat(r0.w)));
	r2.xy = asint(i.texcoord.xy * detailSettings.zw);
	r0.w = asint(asfloat(r0.w) + 0.5);
	r2.z = asint(asfloat(r0.w) * 0.0625);
	r2.xyz = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r2.xyz)).xyz);
	r2.xyz = asint(asfloat(r2.yzx) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(i.texcoord2.w * detailSettings.x);
	r0.w = asint(asfloat(r2.z) * asfloat(r0.w) + 1);
	o.sv_target.xyz = asfloat(r0.www) * asfloat(r1.xyz);
	r1.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz);
	r1.xyz = asint(i.texcoord4.xyz * asfloat(r2.xxx) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * detailSettings.yyy);
	r1.xyz = asint(asfloat(r1.xyz) * i.texcoord2.www + asfloat(r3.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r0.y = asint(saturate(asfloat(r0.w) * asfloat(r0.y)));
	r0.y = asint(SkinParams.x * vSkinSweat.x + asfloat(r0.y));
	r2.y = asint(SkinParams.y * vSkinSweat.x + asfloat(r0.z));
	r2.zw = asint(vNoiseParams.zw * vSkinSweat.xx);
	r0.z = asint(asfloat(r0.w) * asfloat(r2.z) + asfloat(r2.w));
	r2.x = asint(asfloat(r0.z) + asfloat(r0.y));
	r0.yzw = asint(SweatMapSampler_tex.Sample(SweatMapSampler, i.texcoord.xy).xyz);
	r1.w = (vSkinSweat.y < asfloat(r0.w)) ? -1 : 0;
	r2.z = (asfloat(r0.w) < vSkinSweat.z) ? -1 : 0;
	r1.w = r1.w & r2.z;
	r0.w = asint(asfloat(r0.w) + -(vSkinSweat.y));
	r0.w = asint(saturate(asfloat(r0.w) / vSkinSweat.w));
	r2.zw = asint(-(asfloat(r2.xy)) + vNoiseParams.xy);
	r2.zw = asint(asfloat(r0.ww) * asfloat(r2.zw) + asfloat(r2.xy));
	r0.yz = asint(asfloat(r0.yz) + float2(-0.5, -0.5));
	r0.yz = asint(asfloat(r0.yz) * SkinParams.zz);
	r0.yz = asint(asfloat(r0.yz) + asfloat(r0.yz));
	r3.x = asint(dot(asfloat(r0.yz), asfloat(r0.yz)));
	r3.x = asint(-(asfloat(r3.x)) + 1);
	r3.x = asint(max(asfloat(r3.x), 0));
	r3.x = asint(sqrt(asfloat(r3.x)));
	r3.yzw = asint(asfloat(r0.yyy) * i.texcoord4.xyz);
	r3.xyz = asint(i.texcoord1.xyz * asfloat(r3.xxx) + asfloat(r3.yzw));
	r3.xyz = asint(asfloat(r0.zzz) * i.texcoord5.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r0.yyy) + -(asfloat(r1.xyz)));
	r0.yzw = asint(asfloat(r0.www) * asfloat(r3.xyz) + asfloat(r1.xyz));
	r0.yzw = asint(asfloat(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.x = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r3.x = asint(rsqrt(asfloat(r3.x)));
	r0.yzw = asint(asfloat(r0.yzw) * asfloat(r3.xxx));
	r0.yzw = (r1.www != 0) ? r0.yzw : r1.xyz;
	r1.xy = (r1.ww != 0) ? r2.zw : r2.xy;
	r1.z = asint(saturate(gAmbientOcclusionEffect.z));
	r1.z = asint(saturate(asfloat(r1.z) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r0.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.y = asint(saturate(asfloat(r1.y) * 0.00510204071));
	r0.y = asint(sqrt(asfloat(r0.y)));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target2.z = asfloat(r1.z) * gAmbientOcclusionEffect.w;
	r0.y = asint(i.texcoord2.w * globalScalars.x);
	r0.zw = asint(frac(i.sv_position.xy));
	r0.zw = asint(asfloat(r0.zw) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.zw)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	o.sv_target2.x = asfloat(r1.x);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r0.x;

	return o;
}
