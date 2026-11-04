float4 gAmbientOcclusionEffect : register(c63);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float3 globalAnimUV0 : register(c196);
float3 globalAnimUV1 : register(c197);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 a0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1.x = dot(r0.xyz, i.normal.xyz);
	r1.xyz = r1.xxx * gWorld[1].xyz;
	r2 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r3 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r3 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r3;
	r2 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r2;
	r2 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r2;
	r3 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r3;
	r3 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r3;
	r2 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r2;
	r1.w = dot(r2.xyz, i.normal.xyz);
	r1.xyz = r1.www * gWorld[0].xyz + r1.xyz;
	r1.w = dot(r3.xyz, i.normal.xyz);
	o.texcoord1.xyz = r1.www * gWorld[2].xyz + r1.xyz;
	r1.xyz = i.texcoord.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord.x = dot(globalAnimUV0.xyz, r1.xyz);
	o.texcoord.y = dot(globalAnimUV1.xyz, r1.xyz);
	r1 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r0.x = dot(r0, r1);
	r0.yzw = r0.xxx * gWorld[1].xyz;
	r4 = r0.x * gWorldViewProj[1];
	r0.x = dot(r2, r1);
	r1.x = dot(r3, r1);
	r0.yzw = r0.xxx * gWorld[0].xyz + r0.yzw;
	r2 = r0.x * gWorldViewProj[0] + r4;
	r2 = r1.x * gWorldViewProj[2] + r2;
	r0.xyz = r1.xxx * gWorld[2].xyz + r0.yzw;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r2 + gWorldViewProj[3];
	r2.xyz = r0.xyz + -gViewInverse[3].xyz;
	o.texcoord6.xyz = r0.xyz;
	r0.x = dot(r2.xyz, r2.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r2.xyz = i.normal.xyz;
	r0.yzw = r2.xyz + i.position.xyz;
	r2.xy = r0.zz * gWorldViewProj[1].xy;
	r0.yz = r0.yy * gWorldViewProj[0].xy + r2.xy;
	r0.yz = r0.ww * gWorldViewProj[2].xy + r0.yz;
	r0.yz = r0.yz + gWorldViewProj[3].xy;
	r0.yz = -r0.yz + r1.xy;
	r0.yz = r0.yz * -0.002;
	o.position.xy = r0.yz * r0.xx + r1.xy;
	r0.xy = globalDayNightEffects.zw * i.color.xy;
	r0.x = r0.y + r0.x;
	r0.y = 1;
	r0.x = r0.x * globalScalars.z + -r0.y;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.y;
	o.color.xy = r0.xx * gAmbientOcclusionEffect.yy;
	o.position.zw = r1.zw;
	o.texcoord1.w = r1.w;
	o.color.zw = i.color.zw;
	o.texcoord6.w = 1;
	o.texcoord7 = 0;
	o.texcoord8 = 0;

	return o;
}
