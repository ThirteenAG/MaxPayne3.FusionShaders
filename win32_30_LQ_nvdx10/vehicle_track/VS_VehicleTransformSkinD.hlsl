float4 TrackAnimUV : register(c198);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
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
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int a0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = 765.00586 * i.blendindices.x;
	a0 = r0.x;
	r0.z = dot(gBoneMtx[a0 / 3][0].xyz, i.normal.xyz);
	r0.x = dot(gBoneMtx[a0 / 3][1].xyz, i.normal.xyz);
	r0.y = dot(gBoneMtx[a0 / 3][2].xyz, i.normal.xyz);
	r1.x = dot(gBoneMtx[a0 / 3][0].xyz, i.tangent.xyz);
	r1.y = dot(gBoneMtx[a0 / 3][1].xyz, i.tangent.xyz);
	r1.z = dot(gBoneMtx[a0 / 3][2].xyz, i.tangent.xyz);
	r2.xyz = r0.xyz * r1.zxy;
	r2.xyz = r1.yzx * r0.yzx + -r2.xyz;
	r3 = r0.xxx * gWorld[1].xyz;
	r0.xzw = r0.zzz * gWorld[0].xyz + r3.xyz;
	o.texcoord1.xyz = r0.yyy * gWorld[2].xyz + r0.xzw;
	o.texcoord4 = r1.xyz;
	o.texcoord5.xyz = r2.xyz * i.tangent.www;
	r0.x = (0 < i.position.x) ? 1 : 0;
	r0.yz = TrackAnimUV.xy + i.texcoord.xx;
	r0.y = -r0.z + r0.y;
	o.texcoord.x = r0.x * r0.y + r0.z;
	r0 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r1.x = dot(gBoneMtx[a0 / 3][1], r0);
	r2 = r1.x * gWorld[1];
	r1 = r1.x * gWorldViewProj[1];
	r3.x = dot(gBoneMtx[a0 / 3][0], r0);
	r0.x = dot(gBoneMtx[a0 / 3][2], r0);
	r2 = r3.x * gWorld[0] + r2;
	r1 = r3.x * gWorldViewProj[0] + r1;
	r1 = r0.x * gWorldViewProj[2] + r1;
	r0 = r0.x * gWorld[2] + r2;
	o.texcoord6 = r0 + gWorld[3];
	r0 = r1 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord.y = i.texcoord.y;
	o.texcoord2 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord5.w = i.tangent.w;

	return o;
}
