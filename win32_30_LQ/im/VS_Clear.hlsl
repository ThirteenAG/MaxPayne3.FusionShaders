struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position;
	o.color = i.color;

	return o;
}
