row_major float3x4 gBoneMtx[40] : register(c76);
float4 gDirectionalColour : register(c20);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 normal : NORMAL;
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
	float4 r1;
	int4 a0;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.x = dot(gWorldView[3], gWorldView[3]);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * gDirectionalColour.x;
	r1 = 765.00586 * i.blendindices;
	a0 = r1.yxzw;
	r2 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r2 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r2;
	r1 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r2;
	r1 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r1;
	r2.x = dot(r1.xyz, i.normal.xyz);
	r3 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r4 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r4;
	r3 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r3;
	r3 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r3;
	r4 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r4;
	r4 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r4;
	r3 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r3;
	r2.y = dot(r3.xyz, i.normal.xyz);
	r2.z = dot(r4.xyz, i.normal.xyz);
	r5 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r1.x = dot(r1, r5);
	r1.y = dot(r3, r5);
	r1.z = dot(r4, r5);
	r0.xyz = r2.xyz * r0.xxx + r1.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r2.xy = r1.xy * float2(0.5, -0.5);
	r0.w = 1 / r1.w;
	o.position = r1;
	o.texcoord.xy = r2.xy * r0.ww + 0.5;
	r0.y = r0.y * gWorldView[1].z;
	r0.x = r0.x * gWorldView[0].z + r0.y;
	r0.x = r0.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord.z = -r0.x;

	return o;
}
