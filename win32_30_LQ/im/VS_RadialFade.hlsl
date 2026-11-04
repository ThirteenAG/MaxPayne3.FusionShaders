struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
	o.texcoord = position.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, 1);

	return o;
}
