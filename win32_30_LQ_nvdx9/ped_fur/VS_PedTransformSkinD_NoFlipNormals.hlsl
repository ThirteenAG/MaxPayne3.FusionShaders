float4 furGlobalParams : register(c206);
float4 gAmbientOcclusionEffect : register(c63);
row_major float3x4 gBoneMtx[40] : register(c76);
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
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float2 texcoord3 : TEXCOORD3;
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
	float3 r3;
	float4 r4;
	float4 r5;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r2.y = dot(r0, r1);
	r3 = r2.yyy * gWorld[1].xyz;
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r5 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r5 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r5;
	r4 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r4;
	r4 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r4;
	r5 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r5;
	r5 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r5;
	r4 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r4;
	r2.x = dot(r4, r1);
	r2.z = dot(r5, r1);
	r1.xyz = r2.xxx * gWorld[0].xyz + r3.xyz;
	r1.xyz = r2.zzz * gWorld[2].xyz + r1.xyz;
	o.texcoord7 = r1.xyz + gWorld[3].xyz;
	r0.w = dot(r0.xyz, i.tangent.xyz);
	r0.x = dot(r0.xyz, i.normal.xyz);
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r1.xyz = r0.www * gWorld[1].xyz;
	r0.w = dot(r4.xyz, i.tangent.xyz);
	r1.w = dot(r4.xyz, i.normal.xyz);
	r0.xyz = r1.www * gWorld[0].xyz + r0.xyz;
	r1.xyz = r0.www * gWorld[0].xyz + r1.xyz;
	r0.w = dot(r5.xyz, i.tangent.xyz);
	r1.w = dot(r5.xyz, i.normal.xyz);
	r0.xyz = r1.www * gWorld[2].xyz + r0.xyz;
	r1.xyz = r0.www * gWorld[2].xyz + r1.xyz;
	r3 = r0.yzx * r1.zxy;
	r3 = r1.yzx * r0.zxy + -r3.xyz;
	o.texcoord4 = r1.xyz;
	o.texcoord5.xyz = r3.xyz * i.tangent.www;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r1.yzw = float3(1, 0, -1);
	r0.w = i.color.x * globalScalars.z + r1.w;
	r0.w = gAmbientOcclusionEffect.y * r0.w + r1.y;
	r1.x = 1 / gAmbientOcclusionEffect.y;
	r0.w = r0.w * r1.x;
	o.texcoord2.x = min(r0.w, 1);
	r3 = r0.xyz * furGlobalParams.zzz;
	o.texcoord1.xyz = r0.xyz;
	r0.xyz = r3.xyz * furGlobalParams.xxx + r2.xyz;
	r2 = r0.y * gWorldViewProj[1];
	r2 = r0.x * gWorldViewProj[0] + r2;
	r0 = r0.z * gWorldViewProj[2] + r2;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord2.zw = i.color.zw;
	o.texcoord3 = r1.yz * furGlobalParams.yy;
	o.texcoord5.w = i.tangent.w;

	return o;
}
