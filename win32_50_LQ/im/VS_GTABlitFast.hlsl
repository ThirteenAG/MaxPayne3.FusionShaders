cbuffer _Globals : register(b4)
{
	float4 TransColor : packoffset(c206);
	float4 TransPos : packoffset(c207);
	float4 TransTex0 : packoffset(c208);
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

	o.sv_position.xy = position.xy * TransPos.xy + TransPos.zw;
	o.sv_position.zw = float2(0, 1);
	o.color = TransColor;
	o.texcoord = position.xy * TransTex0.xy + TransTex0.zw;

	return o;
}
