row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars2 : register(c36);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
	float4 position1 : POSITION1;
	float4 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
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
	r1.x = dot(r5, r1);
	r1.yzw = r0.www * gWorld[0].xyz + r2.xyz;
	r2 = r0.w * gWorldViewProj[0] + r3;
	r2 = r1.x * gWorldViewProj[2] + r2;
	r1.xyz = r1.xxx * gWorld[2].xyz + r1.yzw;
	o.texcoord7 = r1.xyz + gWorld[3].xyz;
	r1 = r2 + gWorldViewProj[3];
	r2.xyz = i.normal.xyz;
	r2.xyz = r2.xyz + i.normal1.xyz;
	r0.w = dot(r0.xyz, r2.xyz);
	r3.xyz = r0.www * gWorld[1].xyz;
	r0.w = dot(r4.xyz, r2.xyz);
	r2.x = dot(r5.xyz, r2.xyz);
	r2.yzw = r0.www * gWorld[0].xyz + r3.xyz;
	r2.xyz = r2.xxx * gWorld[2].xyz + r2.yzw;
	r3 = i.tangent;
	r3 = r3 + i.tangent1;
	r0.x = dot(r0.xyz, r3.xyz);
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r0.w = dot(r4.xyz, r3.xyz);
	r0.xyz = r0.www * gWorld[0].xyz + r0.xyz;
	r0.w = dot(r5.xyz, r3.xyz);
	r0.xyz = r0.www * gWorld[2].xyz + r0.xyz;
	r3.xyz = r2.yzx * r0.zxy;
	r3.xyz = r0.yzx * r2.zxy + -r3.xyz;
	o.texcoord1.xyz = r2.xyz;
	o.texcoord4 = r0.xyz;
	o.texcoord5.xyz = r3.www * r3.xyz;
	o.texcoord5.w = r3.w;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	o.position = r1;
	o.texcoord1.w = r1.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord2.xzw = i.color.xzw;

	return o;
}
