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

cbuffer CacheVehicleParams : register(b4)
{
	float3 matDiffuseColor : packoffset(c0);
	float4 matDiffuseColor2 : packoffset(c1);
};

cbuffer VehicleMaterial : register(b9)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float3 specMapIntMask : packoffset(c1);
	float4 specMapExpMask : packoffset(c2);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s2);
SamplerState SpecSampler : register(s3);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t2);
Texture2D SpecSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
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
	float4 r1;
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.xyz = asint(asfloat(r0.xyz) * matDiffuseColor.xyz);
	r0 = asint(asfloat(r0) * i.texcoord2);
	r0.w = asint(asfloat(r0.w) * globalScalars.x);
	o.sv_target.w = asfloat(r0.w);
	r1.x = dot(i.texcoord2.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r1.y = globalScalars.z * gAmbientOcclusionEffect.y;
	r1.z = saturate(r1.x * r1.y + -1);
	r1.x = r1.y * r1.x;
	o.sv_target2.z = r1.x * gAmbientOcclusionEffect.w;
	o.sv_target.xyz = r1.zzz * globalScalars2.zzz + asfloat(r0.xyz);
	r1 = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy);
	r0.x = asint(-(r1.w) + 1);
	r0.x = (asfloat(r0.x) < r1.x) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.yz = asint(-(r1.wy) + r1.xy);
	r0.xy = asint(asfloat(r0.xx) * asfloat(r0.yz) + r1.wy);
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r1.xyz = asfloat(r0.zzz) * i.texcoord1.xyz + r1.xyz;
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + r1.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0.xyz), asfloat(r0.xyz));
	r1.x = rsqrt(r1.x);
	r0.xyz = asint(asfloat(r0.xyz) * r1.xxx);
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = asfloat(r0.w);
	o.sv_target2.w = asfloat(r0.w);
	o.sv_target3.w = asfloat(r0.w);
	r0 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r0.w = asint(dot(asfloat(r0), specMapExpMask));
	r0.x = asint(dot(asfloat(r0.xyz), specMapIntMask.xyz));
	r0.x = asint(asfloat(r0.x) * specularColorFactor);
	o.sv_target2.x = asfloat(r0.x) * matDiffuseColor2.w;
	r0.x = asint(asfloat(r0.w) * specularFactor);
	r0.x = asint(max(asfloat(r0.x), 1));
	r0.x = asint(asfloat(r0.x) * matDiffuseColor2.w);
	r0.x = asint(saturate(asfloat(r0.x) * 0.00510204071));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
