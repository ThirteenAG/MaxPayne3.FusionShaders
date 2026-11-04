row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float2 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	int a0;
	float4 r2;
	r0 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r1.x = 765.00586 * i.blendindices.x;
	a0 = r1.x;
	r1.x = dot(gBoneMtx[a0 / 3][1], r0);
	r1.yzw = r1.xxx * gWorld[1].xyz;
	r2 = r1.x * gWorldViewProj[1];
	r1.x = dot(gBoneMtx[a0 / 3][0], r0);
	r0.x = dot(gBoneMtx[a0 / 3][2], r0);
	r0.yzw = r1.xxx * gWorld[0].xyz + r1.yzw;
	r1 = r1.x * gWorldViewProj[0] + r2;
	r1 = r0.x * gWorldViewProj[2] + r1;
	r0.xyz = r0.xxx * gWorld[2].xyz + r0.yzw;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r1 + gWorldViewProj[3];
	o.texcoord3 = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord2 = r0.xyz;
	r0.x = dot(gBoneMtx[a0 / 3][1].xyz, i.normal.xyz);
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r0.w = dot(gBoneMtx[a0 / 3][0].xyz, i.normal.xyz);
	r2.x = dot(gBoneMtx[a0 / 3][2].xyz, i.normal.xyz);
	r0.xyz = r0.www * gWorld[0].xyz + r0.xyz;
	o.texcoord1.xyz = r2.xxx * gWorld[2].xyz + r0.xyz;
	o.position = r1;
	o.texcoord1.w = r1.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord6 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord7 = i.texcoord.zw;

	return o;
}
