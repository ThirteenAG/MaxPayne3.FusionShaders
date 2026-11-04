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
	float4 gWaterGlobals : packoffset(c19);
	float4 ColorCorrectTopScreenEdge : packoffset(c20);
	float4 ColorCorrectBottomOffsetScreenEdge : packoffset(c21);
	float4 gScreenSpaceTessFactors : packoffset(c22);
	float4 gTessFactors : packoffset(c23);
	float4 gFrustumPlaneEquation_Left : packoffset(c24);
	float4 gFrustumPlaneEquation_Right : packoffset(c25);
	float4 gFrustumPlaneEquation_Top : packoffset(c26);
	float4 gFrustumPlaneEquation_Bottom : packoffset(c27);
	float4 gTessParameters : packoffset(c28);
};

cbuffer CacheZShiftandParallax : register(b4)
{
	float zShiftScale : packoffset(c0);
	float parallaxScaleBias : packoffset(c0.y);
};

SamplerState BumpSampler : register(s2);
Texture2D BumpTex : register(t2);

struct DS_IN
{
	float4 texcoord8 : TEXCOORD8;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
};

struct DS_CONST
{
	float edges[3] : SV_TessFactor;
	float inside : SV_InsideTessFactor;
};

struct DS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
};

[domain("tri")]
DS_OUT main(DS_CONST constants, float3 sv_domainlocation : SV_DomainLocation, const OutputPatch<DS_IN, 3> patch)
{
	DS_OUT o;

	float3 t0 = patch[0].texcoord1.xyz * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord1.xyz + patch[2].texcoord1.xyz * sv_domainlocation.y + 0.00000999999975;
	float3 t1 = patch[0].texcoord8.xyz * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord8.xyz + patch[2].texcoord8.xyz * sv_domainlocation.y;
	float2 t2 = patch[0].texcoord * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord;
	float2 t3 = patch[2].texcoord * sv_domainlocation.y;
	float t4 = BumpTex.SampleLevel(BumpSampler, t3 + t2, 0).z;
	float t5 = (t4 - 0.5) * gTessParameters.w - 0.5 * gTessParameters.w;
	float3 t6 = normalize(mul((float3x3)gWorld, gViewInverse[3].xyz - gWorld[3].xyz) - t1 + 0.00000999999975);
	float3 t7 = t6 * zShiftScale + t1 + normalize(t0) * t5;
	o.sv_position = mul(float4(t7, 1), gWorldViewProj);
	o.color = patch[0].color * sv_domainlocation.z + sv_domainlocation.x * patch[1].color + patch[2].color * sv_domainlocation.y;
	o.texcoord = t2 + t3;
	o.texcoord1 = float4(normalize(t0), 0);
	o.texcoord4 = normalize(patch[0].texcoord4 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord4 + patch[2].texcoord4 * sv_domainlocation.y + 0.00000999999975);
	o.texcoord5 = normalize(patch[0].texcoord5 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord5 + patch[2].texcoord5 * sv_domainlocation.y + 0.00000999999975);
	o.texcoord6 = patch[0].texcoord6 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord6 + patch[2].texcoord6 * sv_domainlocation.y;
	o.texcoord7 = patch[0].texcoord7 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord7 + patch[2].texcoord7 * sv_domainlocation.y;

	return o;
}
