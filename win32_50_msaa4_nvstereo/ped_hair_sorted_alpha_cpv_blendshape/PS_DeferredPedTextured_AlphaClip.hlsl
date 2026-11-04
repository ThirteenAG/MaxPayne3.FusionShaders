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
	float reflectivePower : packoffset(c0.w);
	float3 specMapReflectMask : packoffset(c1);
	float fresnelRolloff : packoffset(c1.w);
	float bumpiness : packoffset(c2);
	float displacementScale : packoffset(c2.y);
	float specularFactor : packoffset(c2.z);
	float3 specMapIntMask : packoffset(c3);
	float4 specMapExpMask : packoffset(c4);
	float4 matMaterialColorScale : packoffset(c5);
	float2 anisotropicSpecularIntensity : packoffset(c6);
	float2 anisotropicSpecularExponent : packoffset(c6.z);
	float4 anisotropicSpecularColour : packoffset(c7);
	float4 specularNoiseMapUVScaleFactor : packoffset(c8);
};

cbuffer Details : register(b7)
{
	float4 detailSettings : packoffset(c0);
};

cbuffer Wet : register(b9)
{
	float4 WetDarken : packoffset(c0);
	float4 WetAnisotropicSpecularColour : packoffset(c1);
	float2 WetAnisotropicSpecular : packoffset(c2);
	float4 vHairParams : packoffset(c3);
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
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D AnisoNoiseSpecSampler_tex : register(t3);
Texture3D VolumeSampler_tex : register(t4);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
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
	float4 r2;
	int4 r3;
	int4 r4;
	float4 r5;
	int4 r6;
	int4 r7;
	float4 r8;
	float3 r9;
	int4 r10;
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
	r8.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r3.xzw = asint(asfloat(r3.xxx) * i.texcoord1.xyz + r8.xyz);
	r3.xzw = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r3.xzw));
	r3.xzw = asint(asfloat(r3.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xzw), asfloat(r3.xzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r8.xyz = asfloat(r0.xxx) * asfloat(r3.xzw);
	r0.y = (0 < reflectivePower) ? -1 : 0;
	if (r0.y != 0) {
		r0.y = asint(asfloat(r3.y) * 0.015625);
		r0.y = asint(min(asfloat(r0.y), 1));
		r0.y = asint(-(asfloat(r0.y)) * 4 + 4);
		r9 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r7.w = asint(dot(r9.xyz, r9.xyz));
		r7.w = asint(rsqrt(asfloat(r7.w)));
		r9 = asfloat(r7.www) * r9.xyz;
		r7.w = asint(dot(-(r9.xyz), r8.xyz));
		r7.w = asint(asfloat(r7.w) + asfloat(r7.w));
		r10.xyz = asint(r8.xyz * -(asfloat(r7.www)) + -(r9.xyz));
		r10.xyz = asint(asfloat(r10.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r7.w = asint(dot(asfloat(r10.xyz), asfloat(r10.xyz)));
		r7.w = asint(rsqrt(asfloat(r7.w)));
		r10.xyz = asint(asfloat(r7.www) * asfloat(r10.zxy));
		r10.x = asint(saturate(asfloat(r10.x)));
		r7.w = asint(asfloat(r10.x) + 1);
		r7.w = asint(asfloat(r7.w) + asfloat(r7.w));
		r10.xy = asint(asfloat(r10.yz) / asfloat(r7.ww));
		r10.xy = asint(asfloat(r10.xy) + float2(0.5, 0.5));
		r10.xy = asint(-(asfloat(r10.xy)) + float2(1, 1));
		r10.xyz = asint(DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, asfloat(r10.xy), asfloat(r0.y)).xyz);
		r10.xyz = asint(asfloat(r10.xyz) * asfloat(r10.xyz));
		r10.xyz = asint(asfloat(r10.xyz) * float3(16, 16, 16));
		r0.y = asint(saturate(dot(r9.xyz, r8.xyz)));
		r7.w = asint(-(fresnelRolloff) + 1);
		r0.y = asint(-(asfloat(r0.y)) + 1.00001001);
		r8.w = asfloat(r0.y) * asfloat(r0.y);
		r8.w = r8.w * r8.w;
		r0.y = asint(asfloat(r0.y) * r8.w);
		r0.y = asint(fresnelRolloff * asfloat(r0.y) + asfloat(r7.w));
		r9 = asfloat(r0.yyy) * asfloat(r10.xyz);
	} else {
		r9 = float3(0, 0, 0);
	}
	r10.xy = asint(i.sv_position.xy * float2(0.5, 0.5));
	r10.zw = (asfloat(r10.xy) >= -(asfloat(r10.xy))) ? -1 : 0;
	r10.xy = asint(frac(abs(asfloat(r10.xy))));
	r10.xy = (r10.zw != 0) ? r10.xy : asint(-(asfloat(r10.xy)));
	r10.xy = asint(asfloat(r10.xy) + asfloat(r10.xy));
	r10.xy = asint(floor(asfloat(r10.xy)));
	r0.y = asint(asfloat(r10.y) * 2 + asfloat(r10.x));
	r0.y = (uint)asfloat(r0.y);
	r0.y = asint(dot(stipplePattern, icb[r0.y]));
	r0.y = (asfloat(r0.y) >= asfloat(r1.w)) ? -1 : 0;
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
	r1.x = asint(dot(asfloat(r7.xyz), specMapIntMask.xyz));
	r2.xyz = r9.xyz * reflectivePower;
	r1.y = asint(dot(asfloat(r7.xyz), specMapReflectMask.xyz));
	r2.xyz = asfloat(r1.yyy) * r2.xyz;
	r2.xyz = r2.xyz * ColorCorrectTopAndPedReflectScale.www;
	r1.y = asint(asfloat(r1.w) * i.texcoord2.w);
	r0.yzw = asint(asfloat(r0.yzw) * matMaterialColorScale.xxx);
	r2.xyz = r2.xyz * matMaterialColorScale.zzz;
	r1.x = asint(asfloat(r1.x) * matMaterialColorScale.w);
	r1.w = asint(asfloat(r3.y) * matMaterialColorScale.w);
	r4.xyz = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = dot(asfloat(r4.xyz), asfloat(r4.xyz));
	r2.w = rsqrt(r2.w);
	r4.xyz = asint(r2.www * asfloat(r4.xyz));
	r3.xyz = asint(asfloat(r3.xzw) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r3.xyz = asint(asfloat(r0.xxx) * asfloat(r3.xyz));
	r0.x = asint(dot(asfloat(r4.xyz), asfloat(r3.xyz)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r2.w = saturate(asfloat(r1.x) * 5);
	r0.x = asint(asfloat(r0.x) * r2.w);
	r3.x = asint(asfloat(r1.w) * 0.00510204071);
	r1.w = asint(saturate(-(asfloat(r1.w)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x) + asfloat(r1.x));
	r1.x = asint(asfloat(r7.z) * 16);
	r1.x = asint(trunc(asfloat(r1.x)));
	r4.xy = asint(i.texcoord.xy * detailSettings.zw);
	r1.x = asint(asfloat(r1.x) + 0.5);
	r4.z = asint(asfloat(r1.x) * 0.0625);
	r3.yzw = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r4.xyz)).xyz);
	r3.yzw = asint(asfloat(r3.zwy) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(i.texcoord2.w * detailSettings.x);
	r1.x = asint(asfloat(r3.w) * asfloat(r1.x) + 1);
	r4.xyz = asint(asfloat(r3.zzz) * i.texcoord5.xyz);
	r3.yzw = asint(i.texcoord4.xyz * asfloat(r3.yyy) + asfloat(r4.xyz));
	r3.yzw = asint(asfloat(r3.yzw) * detailSettings.yyy);
	r3.yzw = asint(asfloat(r3.yzw) * i.texcoord2.www + r8.xyz);
	r3.yzw = asint(asfloat(r3.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r3.yzw), asfloat(r3.yzw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.yzw = asint(asfloat(r1.www) * asfloat(r3.yzw));
	r0.x = asint(saturate(asfloat(r0.x) * asfloat(r1.x)));
	r4.xyz = asint(-(i.texcoord7.xyz) + gViewInverse[3].xyz);
	r5.xyz = i.texcoord4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r5.xyz, r5.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r5.xyz = asfloat(r1.www) * r5.xyz;
	r6 = asint(i.texcoord.xyxy * specularNoiseMapUVScaleFactor);
	r1.w = asint(AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, asfloat(r6.xy)).x);
	r6.xy = asint(AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, asfloat(r6.zw)).xy);
	r4.xyz = asint(asfloat(r4.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = dot(asfloat(r4.xyz), asfloat(r4.xyz));
	r2.w = rsqrt(r2.w);
	r4.xyz = asint(r2.www * asfloat(r4.xyz));
	r7.xyz = asint(gViewInverse[2].xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = dot(asfloat(r7.xyz), asfloat(r7.xyz));
	r2.w = rsqrt(r2.w);
	r7.xyz = asint(r2.www * asfloat(r7.xyz));
	r6.xy = asint(asfloat(r6.xy) * float2(2, 2) + float2(-1, -1));
	r6.xzw = asint(asfloat(r6.xxx) * i.texcoord1.xyz);
	r6.xzw = asint(asfloat(r6.xzw) * float3(0.100000001, 0.100000001, 0.100000001) + r5.xyz);
	r6.xzw = asint(asfloat(r6.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = dot(asfloat(r6.xzw), asfloat(r6.xzw));
	r2.w = rsqrt(r2.w);
	r6.xzw = asint(r2.www * asfloat(r6.xzw));
	r2.w = dot(asfloat(r4.xyz), asfloat(r6.xzw));
	r4.w = asint(dot(asfloat(r7.xyz), asfloat(r6.xzw)));
	r5.w = -(r2.w) * r2.w + 1;
	r5.w = max(r5.w, 0);
	r5.w = sqrt(r5.w);
	r6.x = asint(-(asfloat(r4.w)) * asfloat(r4.w) + 1);
	r6.x = asint(max(asfloat(r6.x), 0));
	r6.x = asint(sqrt(asfloat(r6.x)));
	r2.w = r2.w * asfloat(r4.w);
	r2.w = r5.w * asfloat(r6.x) + -(r2.w);
	r2.w = abs(r2.w) + 0.00000999999975;
	r6.xz = asint(-(anisotropicSpecularExponent.xy) + WetAnisotropicSpecular.xy);
	r6.xz = asint(vHairParams.xx * asfloat(r6.xz) + anisotropicSpecularExponent.xy);
	r6.xz = asint(asfloat(r6.xz) + float2(8.00000954, 16.0000095));
	r2.w = log2(r2.w);
	r2.w = r2.w * asfloat(r6.x);
	r2.w = exp2(r2.w);
	r5.xyz = i.texcoord1.xyz * asfloat(r6.yyy) + r5.xyz;
	r5.xyz = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r4.w = asint(dot(r5.xyz, r5.xyz));
	r4.w = asint(rsqrt(asfloat(r4.w)));
	r5.xyz = asfloat(r4.www) * r5.xyz;
	r4.x = asint(dot(asfloat(r4.xyz), r5.xyz));
	r4.y = asint(dot(asfloat(r7.xyz), r5.xyz));
	r4.z = asint(-(asfloat(r4.x)) * asfloat(r4.x) + 1);
	r4.z = asint(max(asfloat(r4.z), 0));
	r4.w = asint(-(asfloat(r4.y)) * asfloat(r4.y) + 1);
	r4.w = asint(max(asfloat(r4.w), 0));
	r4.zw = asint(sqrt(asfloat(r4.zw)));
	r4.x = asint(asfloat(r4.y) * asfloat(r4.x));
	r4.x = asint(asfloat(r4.z) * asfloat(r4.w) + -(asfloat(r4.x)));
	r4.x = asint(abs(asfloat(r4.x)) + 0.00000999999975);
	r4.x = asint(log2(asfloat(r4.x)));
	r4.x = asint(asfloat(r4.x) * asfloat(r6.z));
	r4.x = asint(exp2(asfloat(r4.x)));
	r2.w = r2.w + asfloat(r4.x);
	r0.x = asint(asfloat(r0.x) * r2.w);
	r2.w = anisotropicSpecularIntensity.x + 0.200000003;
	r0.x = asint(asfloat(r0.x) * r2.w);
	o.sv_target2.x = asfloat(r1.w) * asfloat(r0.x);
	r4.yzw = asint(-(anisotropicSpecularColour.xyz) + WetAnisotropicSpecularColour.xyz);
	r4.yzw = asint(vHairParams.xxx * asfloat(r4.yzw) + anisotropicSpecularColour.xyz);
	r4.xyz = asint(asfloat(r4.xxx) * asfloat(r4.yzw));
	r4.xyz = asint(asfloat(r4.xyz) * float3(0.5, 0.5, 0.5));
	r0.xyz = asint(asfloat(r0.yzw) * asfloat(r1.xxx) + asfloat(r4.xyz));
	r0.w = asint(i.texcoord2.x * 1.5);
	o.sv_target.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	r0.x = asint(saturate(asfloat(r1.y) * 1.70000005));
	r0.y = asint(saturate(gAmbientOcclusionEffect.z));
	r0.y = asint(saturate(asfloat(r0.y) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r3.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r3.x = asint(saturate(asfloat(r3.x)));
	r0.z = asint(sqrt(asfloat(r3.x)));
	o.sv_target2.y = sqrt(asfloat(r0.z));
	o.sv_target2.z = asfloat(r0.y) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	r0.yzw = asint(saturate(r2.xyz * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.yzw));
	r0.yz = asint(frac(i.sv_position.xy));
	r0.yz = asint(asfloat(r0.yz) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yz)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.z;

	return o;
}
