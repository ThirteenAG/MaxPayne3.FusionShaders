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

cbuffer CacheMegaVariables : register(b4)
{
	float normSpecularFactor : packoffset(c0);
	float goldSpecularFactor : packoffset(c0.y);
	float3 normSpecMapIntMask : packoffset(c1);
	float3 goldSpecMapIntMask : packoffset(c2);
	float4 specMapExpMask : packoffset(c3);
	float bumpiness : packoffset(c4);
	float normReflectivePower : packoffset(c4.y);
	float goldReflectivePower : packoffset(c4.z);
	float normFresnelRolloff : packoffset(c4.w);
	float goldFresnelRolloff : packoffset(c5);
	float3 specMapReflectMask : packoffset(c5.y);
	float goldFactor : packoffset(c6);
	float3 goldReflectColorBase : packoffset(c6.y);
	float3 goldReflectColorOverlay : packoffset(c7);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerState SpecSampler : register(s2);
SamplerState EnvironmentSampler : register(s3);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D SpecSampler_tex : register(t2);
Texture2D EnvironmentSampler_tex : register(t3);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
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
	float4 r1;
	float4 r2;
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r1.xyz = -(asfloat(r0.xyz)) + goldReflectColorBase.xyz;
	r0.xyz = asint(goldFactor * r1.xyz + asfloat(r0.xyz));
	r0.w = asint(asfloat(r0.w) * i.color.w);
	r0.w = asint(asfloat(r0.w) * globalScalars.x);
	r1.x = saturate(i.color.x + -1);
	o.sv_target.xyz = r1.xxx * globalScalars2.zzz + asfloat(r0.xyz);
	o.sv_target.w = asfloat(r0.w);
	o.sv_coverage = 255;
	o.sv_target1.w = asfloat(r0.w);
	o.sv_target3.w = asfloat(r0.w);
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = -(asfloat(r0.zy)) + asfloat(r0.xy);
	r0.xy = asint(asfloat(r0.ww) * r1.xy + asfloat(r0.zy));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r0.xzw = asint(asfloat(r0.zzz) * i.texcoord1.xyz + r1.xyz);
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r0.xzw));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.w = asint(-(normSpecularFactor) + goldSpecularFactor);
	r0.w = asint(goldFactor * asfloat(r0.w) + normSpecularFactor);
	r1 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r2 = -(r1) + float4(1, 1, 1, 1);
	r1 = goldFactor * r2 + r1;
	r1.w = dot(r1, specMapExpMask);
	r0.w = asint(asfloat(r0.w) * r1.w);
	r0.w = asint(max(asfloat(r0.w), 1));
	r0.w = asint(asfloat(r0.w) * 0.00510204071);
	r0.w = asint(min(asfloat(r0.w), 1));
	r0.w = asint(sqrt(asfloat(r0.w)));
	o.sv_target2.y = sqrt(asfloat(r0.w));
	r2.xy = frac(i.sv_position.xy);
	r2.xy = r2.xy + float2(-0.5, -0.5);
	o.sv_target2.w = dot(abs(r2.xy), float2(1000, 1000));
	r2.xyz = -(normSpecMapIntMask.xyz) + goldSpecMapIntMask.xyz;
	r2.xyz = goldFactor * r2.xyz + normSpecMapIntMask.xyz;
	o.sv_target2.x = dot(r1.xyz, r2.xyz);
	r0.w = asint(dot(r1.xyz, specMapReflectMask));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r1.xyz = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.xyz = r1.www * r1.xyz;
	r1.w = dot(-(r1.xyz), asfloat(r0.xyz));
	r1.w = r1.w + r1.w;
	r2.xyz = asfloat(r0.xyz) * -(r1.www) + -(r1.xyz);
	r0.x = asint(saturate(dot(r1.xyz, asfloat(r0.xyz))));
	r0.x = asint(-(asfloat(r0.x)) + 1.00001001);
	r1.xyz = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.y = asint(dot(r1.xyz, r1.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r0.yz = asint(r1.xz * asfloat(r0.yy) + float2(1, 1));
	r0.yz = asint(asfloat(r0.yz) * float2(-0.5, -0.5));
	r1.xyz = EnvironmentSampler_tex.Sample(EnvironmentSampler, asfloat(r0.yz)).xyz;
	r2.xyz = r1.xyz * goldReflectColorOverlay.xyz + -(r1.xyz);
	r1.xyz = goldFactor * r2.xyz + r1.xyz;
	r0.y = asint(asfloat(r0.x) * asfloat(r0.x));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.y = asint(-(normFresnelRolloff) + goldFresnelRolloff);
	r0.y = asint(goldFactor * asfloat(r0.y) + normFresnelRolloff);
	r0.z = asint(-(asfloat(r0.y)) + 1);
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x) + asfloat(r0.z));
	r0.xyz = asint(asfloat(r0.xxx) * r1.xyz);
	r1.x = -(normReflectivePower) + goldReflectivePower;
	r1.x = goldFactor * r1.x + normReflectivePower;
	r0.xyz = asint(asfloat(r0.xyz) * r1.xxx);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.w = asint(-(globalScalars.w) + 1);
	r0.w = asint(goldFactor * asfloat(r0.w) + globalScalars.w);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(saturate(asfloat(r0.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyz));

	return o;
}
