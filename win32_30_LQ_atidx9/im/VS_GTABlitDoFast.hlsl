float4 TransColor : register(c197);
float4 TransPos : register(c198);

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	o.position.xy = position.xy * TransPos.xy + TransPos.zw;
	o.position.zw = float2(0, 1);
	o.color = TransColor;

	return o;
}
