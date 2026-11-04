cbuffer Dome : register(b1)
{
	float3 SkyColor : packoffset(c0);
	float3 EastColor : packoffset(c1);
	float3 WestColor : packoffset(c2);
	float3 gSunDirection : packoffset(c3);
	float3 gSunColor : packoffset(c4);
	float3 gCloudColor : packoffset(c5);
	float3 gAmbientColor : packoffset(c6);
	float3 gBounceColor : packoffset(c7);
	float2 gDensityShiftScale : packoffset(c8);
	float4 gScatterG_GSquared_PhaseMult_Scale : packoffset(c9);
	float4 gPiercingLightPower_Strength_NormalStrength_Thickness : packoffset(c10);
};

SamplerState DensitySampler : register(s0);
Texture2D DensitySampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float2 r0;
	r0.x = DensitySampler_tex.Sample(DensitySampler, i.texcoord1.xy).y;
	r0.x = -(r0.x) * r0.x + 1;
	r0.x = r0.x + -(gDensityShiftScale.x);
	r0.x = saturate(r0.x * gDensityShiftScale.y);
	r0.x = -(r0.x) + 1;
	r0.y = -(gPiercingLightPower_Strength_NormalStrength_Thickness.w) + 1;
	r0.x = saturate(r0.x * gPiercingLightPower_Strength_NormalStrength_Thickness.w + r0.y);
	r0.x = -(r0.x) * 12 + 1;
	o.w = max(r0.x, 0);
	o.xyz = float3(0, 0, 0);

	return o;
}
