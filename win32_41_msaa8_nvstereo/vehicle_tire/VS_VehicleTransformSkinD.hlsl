cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendindices : BLENDINDICES;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	r0.xyz = i.position.xyz;
	r0.w = 1;
	r1.x = asint(i.blendindices.x * 255.001953);
	r1.x = (int)asfloat(r1.x);
	r1.x = r1.x * 3;
	r1.y = asint(dot(gBoneMtx[r1.x / 3][1], r0));
	r2 = asfloat(r1.y) * gWorldViewProj[1];
	r3 = asfloat(r1.y) * gWorld[1];
	r1.y = asint(dot(gBoneMtx[r1.x / 3][0], r0));
	r0.x = dot(gBoneMtx[r1.x / 3][2], r0);
	r2 = asfloat(r1.y) * gWorldViewProj[0] + r2;
	r3 = asfloat(r1.y) * gWorld[0] + r3;
	r3 = r0.x * gWorld[2] + r3;
	r0 = r0.x * gWorldViewProj[2] + r2;
	r0 = r0 + gWorldViewProj[3];
	o.texcoord6 = r3 + gWorld[3];
	o.sv_position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	r0.x = dot(gBoneMtx[r1.x / 3][1].xyz, i.normal.xyz);
	r1.yzw = asint(r0.xxx * gWorld[1].xyz);
	r0.z = dot(gBoneMtx[r1.x / 3][0].xyz, i.normal.xyz);
	r1.yzw = asint(r0.zzz * gWorld[0].xyz + asfloat(r1.yzw));
	r0.y = dot(gBoneMtx[r1.x / 3][2].xyz, i.normal.xyz);
	o.texcoord1.xyz = r0.yyy * gWorld[2].xyz + asfloat(r1.yzw);
	o.texcoord2.xyz = i.color.xyz;
	o.texcoord2.w = 1;
	r2.x = dot(gBoneMtx[r1.x / 3][0].xyz, i.tangent.xyz);
	r2.y = dot(gBoneMtx[r1.x / 3][1].xyz, i.tangent.xyz);
	r2.z = dot(gBoneMtx[r1.x / 3][2].xyz, i.tangent.xyz);
	o.texcoord4 = r2.xyz;
	r1.xyz = asint(r0.xyz * r2.zxy);
	r0.xyz = r2.yzx * r0.yzx + -(asfloat(r1.xyz));
	o.texcoord5.xyz = r0.xyz * i.tangent.www;
	o.texcoord5.w = i.tangent.w;

	return o;
}
