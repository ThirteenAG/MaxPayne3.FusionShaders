cbuffer UserClipPlanes : register(b6)
{
	float4 g_vUserClipPlanes[8] : packoffset(c0);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float2 r0;
	r0 = i.position.xy + float2(-0.5, -0.5);
	r0 = r0.xy * g_vUserClipPlanes[0].xy;
	o.sv_position.xy = r0.xy * float2(2, 2);
	o.sv_position.zw = g_vUserClipPlanes[0].zw * float2(0, 1);
	o.texcoord = i.texcoord;
	o.color = i.color;

	return o;
}
