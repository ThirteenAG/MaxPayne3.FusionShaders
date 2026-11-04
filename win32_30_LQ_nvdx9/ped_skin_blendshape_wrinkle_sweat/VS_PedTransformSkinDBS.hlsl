float4 gAmbientOcclusionEffect : register(c63);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars : register(c35);
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
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
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
	float4 r6;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1 = i.tangent;
	r1 = r1 + i.tangent1;
	r2.x = dot(r0.xyz, r1.xyz);
	r2.xyz = r2.xxx * gWorld[1].xyz;
	r3 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r4 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r4;
	r3 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r3;
	r3 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r3;
	r4 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r4;
	r4 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r4;
	r3 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r3;
	r2.w = dot(r3.xyz, r1.xyz);
	r2.xyz = r2.www * gWorld[0].xyz + r2.xyz;
	r1.x = dot(r4.xyz, r1.xyz);
	r1.xyz = r1.xxx * gWorld[2].xyz + r2.xyz;
	r2.xyz = i.position.xyz;
	r2.xyz = r2.xyz + i.position1.xyz;
	r2.w = 1;
	r0.w = dot(r0, r2);
	r5.xyz = r0.www * gWorld[1].xyz;
	r6 = r0.w * gWorldViewProj[1];
	r0.w = dot(r3, r2);
	r2.x = dot(r4, r2);
	r2.yzw = r0.www * gWorld[0].xyz + r5.xyz;
	r5 = r0.w * gWorldViewProj[0] + r6;
	r5 = r2.x * gWorldViewProj[2] + r5;
	r2.xyz = r2.xxx * gWorld[2].xyz + r2.yzw;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	r5 = r5 + gWorldViewProj[3];
	r6.xyz = -r2.xyz + gViewInverse[3].xyz;
	o.texcoord7 = r2.xyz;
	o.texcoord6.x = dot(r1.xyz, r6.xyz);
	r2.xyz = i.normal.xyz;
	r2.xyz = r2.xyz + i.normal1.xyz;
	r0.x = dot(r0.xyz, r2.xyz);
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r0.w = dot(r3.xyz, r2.xyz);
	r2.x = dot(r4.xyz, r2.xyz);
	r0.xyz = r0.www * gWorld[0].xyz + r0.xyz;
	r0.xyz = r2.xxx * gWorld[2].xyz + r0.xyz;
	r2.xyz = r0.yzx * r1.zxy;
	r2.xyz = r1.yzx * r0.zxy + -r2.xyz;
	o.texcoord4 = r1.xyz;
	r1.xyz = r1.www * r2.xyz;
	o.texcoord6.y = dot(r1.xyz, r6.xyz);
	o.texcoord5 = r1;
	o.texcoord6.z = dot(r0.xyz, r6.xyz);
	o.texcoord3 = r6.xyz;
	o.texcoord1.xyz = r0.xyz;
	o.texcoord2.z = i.color.y * -i.color.x + 1;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r0.yz = float2(1, -1);
	r0.x = i.color.x * globalScalars.z + r0.z;
	r0.x = gAmbientOcclusionEffect.y * r0.x + r0.y;
	r0.y = 1 / gAmbientOcclusionEffect.y;
	r0.x = r0.y * r0.x;
	o.texcoord2.x = min(r0.x, 1);
	o.position = r5;
	o.texcoord1.w = r5.w;
	o.texcoord = i.texcoord;
	o.texcoord2.w = i.color.w;

	return o;
}
