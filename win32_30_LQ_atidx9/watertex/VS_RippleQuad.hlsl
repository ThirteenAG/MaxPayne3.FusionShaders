float3 g_vRippleTexelSize : register(c198);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float r0;
	r0 = 0.5;
	o.texcoord = g_vRippleTexelSize.xy * r0.xx + i.texcoord.xy;
	o.position = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);

	return o;
}
