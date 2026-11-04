row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float2 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int a0;
	float4 r1;
	float r2;
	r0.x = 765.00586 * i.blendindices.x;
	a0 = r0.x;
	r0 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r1.x = dot(gBoneMtx[a0 / 3][1], r0);
	r1 = r1.x * gWorldViewProj[1];
	r2 = dot(gBoneMtx[a0 / 3][0], r0);
	r0.x = dot(gBoneMtx[a0 / 3][2], r0);
	r1 = r2.x * gWorldViewProj[0] + r1;
	r0 = r0.x * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	o.texcoord = i.texcoord.xy;
	o.texcoord2 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord1 = i.texcoord.zw;

	return o;
}
