row_major float4x4 gShadowMatrix : register(c57);
float4 gShadowParam0123 : register(c54);
float4 gShadowParam14151617 : register(c53);
row_major float4x4 gWorldInstanceMatrix : register(c68);

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
	r0.xyz = gWorldInstanceMatrix[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorldInstanceMatrix[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldInstanceMatrix[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldInstanceMatrix[3].xyz;
	r1.xyz = r0.yyy * gShadowMatrix[1].xyz;
	r1.xyz = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r1.xyz = r0.zzz * gShadowMatrix[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gShadowMatrix[3].xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r1.w = -r1.z + r0.w;
	r2.z = r0.w * -gShadowParam0123.w;
	r0.w = 1 / r1.w;
	r2.xy = r0.ww * r1.xy;
	r2.w = r1.z * -gShadowParam0123.w;
	r0.w = abs(gShadowParam14151617.x);
	r0.w = (-r0.w >= r0.w) ? 1 : 0;
	r1 = r0.y * gShadowMatrix[1];
	r1 = r0.x * gShadowMatrix[0] + r1;
	r1 = r0.z * gShadowMatrix[2] + r1;
	r1 = r1 + gShadowMatrix[3];
	r3 = lerp(r1, r2, r0.w);
	o.position.xyz = r3.xyz;
	r1.x = r3.w * -gShadowParam0123.w + -r3.w;
	r2.x = -1;
	r1.y = r2.x + gShadowParam14151617.x;
	r1.y = (-abs(r1.y) >= abs(r1.y)) ? 1 : 0;
	r1.z = r1.y * r1.x + r3.w;
	r1.y = r0.z;
	o.texcoord1.xy = r0.xy;
	r1.x = r3.w;
	r0.xyz = r3.wwz * float3(0, 1, 1) + float3(1, 0, 0);
	r2.xyz = lerp(r1.xyz, r0.xyz, r0.www);
	o.position.w = r2.x;
	o.texcoord1.zw = r2.yz;
	o.texcoord = float4(1, 1, 0, 0) * i.texcoord.xyxx;

	return o;
}
