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
	float3 r1;
	r0.xyz = gWorld[1].xyz * position.yyy;
	r0.xyz = position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.yyy * gShadowMatrix[1].xyz;
	r1 = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r1 = r0.zzz * gShadowMatrix[2].xyz + r1.xyz;
	o.texcoord1.xy = r0.xy;
	r0.xyz = r1.xyz + gShadowMatrix[3].xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r1.x = -r0.z + r0.w;
	r0.w = r0.w * -gShadowParam0123.w;
	r1.x = 1 / r1.x;
	o.position.xy = r0.xy * r1.xx;
	o.texcoord1.z = r0.z * -gShadowParam0123.w;
	o.position.w = 1;
	o.position.z = r0.w;
	o.texcoord1.w = r0.w;

	return o;
}
