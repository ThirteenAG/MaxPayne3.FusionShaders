cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	int2 r2;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = ApparentDepth / r0.w;
	r1 = r0 * r1.x;
	r2.x = (r0.w != 0) ? -1 : 0;
	r2.y = (0 < ApparentDepth) ? -1 : 0;
	r2.x = r2.y & r2.x;
	o.sv_position = (r2.x != 0) ? r1 : r0;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;

	return o;
}
