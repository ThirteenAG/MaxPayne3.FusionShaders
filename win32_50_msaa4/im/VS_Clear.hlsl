struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.sv_position = i.position;
	o.color = i.color;

	return o;
}
