row_major float4x4 gShadowMatrix : register(c57);
float4 gShadowParam0123 : register(c54);
row_major float4x4 gWorld : register(c0);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0 = gWorld[1] * position.y;
	r0 = position.x * gWorld[0] + r0;
	r0 = position.z * gWorld[2] + r0;
	r0 = r0 + gWorld[3];
	r1 = r0.y * gShadowMatrix[1];
	r1 = r0.x * gShadowMatrix[0] + r1;
	r1 = r0.z * gShadowMatrix[2] + r1;
	r1 = r0.w * gShadowMatrix[3] + r1;
	o.texcoord1.xyz = r0.xyz;
	o.texcoord1.w = r1.w * -gShadowParam0123.w;
	o.position = r1;

	return o;
}
