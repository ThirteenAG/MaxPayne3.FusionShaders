cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer LaserParam : register(b1)
{
	float gMaxDisplacement : packoffset(c0);
	float gCameraDistanceAtMaxDisplacement : packoffset(c0.y);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = i.position.yyy * gWorld[1].xyz;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r0.xyz = r0.xyz + -(gViewInverse[3].xyz);
	r1.xyz = i.normal.yyy * gWorld[1].xyz;
	r1.xyz = i.normal.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = i.normal.zzz * gWorld[2].xyz + r1.xyz;
	r0.x = dot(-(r0.xyz), r1.xyz);
	r0.x = saturate(r0.x / gCameraDistanceAtMaxDisplacement);
	r0.x = r0.x * gMaxDisplacement;
	r0.xyz = r0.xxx * i.normal.xyz + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.sv_position = r0 + gWorldViewProj[3];
	o.texcoord2 = i.texcoord.xy;
	r0.x = i.color.w * i.color.w;
	r0.x = r0.x * 20;
	o.color = r0.xxx * i.color.xyz;

	return o;
}
