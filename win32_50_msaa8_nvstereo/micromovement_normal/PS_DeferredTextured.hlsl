cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
	float4 gLightPointColR : packoffset(c16);
	float4 gLightPointColG : packoffset(c17);
	float4 gLightPointColB : packoffset(c18);
	float4 gLightPointPosX : packoffset(c19);
	float4 gLightPointPosY : packoffset(c20);
	float4 gLightPointPosZ : packoffset(c21);
	float4 gLightDir2X : packoffset(c22);
	float4 gLightDir2Y : packoffset(c23);
	float4 gLightDir2Z : packoffset(c24);
	float4 gLightConeScale2 : packoffset(c25);
	float4 gLightConeOffset2 : packoffset(c26);
	float4 gLightPointFallOff : packoffset(c27);
	float4 gDistFadeParams : packoffset(c28);
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

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
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

	float4 r0;
	int4 r1;
	r0.xyz = i.texcoord6.xyz + -(gViewInverse[3].xyz);
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = r0.x + -0.649999976;
	r0.x = max(r0.x, 0.25);
	r0.x = min(r0.x, 1);
	r0.x = r0.x + -1;
	r0.x = gDistFadeParams.x * r0.x + 1;
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.y = asfloat(r1.w) * i.color.w;
	r0.y = r0.y * globalScalars.x;
	o.sv_target.w = r0.x * r0.y;
	r0.x = saturate(i.color.x + -1);
	o.sv_target.xyz = r0.xxx * globalScalars2.zzz + asfloat(r1.xyz);
	o.sv_coverage = 255;
	r0.xzw = BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw;
	r1.x = asint(-(r0.w) + 1);
	r1.x = (asfloat(r1.x) < r0.x) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r1.yz = asint(-(r0.wz) + r0.xz);
	r0.xz = asfloat(r1.xx) * asfloat(r1.yz) + r0.wz;
	r0.xz = r0.xz * float2(2, 2) + float2(-1, -1);
	r0.xz = r0.xz * bumpiness;
	r0.w = dot(r0.xz, r0.xz);
	r0.w = -(r0.w) + 1;
	r0.w = max(r0.w, 0);
	r0.w = sqrt(r0.w);
	r1.xyz = asint(r0.xxx * i.texcoord4.xyz);
	r1.xyz = asint(r0.www * i.texcoord1.xyz + asfloat(r1.xyz));
	r0.xzw = r0.zzz * i.texcoord5.xyz + asfloat(r1.xyz);
	r0.xzw = r0.xzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r0.xzw, r0.xzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xzw = r0.xzw * asfloat(r1.xxx);
	o.sv_target1.xyz = r0.xzw * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = r0.y;
	o.sv_target3.w = r0.y;
	r0.x = max(specularFactor, 1);
	r0.x = r0.x * 0.00510204071;
	r0.x = min(r0.x, 1);
	r0.x = sqrt(r0.x);
	o.sv_target2.y = sqrt(r0.x);
	r0.xy = frac(i.sv_position.xy);
	r0.xy = r0.xy + float2(-0.5, -0.5);
	o.sv_target2.w = dot(abs(r0.xy), float2(1000, 1000));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target2.x = specularColorFactor;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
