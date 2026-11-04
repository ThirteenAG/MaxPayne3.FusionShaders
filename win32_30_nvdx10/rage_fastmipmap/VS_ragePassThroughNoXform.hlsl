struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.color = i.color;
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = i.texcoord1.xy;
	o.texcoord2 = float3(0, 0, -1);

	return o;
}
