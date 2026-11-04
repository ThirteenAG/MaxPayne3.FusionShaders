row_major float4x4 gShadowMatrix : register(c58);
float4 gShadowParam0123 : register(c54);
float4 gShadowParam14151617 : register(c53);
float4 gShadowParam891113 : register(c56);
row_major float4x4 gWorld : register(c0);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float3 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = abs(gShadowParam14151617.xy);
	r0.xy = (-r0.xy >= r0.xy) ? 1 : 0;
	r0.y = r0.y + -0.5;
	r1.xyz = gWorld[1].xyz * position.yyy;
	r1.xyz = position.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = position.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gWorld[3].xyz;
	r2.xyz = r1.yyy * gShadowMatrix[1].xyz;
	r2.xyz = r1.xxx * gShadowMatrix[0].xyz + r2.xyz;
	r2.xyz = r1.zzz * gShadowMatrix[2].xyz + r2.xyz;
	o.texcoord1.xyz = r1.xyz;
	r1.xyz = r2.xyz + gShadowMatrix[3].xyz;
	r0.z = r1.z + gShadowParam891113.z;
	r0.y = r0.z * r0.y;
	r1.w = r0.y + r0.y;
	r0.z = dot(r1.xyw, r1.xyw);
	r2.w = r1.w * -gShadowParam0123.w;
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.y = r0.y * -2 + r0.z;
	r2.z = r0.z * -gShadowParam0123.w;
	r0.y = 1 / r0.y;
	r2.xy = r0.yy * r1.xy;
	r3.x = gShadowParam0123.x;
	r0.y = r3.x * gShadowParam891113.w;
	r0.y = r1.z * gShadowParam891113.w + r0.y;
	r0.z = r3.x + -gShadowParam891113.w;
	r0.z = 1 / r0.z;
	r3.z = r0.z * r0.y;
	r3.xy = r1.xy * gShadowParam0123.zz;
	r3.w = -r1.z;
	r1 = lerp(r3, r2, r0.x);
	o.position = r1;
	o.texcoord1.w = r1.w;

	return o;
}
