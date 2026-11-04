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
	float3 r1;
	r0.xyz = gWorld[1].xyz * position.yyy;
	r0.xyz = position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.yyy * gShadowMatrix[1].xyz;
	r0.xyw = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gShadowMatrix[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gShadowMatrix[3].xyz;
	o.position.z = max(r0.z, 0);
	o.position.xyw = r0.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord = 1;

	return o;
}
