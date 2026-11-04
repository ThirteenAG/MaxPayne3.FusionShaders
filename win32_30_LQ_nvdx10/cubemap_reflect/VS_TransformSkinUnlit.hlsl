row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 a0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r0.x = dot(r0, r1);
	r0 = r0.x * gWorldViewProj[1];
	r2 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r3 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r3 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r3;
	r2 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r2;
	r2 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r2;
	r3 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r3;
	r3 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r3;
	r2 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r2;
	r2.x = dot(r2, r1);
	r1.x = dot(r3, r1);
	r0 = r2.x * gWorldViewProj[0] + r0;
	r0 = r1.x * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	o.color = i.color;
	o.texcoord = i.texcoord.xy;

	return o;
}
