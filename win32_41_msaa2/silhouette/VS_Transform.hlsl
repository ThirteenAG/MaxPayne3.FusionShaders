cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
};

struct VS_IN
{
	float3 position : POSITION;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = i.normal.yyy * gWorld[1].xyz;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.w = dot(gWorldView[3], gWorldView[3]);
	r0.w = sqrt(r0.w);
	r0.w = r0.w * gDirectionalColour.x;
	r0.xyz = r0.xyz * r0.www + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	o.sv_position = r1;
	r0.y = r0.y * gWorldView[1].z;
	r0.x = r0.x * gWorldView[0].z + r0.y;
	r0.x = r0.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord.z = -(r0.x);
	r0.xy = r1.xy * float2(0.5, -0.5);
	r0.xy = r0.xy / r1.ww;
	o.texcoord.xy = r0.xy + float2(0.5, 0.5);

	return o;
}
