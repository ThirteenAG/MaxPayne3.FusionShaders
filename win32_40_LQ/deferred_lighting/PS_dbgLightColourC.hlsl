cbuffer _Globals : register(b4)
{
	float g_fSSAOBilateralCoef : packoffset(c130);
	float g_fVolumetricLightRayIntensityMult : packoffset(c131);
	float4 dReflectionParams : packoffset(c132);
	float2 poisson12[12] : packoffset(c133);
	float4 debugLightColour : packoffset(c145);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = debugLightColour;

	return o;
}
