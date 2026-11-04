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
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
SamplerState VolumeSampler : register(s3);
SamplerState ClothSweatMapSampler : register(s4);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture3D VolumeSampler_tex : register(t3);
Texture2D ClothSweatMapSampler_tex : register(t4);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = asint(-(i.texcoord4.w) + vSweatParams.z);
	r0.x = asint(saturate(asfloat(r0.x) / vSweatParams.w));
	r0.x = asint(asfloat(r0.x) * vSweatParams.y);
	r0.y = (vSweatParams.z < i.texcoord4.w) ? -1 : 0;
	r0.x = (r0.y != 0) ? 0 : r0.x;
	r1 = asint(ClothSweatMapSampler_tex.Sample(ClothSweatMapSampler, i.texcoord.xy));
	r0.y = asint(-(asfloat(r1.y)) + vSweatParams.x);
	r0.x = asint(saturate(max(asfloat(r0.x), asfloat(r0.y))));
	r0.y = asint(-(asfloat(r0.x)) + ClothDarken.w);
	r0.y = asint(asfloat(r0.y) / ClothDarken.w);
	r1.yzw = asint(-(ClothDarken.xyz) + float3(1, 1, 1));
	r0.yzw = asint(asfloat(r0.yyy) * asfloat(r1.yzw) + ClothDarken.xyz);
	r1.y = (ClothDarken.w < asfloat(r0.x)) ? -1 : 0;
	r0.yzw = (r1.yyy != 0) ? asint(ClothDarken.xyz) : r0.yzw;
	r2 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1.yzw = asint(r2.xyz + -(ClothDarkenColor.xyz));
	r2.x = r2.w * i.texcoord2.w;
	r2.x = r2.x * globalScalars.x;
	r0.yzw = asint(asfloat(r0.yzw) * asfloat(r1.yzw) + ClothDarkenColor.xyz);
	r0.yzw = asint(asfloat(r0.yzw) * matMaterialColorScale.xxx);
	r1.y = asint(i.texcoord2.w * detailSettings.x);
	r3.xy = i.texcoord.xy * detailSettings.zw;
	r4 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r1.z = asint(r4.z * 16);
	r1.z = asint(trunc(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) + 0.5);
	r3.z = asfloat(r1.z) * 0.0625;
	r3 = VolumeSampler_tex.Sample(VolumeSampler, r3.xyz);
	r2.yzw = r3.yzx * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.y = asint(r2.w * asfloat(r1.y) + 1);
	o.sv_target.xyz = asfloat(r0.yzw) * asfloat(r1.yyy);
	o.sv_target.w = r2.x;
	r0.yzw = asint(r2.zzz * i.texcoord5.xyz);
	r0.yzw = asint(i.texcoord4.xyz * r2.yyy + asfloat(r0.yzw));
	r0.yzw = asint(asfloat(r0.yzw) * detailSettings.yyy);
	r3 = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy);
	r1.z = asint(-(r3.w) + 1);
	r1.z = (asfloat(r1.z) < r3.x) ? -1 : 0;
	r1.z = r1.z & 1065353216;
	r2.yz = -(r3.wy) + r3.xy;
	r1.zw = asint(asfloat(r1.zz) * r2.yz + r3.wy);
	r1.zw = asint(asfloat(r1.zw) * float2(2, 2) + float2(-1, -1));
	r1.zw = asint(asfloat(r1.zw) * bumpiness);
	r2.y = dot(asfloat(r1.zw), asfloat(r1.zw));
	r2.y = -(r2.y) + 1;
	r2.y = max(r2.y, 0);
	r2.y = sqrt(r2.y);
	r3.xyz = asfloat(r1.zzz) * i.texcoord4.xyz;
	r2.yzw = r2.yyy * i.texcoord1.xyz + r3.xyz;
	r2.yzw = asfloat(r1.www) * i.texcoord5.xyz + r2.yzw;
	r2.yzw = r2.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r2.yzw, r2.yzw));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r3.xyz = asfloat(r1.zzz) * r2.yzw;
	r2.yzw = r2.yzw * asfloat(r1.zzz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.yzw = asint(asfloat(r0.yzw) * i.texcoord2.www + r3.xyz);
	r0.yzw = asint(asfloat(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.z = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r0.yzw = asint(asfloat(r0.yzw) * asfloat(r1.zzz));
	o.sv_target1.xyz = asfloat(r0.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = r2.x;
	r0.y = asint(dot(r2.yzw, r2.yzw));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r0.yzw = asint(asfloat(r0.yyy) * r2.yzw);
	r2.yzw = i.texcoord7.xyz + -(gViewInverse[3].xyz);
	r2.yzw = r2.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r2.yzw, r2.yzw));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r2.yzw = asfloat(r1.zzz) * r2.yzw;
	r0.y = asint(dot(r2.yzw, asfloat(r0.yzw)));
	r0.y = asint(asfloat(r0.y) * -1.5);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(asfloat(r0.y) * i.texcoord2.y);
	r0.z = asint(dot(r4.xyz, specMapIntMask.xyz));
	r0.w = asint(dot(r4, specMapExpMask));
	r0.w = asint(asfloat(r0.w) * specularFactor);
	r0.w = asint(max(asfloat(r0.w), 1));
	r1.x = asint(asfloat(r1.x) * ClothSweatSpec.x + -(asfloat(r0.z)));
	r0.z = asint(asfloat(r0.x) * asfloat(r1.x) + asfloat(r0.z));
	r0.z = asint(asfloat(r0.z) * matMaterialColorScale.w);
	r1.x = asint(saturate(asfloat(r0.z) * 5));
	r0.y = asint(asfloat(r0.y) * asfloat(r1.x));
	r1.x = asint(-(asfloat(r0.w)) + ClothSweatSpec.y);
	r0.x = asint(asfloat(r0.x) * asfloat(r1.x) + asfloat(r0.w));
	r0.x = asint(asfloat(r0.x) * matMaterialColorScale.w);
	r0.w = asint(saturate(-(asfloat(r0.x)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(saturate(asfloat(r0.x)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	r0.x = asint(asfloat(r0.w) * asfloat(r0.y) + asfloat(r0.z));
	o.sv_target2.x = saturate(asfloat(r1.y) * asfloat(r0.x));
	o.sv_target2.w = r2.x;
	o.sv_target3.w = r2.x;
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
