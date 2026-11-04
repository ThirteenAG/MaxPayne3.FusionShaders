struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord = float4(1, 1, 0, 0) * i.texcoord.xyxx;

	return o;
}
