cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
	float4 TransColor : packoffset(c207);
	float4 TransPos : packoffset(c208);
	float4 TransTex0 : packoffset(c209);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(float2 position : POSITION)
{
	VS_OUT o;

	int r0;
	float4 r1;
	float4 r2;
	r0 = (0 < ApparentDepth) ? -1 : 0;
	r1.xy = position.xy * TransPos.xy + TransPos.zw;
	r1.zw = float2(0, 1);
	r2 = r1 * ApparentDepth;
	o.sv_position = (r0.x != 0) ? r2 : r1;
	o.color = TransColor;
	o.texcoord = position.xy * TransTex0.xy + TransTex0.zw;

	return o;
}
