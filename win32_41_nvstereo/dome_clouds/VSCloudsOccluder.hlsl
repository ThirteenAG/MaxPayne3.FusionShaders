cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

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
	float3 gScaleDiffuseFillAmbient : packoffset(c11);
	float2 gWrapLighting : packoffset(c12);
	float gHDRExposure : packoffset(c12.z);
	float4 gNearFarQMult : packoffset(c13);
	float3 gAnimCombine : packoffset(c14);
	float3 gAnimSculpt : packoffset(c15);
	float3 gAnimBlendWeights : packoffset(c16);
	float2 gUVOffset[3] : packoffset(c17);
	float3 gReflScales : packoffset(c20);
	float2 gUVOffset1 : packoffset(c21);
	float2 gUVOffset2 : packoffset(c21.z);
	float2 gUVOffset3 : packoffset(c22);
	float2 gRescaleUV1 : packoffset(c22.z);
	float2 gRescaleUV2 : packoffset(c23);
	float2 gRescaleUV3 : packoffset(c23.z);
};

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_IN
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float2 r1;
	r0.xyz = i.position.yyy * gWorldViewProj[1].xyw;
	r0.xyz = i.position.xxx * gWorldViewProj[0].xyw + r0.xyz;
	r0.xyz = i.position.zzz * gWorldViewProj[2].xyw + r0.xyz;
	r0.yzw = r0.xyz + gWorldViewProj[3].xyw;
	r1 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.25), 0).xy;
	r1.y = r0.w + -(r1.y);
	r0.x = r1.x * r1.y + r0.y;
	o.sv_position = r0.xzww;
	r0.xy = i.texcoord.xy * gRescaleUV1.xy + gUVOffset1.xy;
	o.texcoord1 = r0.xy + gUVOffset[0].xy;
	r0.xy = i.texcoord.xy * gRescaleUV2.xy + gUVOffset2.xy;
	o.texcoord2.xy = r0.xy + gUVOffset[1].xy;
	r0.xy = i.texcoord.xy * gRescaleUV3.xy + gUVOffset3.xy;
	o.texcoord2.zw = r0.xy + gUVOffset[2].xy;

	return o;
}
