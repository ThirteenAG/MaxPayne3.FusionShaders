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
	float3 r1;
	r0.xyz = position.yyy * gWorld[1].xyz;
	r0.xyz = position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.yyy * gShadowMatrix[1].xyz;
	r1 = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r1 = r0.zzz * gShadowMatrix[2].xyz + r1.xyz;
	o.texcoord1.xy = r0.xy;
	r0.xyz = r1.xyz + gShadowMatrix[3].xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = sqrt(r0.w);
	r1.x = -(r0.z) + r0.w;
	r0.w = r0.w * -(gShadowParam0123.w);
	o.sv_position.xy = r0.xy / r1.xx;
	o.texcoord1.z = r0.z * -(gShadowParam0123.w);
	o.sv_position.w = 1;
	o.sv_position.z = r0.w;
	o.texcoord1.w = r0.w;

	return o;
}
