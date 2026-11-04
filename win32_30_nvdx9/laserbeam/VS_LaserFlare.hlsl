struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.position = i.position.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, 1);
	o.texcoord = i.position.xy;
	o.texcoord1 = i.texcoord.xy;
	o.texcoord2.xyz = i.normal.xyz;
	o.texcoord2.w = i.position.z;
	o.color = i.color.xyz;

	return o;
}
