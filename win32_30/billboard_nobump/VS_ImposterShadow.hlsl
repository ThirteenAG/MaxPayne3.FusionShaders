row_major float4x4 gShadowMatrix : register(c57);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
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

	float4 r0;
	r0 = gShadowMatrix[1] * i.position.y;
	r0 = i.position.x * gShadowMatrix[0] + r0;
	r0 = i.position.z * gShadowMatrix[2] + r0;
	o.position = r0 + gShadowMatrix[3];
	o.texcoord.xy = i.texcoord.xy * float2(1, -1) + float2(0, 1);
	o.texcoord.zw = i.color.xx * float2(16, 0.025) + float2(8, 0.0125);

	return o;
}
