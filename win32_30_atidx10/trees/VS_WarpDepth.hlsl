row_major float4x4 gShadowMatrix : register(c57);
float4 gShadowParam0123 : register(c54);
float4 gShadowParam14151617 : register(c53);
row_major float4x4 gWorld : register(c0);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.x = abs(gShadowParam14151617.x);
	r0.x = (-r0.x >= r0.x) ? 1 : 0;
	r0.yzw = gWorld[1].xyz * i.position.yyy;
	r0.yzw = i.position.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.position.zzz * gWorld[2].xyz + r0.yzw;
	r0.yzw = r0.yzw + gWorld[3].xyz;
	r1.xyz = r0.zzz * gShadowMatrix[1].xyz;
	r1.xyz = r0.yyy * gShadowMatrix[0].xyz + r1.xyz;
	r1.xyz = r0.www * gShadowMatrix[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gShadowMatrix[3].xyz;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.w = 1 / r1.w;
	r2.x = -r1.z + r1.w;
	r3.zw = r1.wz * -gShadowParam0123.ww;
	r1.w = 1 / r2.x;
	r3.xy = r1.ww * r1.xy;
	r1 = r0.z * gShadowMatrix[1];
	r1 = r0.y * gShadowMatrix[0] + r1;
	r1 = r0.w * gShadowMatrix[2] + r1;
	o.texcoord1.xyz = r0.yzw;
	r1 = r1 + gShadowMatrix[3];
	r2 = lerp(r1, r3, r0.x);
	o.position = r2;
	o.texcoord1.w = r2.w;
	o.texcoord = i.texcoord;

	return o;
}
