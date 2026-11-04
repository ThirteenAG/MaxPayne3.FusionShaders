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
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D AnisoNoiseSpecSampler_tex : register(t3);
Texture3D VolumeSampler_tex : register(t4);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
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
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1.xy = asint(i.sv_position.xy * float2(0.5, 0.5));
	r1.zw = (asfloat(r1.xy) >= -(asfloat(r1.xy))) ? -1 : 0;
	r1.xy = asint(frac(abs(asfloat(r1.xy))));
	r1.xy = (r1.zw != 0) ? r1.xy : asint(-(asfloat(r1.xy)));
	r1.xy = asint(asfloat(r1.xy) + asfloat(r1.xy));
	r1.xy = asint(floor(asfloat(r1.xy)));
	r1.x = asint(asfloat(r1.y) * 2 + asfloat(r1.x));
	r1.x = (uint)asfloat(r1.x);
	r1.x = asint(dot(stipplePattern, icb[r1.x]));
	r1.x = (asfloat(r1.x) >= r0.w) ? -1 : 0;
	if (r1.x != 0) discard;
	r1 = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy));
	r1.z = asint(-(asfloat(r1.w)) + 1);
	r1.z = (asfloat(r1.z) < asfloat(r1.x)) ? -1 : 0;
	r1.z = r1.z & 1065353216;
	r2.xy = -(asfloat(r1.wy)) + asfloat(r1.xy);
	r1.xy = asint(asfloat(r1.zz) * r2.xy + asfloat(r1.wy));
	r1.xy = asint(asfloat(r1.xy) * float2(2, 2) + float2(-1, -1));
	r1.xy = asint(asfloat(r1.xy) * bumpiness);
	r1.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(max(asfloat(r1.z), 0));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r2 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r1.w = asint(dot(r2, specMapExpMask));
	r1.w = asint(asfloat(r1.w) * specularFactor);
	r2.x = dot(r2.xyz, specMapIntMask.xyz);
	r1.w = asint(max(asfloat(r1.w), 1));
	r3.xyz = asfloat(r1.xxx) * i.texcoord4.xyz;
	r3.xyz = asfloat(r1.zzz) * i.texcoord1.xyz + r3.xyz;
	r1.xyz = asint(asfloat(r1.yyy) * i.texcoord5.xyz + r3.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.y = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r2.y = rsqrt(r2.y);
	r3.xyz = asfloat(r1.xyz) * r2.yyy;
	r0.w = r0.w * i.texcoord2.w;
	r0.xyz = r0.xyz * matMaterialColorScale.xxx;
	r2.x = r2.x * matMaterialColorScale.w;
	r1.w = asint(asfloat(r1.w) * matMaterialColorScale.w);
	r4.xyz = i.texcoord7.xyz + -(gViewInverse[3].xyz);
	r4.xyz = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = dot(r4.xyz, r4.xyz);
	r2.w = rsqrt(r2.w);
	r4.xyz = r2.www * r4.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * r2.yyy + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.y = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r2.y = rsqrt(r2.y);
	r1.xyz = asint(asfloat(r1.xyz) * r2.yyy);
	r1.x = asint(dot(r4.xyz, asfloat(r1.xyz)));
	r1.x = asint(asfloat(r1.x) * -1.5);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(-(asfloat(r1.x)) + 1);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(asfloat(r1.x) * i.texcoord2.y);
	r1.y = asint(saturate(r2.x * 5));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	r4.x = asfloat(r1.w) * 0.00510204071;
	r1.y = asint(saturate(-(asfloat(r1.w)) * 0.00999999978 + 1));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x) + r2.x);
	r1.y = asint(r2.z * 16);
	r1.y = asint(trunc(asfloat(r1.y)));
	r2.xy = i.texcoord.xy * detailSettings.zw;
	r1.y = asint(asfloat(r1.y) + 0.5);
	r2.z = asfloat(r1.y) * 0.0625;
	r2 = VolumeSampler_tex.Sample(VolumeSampler, r2.xyz);
	r1.yzw = asint(r2.yzx * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.x = i.texcoord2.w * detailSettings.x;
	r1.w = asint(asfloat(r1.w) * r2.x + 1);
	r2.xyz = asfloat(r1.zzz) * i.texcoord5.xyz;
	r2.xyz = i.texcoord4.xyz * asfloat(r1.yyy) + r2.xyz;
	r2.xyz = r2.xyz * detailSettings.yyy;
	r2.xyz = r2.xyz * i.texcoord2.www + r3.xyz;
	r2.xyz = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.y = asint(dot(r2.xyz, r2.xyz));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r2.xyz = asfloat(r1.yyy) * r2.xyz;
	r1.x = asint(saturate(asfloat(r1.w) * asfloat(r1.x)));
	r3.xyz = -(i.texcoord7.xyz) + gViewInverse[3].xyz;
	r4.yzw = i.texcoord4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.y = asint(dot(r4.yzw, r4.yzw));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r4.yzw = asfloat(r1.yyy) * r4.yzw;
	r5 = i.texcoord.xyxy * specularNoiseMapUVScaleFactor;
	r6 = AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r5.xy);
	r5 = AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r5.zw);
	r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.y = asint(dot(r3.xyz, r3.xyz));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r3.xyz = asfloat(r1.yyy) * r3.xyz;
	r6.yzw = gViewInverse[2].xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.y = asint(dot(r6.yzw, r6.yzw));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r6.yzw = asfloat(r1.yyy) * r6.yzw;
	r1.yz = asint(r5.xy * float2(2, 2) + float2(-1, -1));
	r5.xyz = asfloat(r1.yyy) * i.texcoord1.xyz;
	r5.xyz = r5.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r4.yzw;
	r5.xyz = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.y = asint(dot(r5.xyz, r5.xyz));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r5.xyz = asfloat(r1.yyy) * r5.xyz;
	r1.y = asint(dot(r3.xyz, r5.xyz));
	r2.w = dot(r6.yzw, r5.xyz);
	r3.w = -(asfloat(r1.y)) * asfloat(r1.y) + 1;
	r3.w = max(r3.w, 0);
	r3.w = sqrt(r3.w);
	r5.x = -(r2.w) * r2.w + 1;
	r5.x = max(r5.x, 0);
	r5.x = sqrt(r5.x);
	r1.y = asint(asfloat(r1.y) * r2.w);
	r1.y = asint(r3.w * r5.x + -(asfloat(r1.y)));
	r1.y = asint(abs(asfloat(r1.y)) + 0.00000999999975);
	r5.xy = -(anisotropicSpecularExponent.xy) + WetAnisotropicSpecular.xy;
	r5.xy = vHairParams.xx * r5.xy + anisotropicSpecularExponent.xy;
	r5.xy = r5.xy + float2(8.00000954, 16.0000095);
	r1.y = asint(log2(asfloat(r1.y)));
	r1.y = asint(asfloat(r1.y) * r5.x);
	r1.y = asint(exp2(asfloat(r1.y)));
	r4.yzw = i.texcoord1.xyz * asfloat(r1.zzz) + r4.yzw;
	r4.yzw = r4.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r4.yzw, r4.yzw));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r4.yzw = asfloat(r1.zzz) * r4.yzw;
	r1.z = asint(dot(r3.xyz, r4.yzw));
	r2.w = dot(r6.yzw, r4.yzw);
	r3.x = -(asfloat(r1.z)) * asfloat(r1.z) + 1;
	r3.x = max(r3.x, 0);
	r3.y = -(r2.w) * r2.w + 1;
	r3.y = max(r3.y, 0);
	r3.xy = sqrt(r3.xy);
	r1.z = asint(asfloat(r1.z) * r2.w);
	r1.z = asint(r3.x * r3.y + -(asfloat(r1.z)));
	r1.z = asint(abs(asfloat(r1.z)) + 0.00000999999975);
	r1.z = asint(log2(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) * r5.y);
	r1.z = asint(exp2(asfloat(r1.z)));
	r1.y = asint(asfloat(r1.z) + asfloat(r1.y));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	r1.y = asint(anisotropicSpecularIntensity.x + 0.200000003);
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	o.sv_target2.x = r6.x * asfloat(r1.x);
	r3.xyz = -(anisotropicSpecularColour.xyz) + WetAnisotropicSpecularColour.xyz;
	r3.xyz = vHairParams.xxx * r3.xyz + anisotropicSpecularColour.xyz;
	r1.xyz = asint(asfloat(r1.zzz) * r3.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.5, 0.5, 0.5));
	r0.xyz = r0.xyz * asfloat(r1.www) + asfloat(r1.xyz);
	r1.x = asint(i.texcoord2.x * 1.5);
	o.sv_target.xyz = r0.xyz * asfloat(r1.xxx);
	r0.x = saturate(r0.w * 1.70000005);
	r0.y = saturate(gAmbientOcclusionEffect.z);
	r0.y = saturate(r0.y + i.texcoord2.x);
	o.sv_target1.xyz = r2.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r4.x = saturate(r4.x);
	r0.z = sqrt(r4.x);
	o.sv_target2.y = sqrt(r0.z);
	o.sv_target2.z = r0.y * gAmbientOcclusionEffect.w;
	r0.x = r0.x * globalScalars.x;
	o.sv_target.w = r0.x;
	o.sv_target1.w = r0.x;
	o.sv_target2.w = r0.x;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = r0.x;

	return o;
}
