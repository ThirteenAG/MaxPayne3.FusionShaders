cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float bumpiness : packoffset(c0.y);
	float displacementScale : packoffset(c0.z);
	float specularFactor : packoffset(c0.w);
	float3 specMapIntMask : packoffset(c1);
	float4 specMapExpMask : packoffset(c2);
	float4 matMaterialColorScale : packoffset(c3);
};

cbuffer Details : register(b7)
{
	float4 detailSettings : packoffset(c0);
};

cbuffer ClothSweat : register(b9)
{
	float4 vSweatParams : packoffset(c0);
	float4 ClothDarken : packoffset(c1);
	float4 ClothSweatSpec : packoffset(c2);
	float4 ClothDarkenColor : packoffset(c3);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s4);
SamplerState SpecSampler : register(s5);
SamplerState VolumeSampler : register(s6);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t4);
Texture2D SpecSampler_tex : register(t5);
Texture3D VolumeSampler_tex : register(t6);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
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
	int2 r6;
	r0.x = 1;
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.1875, -0.1875, 0.1875, 0.1875));
	r3 = asint(ddx_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r3.zwzw) * float4(0.0625, 0.0625, -0.0625, -0.0625) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw)));
	r0.y = r4.w;
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = r0.xy & r0.zz;
	r5.y = asint(asfloat(r2.w) + asfloat(r0.y));
	r5.x = (2 & ~1) | (r0.z & 1);
	r4.xyz = r4.xyz & r0.zzz;
	r0.z = asint(asfloat(r2.w) + -0.5);
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r4.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r2.xyz : r4.xyz;
	r4 = asint(asfloat(r1.zwzw) * float4(0.0625, 0.0625, -0.3125, -0.3125));
	r4 = asint(asfloat(r3.zwzw) * float4(0.3125, 0.3125, -0.1875, -0.1875) + asfloat(r4));
	r4 = asint(asfloat(r4) + i.texcoord.xyxy);
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)));
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r6.y = asint(asfloat(r0.y) + asfloat(r5.w));
	r6.x = r0.x + 4;
	r0.z = asint(asfloat(r5.w) + -0.5);
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r6.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r5.xyz : r2.xyz;
	r5.x = r0.x + 8;
	r5.y = asint(asfloat(r4.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r4.xyz : r2.xyz;
	r4 = asint(asfloat(r1.zwzw) * float4(0.3125, 0.3125, -0.0625, -0.0625));
	r1 = asint(asfloat(r1) * float4(0.4375, 0.4375, -0.4375, -0.4375));
	r1 = asint(asfloat(r3) * float4(0.1875, 0.1875, 0.4375, 0.4375) + asfloat(r1));
	r3 = asint(asfloat(r3.zwzw) * float4(-0.3125, -0.3125, -0.4375, -0.4375) + asfloat(r4));
	r3 = asint(asfloat(r3) + i.texcoord.xyxy);
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)));
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw)));
	r5.y = asint(asfloat(r0.y) + asfloat(r4.w));
	r5.x = r0.x + 16;
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r4.xyz : r2.xyz;
	r4.x = r0.x + 32;
	r4.y = asint(asfloat(r3.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r3.w) + -0.5);
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r4.y = asint(asfloat(r0.y) + asfloat(r3.w));
	r4.x = r0.x + 64;
	r0.z = asint(asfloat(r3.w) + -0.5);
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r3.x = r0.x + 128;
	r3.y = asint(asfloat(r1.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r1.w) + -0.5);
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r3.xy : r0.xy;
	r1.xyz = (r0.zzz != 0) ? r1.xyz : r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	r1.xyz = asint(asfloat(r1.xyz) + -(ClothDarkenColor.xyz));
	r0.z = asint(-(i.texcoord4.w) + vSweatParams.z);
	r0.z = asint(saturate(asfloat(r0.z) / vSweatParams.w));
	r0.z = asint(asfloat(r0.z) * vSweatParams.y);
	r0.w = (vSweatParams.z < i.texcoord4.w) ? -1 : 0;
	r0.z = (r0.w != 0) ? 0 : r0.z;
	r0.w = asint(-(asfloat(r0.z)) + ClothDarken.w);
	r0.w = asint(asfloat(r0.w) / ClothDarken.w);
	r2.xyz = asint(-(ClothDarken.xyz) + float3(1, 1, 1));
	r2.xyz = asint(asfloat(r0.www) * asfloat(r2.xyz) + ClothDarken.xyz);
	r0.w = (ClothDarken.w < asfloat(r0.z)) ? -1 : 0;
	r2.xyz = (r0.www != 0) ? asint(ClothDarken.xyz) : r2.xyz;
	r1.xyz = asint(asfloat(r2.xyz) * asfloat(r1.xyz) + ClothDarkenColor.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * matMaterialColorScale.xxx);
	r0.w = asint(i.texcoord2.w * detailSettings.x);
	r2.xy = asint(i.texcoord.xy * detailSettings.zw);
	r3 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r1.w = asint(asfloat(r3.z) * 16);
	r1.w = asint(trunc(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + 0.5);
	r2.z = asint(asfloat(r1.w) * 0.0625);
	r2.xyz = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r2.xyz)).xyz);
	r2.xyz = asint(asfloat(r2.yzx) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(asfloat(r2.z) * asfloat(r0.w) + 1);
	o.sv_target.xyz = asfloat(r0.www) * asfloat(r1.xyz);
	r0.y = asint(asfloat(r0.y) * i.texcoord2.w);
	o.sv_coverage = r0.x;
	r0.x = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	r1.xyz = asint(asfloat(r2.yyy) * i.texcoord5.xyz);
	r1.xyz = asint(i.texcoord4.xyz * asfloat(r2.xxx) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * detailSettings.yyy);
	r2.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.x = asint(-(asfloat(r2.z)) + 1);
	r0.x = (asfloat(r0.x) < asfloat(r2.x)) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r2.xw = asint(-(asfloat(r2.zy)) + asfloat(r2.xy));
	r0.xy = asint(asfloat(r0.xx) * asfloat(r2.xw) + asfloat(r2.zy));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r1.w = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	r2.xyz = asint(asfloat(r1.www) * i.texcoord1.xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r4.xyz = asint(asfloat(r0.xxx) * asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.xyz = asint(asfloat(r1.xyz) * i.texcoord2.www + asfloat(r4.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r1.xyz = asint(asfloat(r0.xxx) * asfloat(r1.xyz));
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r1.xyz = asint(asfloat(r0.xxx) * asfloat(r2.xyz));
	r2.xyz = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r2.xyz = asint(asfloat(r0.xxx) * asfloat(r2.xyz));
	r0.x = asint(dot(asfloat(r2.xyz), asfloat(r1.xyz)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r0.y = asint(dot(asfloat(r3.xyz), specMapIntMask.xyz));
	r1.x = asint(dot(asfloat(r3), specMapExpMask));
	r1.x = asint(asfloat(r1.x) * specularFactor);
	r1.x = asint(max(asfloat(r1.x), 1));
	r1.y = asint(-(asfloat(r0.y)) + ClothSweatSpec.x);
	r0.y = asint(asfloat(r0.z) * asfloat(r1.y) + asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) * matMaterialColorScale.w);
	r1.y = asint(saturate(asfloat(r0.y) * 5));
	r0.x = asint(asfloat(r0.x) * asfloat(r1.y));
	r1.y = asint(-(asfloat(r1.x)) + ClothSweatSpec.y);
	r0.z = asint(asfloat(r0.z) * asfloat(r1.y) + asfloat(r1.x));
	r0.z = asint(asfloat(r0.z) * matMaterialColorScale.w);
	r1.x = asint(saturate(-(asfloat(r0.z)) * 0.00999999978 + 1));
	r2.x = asint(asfloat(r0.z) * 0.00510204071);
	r2.x = asint(saturate(asfloat(r2.x)));
	r0.z = asint(sqrt(asfloat(r2.x)));
	o.sv_target2.y = sqrt(asfloat(r0.z));
	r0.x = asint(asfloat(r1.x) * asfloat(r0.x) + asfloat(r0.y));
	o.sv_target2.x = saturate(asfloat(r0.w) * asfloat(r0.x));
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
