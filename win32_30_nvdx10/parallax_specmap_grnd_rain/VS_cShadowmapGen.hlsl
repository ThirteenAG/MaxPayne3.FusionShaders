row_major float4x4 gShadowMatrix : register(c57);
row_major float4x4 gWorld : register(c0);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.yyy * gShadowMatrix[1].xyz;
	r0.xyw = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gShadowMatrix[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gShadowMatrix[3].xyz;
	o.position.z = max(r0.z, 0);
	o.position.xyw = r0.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord = i.texcoord.xxy * float3(0, 1, 1) + float3(1, 0, 0);

	return o;
}
