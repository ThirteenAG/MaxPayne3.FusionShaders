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

cbuffer stipplingPattern : register(b3)
{
	float4 stipplePattern : packoffset(c0);
};

cbuffer CachePedParam : register(b4)
{
	float HardAlphaBlend : packoffset(c0);
	float AnisotropicAlphaBias : packoffset(c0.y);
	float ArmourStrength : packoffset(c0.z);
	float bumpiness : packoffset(c0.w);
	float displacementScale : packoffset(c1);
	float specularFactor : packoffset(c1.y);
	float3 specMapIntMask : packoffset(c2);
	float4 specMapExpMask : packoffset(c3);
	float4 matMaterialColorScale : packoffset(c4);
	float2 anisotropicSpecularIntensity : packoffset(c5);
	float2 anisotropicSpecularExponent : packoffset(c5.z);
	float4 anisotropicSpecularColour : packoffset(c6);
	float4 specularNoiseMapUVScaleFactor : packoffset(c7);
};

cbuffer Details : register(b7)
{
	float4 detailSettings : packoffset(c0);
};

static const float4 icb[4] =
{
	float4(1, 0, 0, 0),
	float4(0, 1, 0, 0),
	float4(0, 0, 1, 0),
	float4(0, 0, 0, 1),
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
SamplerState AnisoNoiseSpecSampler : register(s3);
SamplerState VolumeSampler : register(s4);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D AnisoNoiseSpecSampler_tex : register(t3);
Texture3D VolumeSampler_tex : register(t4);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
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
	int4 r6;
	r0 = asint(ddx(i.texcoord.xyxy));
	r1 = asint(ddy(i.texcoord.xyxy));
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
	r6.x = (r2.x != 0) ? 3 : 2;
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
	r2.zw = asint(i.sv_position.xy * float2(0.5, 0.5));
	r6.xy = (asfloat(r2.zw) >= -(asfloat(r2.zw))) ? -1 : 0;
	r2.zw = asint(frac(abs(asfloat(r2.zw))));
	r2.zw = (r6.xy != 0) ? r2.zw : asint(-(asfloat(r2.zw)));
	r2.zw = asint(asfloat(r2.zw) + asfloat(r2.zw));
	r2.zw = asint(floor(asfloat(r2.zw)));
	r2.z = asint(asfloat(r2.w) * 2 + asfloat(r2.z));
	r2.z = (uint)asfloat(r2.z);
	r2.z = asint(dot(stipplePattern, icb[r2.z]));
	r2.z = (asfloat(r2.z) >= asfloat(r0.w)) ? -1 : 0;
	if (r2.z != 0) discard;
	r6.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r2.z = asint(-(asfloat(r6.z)) + 1);
	r2.z = (asfloat(r2.z) < asfloat(r6.x)) ? -1 : 0;
	r2.z = r2.z & 1065353216;
	r6.xw = asint(-(asfloat(r6.zy)) + asfloat(r6.xy));
	r2.zw = asint(asfloat(r2.zz) * asfloat(r6.xw) + asfloat(r6.zy));
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r3.xyz = r2.xxx & r3.xyz;
	r5.xyz = r5.xyz * r5.www + asfloat(r3.xyz);
	r3.xyz = (r2.yyy != 0) ? asint(r5.xyz) : r3.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r3.xyz));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r3.xyz;
	r3.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r1.xyz));
	r1.xyz = (r0.yyy != 0) ? r3.xyz : r1.xyz;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r0.xy = asint(asfloat(r2.zw) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r1.w = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r2.w = asint(dot(asfloat(r2), specMapExpMask));
	r2.w = asint(asfloat(r2.w) * specularFactor);
	r2.x = asint(dot(asfloat(r2.xyz), specMapIntMask.xyz));
	r2.y = asint(max(asfloat(r2.w), 1));
	r3.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	r3.xyz = asint(asfloat(r1.www) * i.texcoord1.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r4.xyz = asint(asfloat(r0.xxx) * asfloat(r3.xyz));
	r0.y = asint(asfloat(r0.w) * i.texcoord2.w);
	r1.xyz = asint(asfloat(r1.xyz) * matMaterialColorScale.xxx);
	r0.w = asint(asfloat(r2.x) * matMaterialColorScale.w);
	r1.w = asint(asfloat(r2.y) * matMaterialColorScale.w);
	r2.xyw = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r2.xyw = asint(asfloat(r2.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r2.xyw = asint(asfloat(r2.xyw) * asfloat(r3.www));
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r3.xyz = asint(asfloat(r0.xxx) * asfloat(r3.xyz));
	r0.x = asint(dot(asfloat(r2.xyw), asfloat(r3.xyz)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r2.x = asint(saturate(asfloat(r0.w) * 5));
	r0.x = asint(asfloat(r0.x) * asfloat(r2.x));
	r2.x = asint(asfloat(r1.w) * 0.00510204071);
	r1.w = asint(saturate(-(asfloat(r1.w)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x) + asfloat(r0.w));
	r0.w = asint(asfloat(r2.z) * 16);
	r0.w = asint(trunc(asfloat(r0.w)));
	r3.xy = asint(i.texcoord.xy * detailSettings.zw);
	r0.w = asint(asfloat(r0.w) + 0.5);
	r3.z = asint(asfloat(r0.w) * 0.0625);
	r2.yzw = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r3.xyz)).xyz);
	r2.yzw = asint(asfloat(r2.zwy) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(i.texcoord2.w * detailSettings.x);
	r0.w = asint(asfloat(r2.w) * asfloat(r0.w) + 1);
	r3.xyz = asint(asfloat(r2.zzz) * i.texcoord5.xyz);
	r2.yzw = asint(i.texcoord4.xyz * asfloat(r2.yyy) + asfloat(r3.xyz));
	r2.yzw = asint(asfloat(r2.yzw) * detailSettings.yyy);
	r2.yzw = asint(asfloat(r2.yzw) * i.texcoord2.www + asfloat(r4.xyz));
	r2.yzw = asint(asfloat(r2.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.yzw), asfloat(r2.yzw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.yzw = asint(asfloat(r1.www) * asfloat(r2.yzw));
	r0.x = asint(saturate(asfloat(r0.w) * asfloat(r0.x)));
	r3.xyz = asint(-(i.texcoord7.xyz) + gViewInverse[3].xyz);
	r4.xyz = asint(i.texcoord4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4.xyz = asint(asfloat(r1.www) * asfloat(r4.xyz));
	r5 = i.texcoord.xyxy * specularNoiseMapUVScaleFactor;
	r1.w = asint(AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r5.xy).x);
	r5.xy = AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r5.zw).xy;
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r6.xyz = asint(gViewInverse[2].xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.w = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r6.xyz = asint(asfloat(r3.www) * asfloat(r6.xyz));
	r5.xy = r5.xy * float2(2, 2) + float2(-1, -1);
	r5.xzw = r5.xxx * i.texcoord1.xyz;
	r5.xzw = r5.xzw * float3(0.100000001, 0.100000001, 0.100000001) + asfloat(r4.xyz);
	r5.xzw = r5.xzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = asint(dot(r5.xzw, r5.xzw));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r5.xzw = asfloat(r3.www) * r5.xzw;
	r3.w = asint(dot(asfloat(r3.xyz), r5.xzw));
	r4.w = asint(dot(asfloat(r6.xyz), r5.xzw));
	r5.x = -(asfloat(r3.w)) * asfloat(r3.w) + 1;
	r5.x = max(r5.x, 0);
	r5.z = -(asfloat(r4.w)) * asfloat(r4.w) + 1;
	r5.z = max(r5.z, 0);
	r5.xz = sqrt(r5.xz);
	r3.w = asint(asfloat(r3.w) * asfloat(r4.w));
	r3.w = asint(r5.x * r5.z + -(asfloat(r3.w)));
	r3.w = asint(abs(asfloat(r3.w)) + 0.00000999999975);
	r5.xzw = float3(anisotropicSpecularExponent, anisotropicSpecularIntensity.x) + float3(8.00000954, 16.0000095, 0.200000003);
	r3.w = asint(log2(asfloat(r3.w)));
	r3.w = asint(asfloat(r3.w) * r5.x);
	r3.w = asint(exp2(asfloat(r3.w)));
	r4.xyz = asint(i.texcoord1.xyz * r5.yyy + asfloat(r4.xyz));
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r4.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r4.w = asint(rsqrt(asfloat(r4.w)));
	r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r3.x = asint(dot(asfloat(r3.xyz), asfloat(r4.xyz)));
	r3.y = asint(dot(asfloat(r6.xyz), asfloat(r4.xyz)));
	r3.z = asint(-(asfloat(r3.x)) * asfloat(r3.x) + 1);
	r3.z = asint(max(asfloat(r3.z), 0));
	r3.z = asint(sqrt(asfloat(r3.z)));
	r4.x = asint(-(asfloat(r3.y)) * asfloat(r3.y) + 1);
	r4.x = asint(max(asfloat(r4.x), 0));
	r4.x = asint(sqrt(asfloat(r4.x)));
	r3.x = asint(asfloat(r3.y) * asfloat(r3.x));
	r3.x = asint(asfloat(r3.z) * asfloat(r4.x) + -(asfloat(r3.x)));
	r3.x = asint(abs(asfloat(r3.x)) + 0.00000999999975);
	r3.x = asint(log2(asfloat(r3.x)));
	r3.x = asint(asfloat(r3.x) * r5.z);
	r3.x = asint(exp2(asfloat(r3.x)));
	r3.y = asint(asfloat(r3.x) + asfloat(r3.w));
	r0.x = asint(asfloat(r0.x) * asfloat(r3.y));
	r0.x = asint(r5.w * asfloat(r0.x));
	o.sv_target2.x = asfloat(r1.w) * asfloat(r0.x);
	r3.xyz = asint(asfloat(r3.xxx) * anisotropicSpecularColour.xyz);
	r3.xyz = asint(asfloat(r3.xyz) * float3(0.5, 0.5, 0.5));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r0.www) + asfloat(r3.xyz));
	r0.x = asint(i.texcoord2.x * 1.5);
	o.sv_target.xyz = asfloat(r0.xxx) * asfloat(r1.xyz);
	r0.x = asint(saturate(asfloat(r0.y) * 1.70000005));
	r0.y = asint(saturate(gAmbientOcclusionEffect.z));
	r0.y = asint(saturate(asfloat(r0.y) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r2.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r2.x = asint(saturate(asfloat(r2.x)));
	r0.w = asint(sqrt(asfloat(r2.x)));
	o.sv_target2.y = sqrt(asfloat(r0.w));
	o.sv_target2.z = asfloat(r0.y) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	r0.yw = asint(frac(i.sv_position.xy));
	r0.yw = asint(asfloat(r0.yw) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yw)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r0.z;

	return o;
}
