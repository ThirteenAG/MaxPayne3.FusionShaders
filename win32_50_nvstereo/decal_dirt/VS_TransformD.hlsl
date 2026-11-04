cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	o.sv_position = r0 + gWorldViewProj[3];
	o.color = i.color;
	o.texcoord = i.texcoord.xy;
	r0.xyz = i.position.yyy * gWorld[1].xyz;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord6.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord6.w = 1;

	return o;
}
