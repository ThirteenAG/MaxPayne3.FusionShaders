row_major float4x4 gShadowMatrix : register(c57);
row_major float4x4 gWorld : register(c0);

struct VS_OUT
{
	float4 position : POSITION;
	float texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = gWorld[1].xyz * position.yyy;
	r0.xyz = position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.y * gShadowMatrix[1];
	r1 = r0.x * gShadowMatrix[0] + r1;
	r0 = r0.z * gShadowMatrix[2] + r1;
	r0 = r0 + gShadowMatrix[3];
	o.position = r0;
	o.texcoord = r0.w;

	return o;
}
