row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 position1 : POSITION1;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 color : COLOR;
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
	float4 r5;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1.xyz = i.position.xyz;
	r1.xyz = r1.xyz + i.position1.xyz;
	r1.w = 1;
	r0.w = dot(r0, r1);
	r0.y = dot(r0.xyz, i.normal.xyz);
	r2.xyz = r0.www * gWorld[1].xyz;
	r3 = r0.w * gWorldViewProj[1];
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r5 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r5 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r5;
	r4 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r4;
	r4 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r4;
	r5 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r5;
	r5 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r5;
	r4 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r4;
	r0.w = dot(r4, r1);
	r0.x = dot(r4.xyz, i.normal.xyz);
	r1.x = dot(r5, r1);
	r0.z = dot(r5.xyz, i.normal.xyz);
	r4.xyz = normalize(r0.xyz);
	r0.xyz = r0.www * gWorld[0].xyz + r2.xyz;
	r2 = r0.w * gWorldViewProj[0] + r3;
	r2 = r1.x * gWorldViewProj[2] + r2;
	r0.xyz = r1.xxx * gWorld[2].xyz + r0.xyz;
	o.texcoord2.xyz = r0.xyz + gWorld[3].xyz;
	r0 = r2 + gWorldViewProj[3];
	r1.xyz = r4.yyy * gWorld[1].xyz;
	r1.xyz = r4.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = r4.zzz * gWorld[2].xyz + r1.xyz;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	o.texcoord.xyz = r1.www * r1.xyz;
	r1.xyz = r0.xwy * 0.5;
	o.texcoord1.x = r1.y + r1.x;
	o.texcoord1.y = r0.w * 0.5 + -r1.z;
	o.position = r0;
	o.texcoord1.zw = r0.ww;
	o.texcoord.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3 = float4(0, 0, 0, 1);
	o.color = i.color;

	return o;
}
