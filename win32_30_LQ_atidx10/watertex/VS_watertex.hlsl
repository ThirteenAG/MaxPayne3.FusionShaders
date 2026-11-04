struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord = i.texcoord.xy;
	o.color = i.color;

	return o;
}
