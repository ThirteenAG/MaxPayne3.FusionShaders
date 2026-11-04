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
	float4 r1;
	float4 r2;
	float4 r3;
	int4 r4;
	float3 r5;
	float4 r6;
	r0.xy = asint(floor(i.sv_position.xy));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) + 1);
	r0.x = (uint)asfloat(r0.x);
	r0.x = r0.x & 1;
	r0.x = (r0.x == 0) ? -1 : 0;
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.y = asint(r1.w * i.texcoord2.w);
	r1.xyz = r1.xyz * matMaterialColorScale.xxx;
	r0.z = asint(asfloat(r0.y) * globalScalars.x + -0.00392156886);
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	r0.z = asint(asfloat(r0.z) * 10.0393705 + -(asfloat(r0.y)));
	r0.z = asint(HardAlphaBlend * asfloat(r0.z) + asfloat(r0.y));
	r0.zw = (float2(0.899999976, 0.00392156886) >= asfloat(r0.zz)) ? -1 : 0;
	r0.x = r0.z & r0.x;
	r0.x = r0.w | r0.x;
	if (r0.x != 0) discard;
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = asfloat(r0.y);
	r0.xyz = asint(-(i.texcoord7.xyz) + gViewInverse[3].xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2.xyz = i.texcoord4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asfloat(r0.www) * r2.xyz;
	r3 = i.texcoord.xyxy * specularNoiseMapUVScaleFactor;
	r3.zw = AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r3.zw).xy;
	r0.w = asint(AnisoNoiseSpecSampler_tex.Sample(AnisoNoiseSpecSampler, r3.xy).x);
	r3.xy = r3.zw * float2(2, 2) + float2(-1, -1);
	r3.yzw = i.texcoord1.xyz * r3.yyy + r2.xyz;
	r4.xyz = asint(r3.xxx * i.texcoord1.xyz);
	r2.xyz = asfloat(r4.xyz) * float3(0.100000001, 0.100000001, 0.100000001) + r2.xyz;
	r2.xyz = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.xyz = r3.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = dot(r3.xyz, r3.xyz);
	r1.w = rsqrt(r1.w);
	r3.xyz = r1.www * r3.xyz;
	r1.w = dot(asfloat(r0.xyz), r3.xyz);
	r2.w = -(r1.w) * r1.w + 1;
	r2.w = max(r2.w, 0);
	r2.w = sqrt(r2.w);
	r4.xyz = asint(gViewInverse[2].xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.w = dot(asfloat(r4.xyz), asfloat(r4.xyz));
	r3.w = rsqrt(r3.w);
	r4.xyz = asint(r3.www * asfloat(r4.xyz));
	r3.x = dot(asfloat(r4.xyz), r3.xyz);
	r1.w = r1.w * r3.x;
	r3.x = -(r3.x) * r3.x + 1;
	r3.x = max(r3.x, 0);
	r3.x = sqrt(r3.x);
	r1.w = r2.w * r3.x + -(r1.w);
	r1.w = abs(r1.w) + 0.00000999999975;
	r1.w = log2(r1.w);
	r3.xy = -(anisotropicSpecularExponent.xy) + WetAnisotropicSpecular.xy;
	r3.xy = vHairParams.xx * r3.xy + anisotropicSpecularExponent.xy;
	r3.xy = r3.xy + float2(8.00000954, 16.0000095);
	r1.w = r1.w * r3.y;
	r1.w = exp2(r1.w);
	r3.yzw = -(anisotropicSpecularColour.xyz) + WetAnisotropicSpecularColour.xyz;
	r3.yzw = vHairParams.xxx * r3.yzw + anisotropicSpecularColour.xyz;
	r3.yzw = r1.www * r3.yzw;
	r3.yzw = r3.yzw * float3(0.5, 0.5, 0.5);
	r2.w = i.texcoord2.w * detailSettings.x;
	r5.xy = i.texcoord.xy * detailSettings.zw;
	r6 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r4.w = asint(r6.z * 16);
	r4.w = asint(trunc(asfloat(r4.w)));
	r4.w = asint(asfloat(r4.w) + 0.5);
	r5.z = asfloat(r4.w) * 0.0625;
	r5 = VolumeSampler_tex.Sample(VolumeSampler, r5.xyz).xyz;
	r5 = r5.yzx * float3(2, 2, 2) + float3(-1, -1, -1);
	r2.w = r5.z * r2.w + 1;
	r1.xyz = r1.xyz * r2.www + r3.yzw;
	r3.y = i.texcoord2.x * 1.5;
	o.sv_target.xyz = r1.xyz * r3.yyy;
	o.sv_coverage = 255;
	r1.xyz = r5.yyy * i.texcoord5.xyz;
	r1.xyz = i.texcoord4.xyz * r5.xxx + r1.xyz;
	r1.xyz = r1.xyz * detailSettings.yyy;
	r3.yzw = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw;
	r4.w = asint(-(r3.w) + 1);
	r4.w = (asfloat(r4.w) < r3.y) ? -1 : 0;
	r4.w = r4.w & 1065353216;
	r5.xy = -(r3.wz) + r3.yz;
	r3.yz = asfloat(r4.ww) * r5.xy + r3.wz;
	r3.yz = r3.yz * float2(2, 2) + float2(-1, -1);
	r3.yz = r3.yz * bumpiness;
	r3.w = dot(r3.yz, r3.yz);
	r3.w = -(r3.w) + 1;
	r3.w = max(r3.w, 0);
	r3.w = sqrt(r3.w);
	r5 = r3.yyy * i.texcoord4.xyz;
	r5 = r3.www * i.texcoord1.xyz + r5.xyz;
	r3.yzw = r3.zzz * i.texcoord5.xyz + r5.xyz;
	r3.yzw = r3.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r4.w = asint(dot(r3.yzw, r3.yzw));
	r4.w = asint(rsqrt(asfloat(r4.w)));
	r5 = r3.yzw * asfloat(r4.www);
	r3.yzw = r3.yzw * asfloat(r4.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.xyz = r1.xyz * i.texcoord2.www + r5.xyz;
	r1.xyz = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r4.w = asint(dot(r1.xyz, r1.xyz));
	r4.w = asint(rsqrt(asfloat(r4.w)));
	r1.xyz = r1.xyz * asfloat(r4.www);
	o.sv_target1.xyz = r1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r1.x = dot(r2.xyz, r2.xyz);
	r1.x = rsqrt(r1.x);
	r1.xyz = r1.xxx * r2.xyz;
	r0.x = asint(dot(asfloat(r0.xyz), r1.xyz));
	r0.y = asint(dot(asfloat(r4.xyz), r1.xyz));
	r0.z = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = asint(-(asfloat(r0.x)) * asfloat(r0.x) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.y = asint(-(asfloat(r0.y)) * asfloat(r0.y) + 1);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.xy = asint(sqrt(asfloat(r0.xy)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y) + -(asfloat(r0.z)));
	r0.x = asint(abs(asfloat(r0.x)) + 0.00000999999975);
	r0.x = asint(log2(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * r3.x);
	r0.x = asint(exp2(asfloat(r0.x)));
	r0.x = asint(r1.w + asfloat(r0.x));
	r0.y = asint(dot(r3.yzw, r3.yzw));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r1.xyz = asfloat(r0.yyy) * r3.yzw;
	r2.xyz = i.texcoord7.xyz + -(gViewInverse[3].xyz);
	r2.xyz = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.y = asint(dot(r2.xyz, r2.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r2.xyz = asfloat(r0.yyy) * r2.xyz;
	r0.y = asint(dot(r2.xyz, r1.xyz));
	r0.y = asint(asfloat(r0.y) * -1.5);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(asfloat(r0.y) * i.texcoord2.y);
	r0.z = asint(dot(r6.xyz, specMapIntMask.xyz));
	r1.x = dot(r6, specMapExpMask);
	r1.x = r1.x * specularFactor;
	r1.x = max(r1.x, 1);
	r1.x = r1.x * matMaterialColorScale.w;
	r0.z = asint(asfloat(r0.z) * matMaterialColorScale.w);
	r1.y = saturate(asfloat(r0.z) * 5);
	r0.y = asint(asfloat(r0.y) * r1.y);
	r1.y = saturate(-(r1.x) * 0.00999999978 + 1);
	r1.x = r1.x * 0.00510204071;
	r1.x = saturate(r1.x);
	r1.x = sqrt(r1.x);
	o.sv_target2.y = sqrt(r1.x);
	r0.y = asint(r1.y * asfloat(r0.y) + asfloat(r0.z));
	r0.y = asint(saturate(r2.w * asfloat(r0.y)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y));
	r0.y = asint(anisotropicSpecularIntensity.x + 0.200000003);
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	o.sv_target2.x = asfloat(r0.w) * asfloat(r0.x);
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target3 = float4(0, 0, 0, 0);

	return o;
}
