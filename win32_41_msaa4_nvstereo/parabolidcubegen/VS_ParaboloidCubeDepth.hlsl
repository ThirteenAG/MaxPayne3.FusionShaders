cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
	float4 gShadowParam4567 : packoffset(c3);
	float4 gShadowParam891113 : packoffset(c4);
	float4 gCascadeZScales : packoffset(c5);
	float4 gCascadeZOffsets : packoffset(c6);
	float4 gCascadeXMinThresholds : packoffset(c7);
	float4 gCascadeXMaxThresholds : packoffset(c8);
	float4 gCascadeYMinThresholds : packoffset(c9);
	float4 gCascadeYMaxThresholds : packoffset(c10);
	row_major float4x4 gShadowMatrix : packoffset(c11);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0 = position.y * gWorld[1];
	r0 = position.x * gWorld[0] + r0;
	r0 = position.z * gWorld[2] + r0;
	r0 = r0 + gWorld[3];
	r1 = r0.y * gShadowMatrix[1];
	r1 = r0.x * gShadowMatrix[0] + r1;
	r1 = r0.z * gShadowMatrix[2] + r1;
	r1 = r0.w * gShadowMatrix[3] + r1;
	o.texcoord1.xyz = r0.xyz;
	o.sv_position = r1;
	o.texcoord1.w = r1.w * -(gShadowParam0123.w);

	return o;
}
