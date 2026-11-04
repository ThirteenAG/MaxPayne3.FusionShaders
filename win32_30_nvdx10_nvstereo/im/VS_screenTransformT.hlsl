struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
	o.texcoord = i.texcoord;
	o.color = i.color;

	return o;
}
