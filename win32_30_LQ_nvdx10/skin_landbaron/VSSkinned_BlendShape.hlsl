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
	float4 tangent : TANGENT;
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
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	float3 r6;
	float3 r7;
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
	o.texcoord2.xyz = r1.xyz + gWorld[3].xyz;
	r1 = r2 + gWorldViewProj[3];
	r2.xyz = i.normal.xyz;
	r2.xyz = r2.yzx + i.normal1.yzx;
	r3.x = dot(r4.yzx, r2.xyz);
	r3.y = dot(r0.yzx, r2.xyz);
	r3.z = dot(r5.yzx, r2.xyz);
	r6 = normalize(r3.xyz);
	r3.xyz = r6.yyy * gWorld[1].xyz;
	r3.xyz = r6.xxx * gWorld[0].xyz + r3.xyz;
	r3.xyz = r6.zzz * gWorld[2].xyz + r3.xyz;
	r0.w = dot(r3.xyz, r3.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord.xyz = r0.www * r3.xyz;
	r3 = i.tangent;
	r3 = r3 + i.tangent1;
	r6.x = dot(r4.xyz, r3.xyz);
	r6.y = dot(r0.xyz, r3.xyz);
	r6.z = dot(r5.xyz, r3.xyz);
	r7 = normalize(r6.xyz);
	r6 = r7.yyy * gWorld[1].xyz;
	r6 = r7.xxx * gWorld[0].xyz + r6.xyz;
	o.texcoord4.xyz = r7.zzz * gWorld[2].xyz + r6.xyz;
	r6 = r2.xyz * r3.zxy;
	r2.xyz = r3.yzx * r2.yzx + -r6.xyz;
	r2.xyz = r3.www * r2.xyz;
	r3.x = dot(r4.xyz, r2.xyz);
	r3.y = dot(r0.xyz, r2.xyz);
	r3.z = dot(r5.xyz, r2.xyz);
	r0.xyz = normalize(r3.xyz);
	r2.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r2.xyz;
	o.texcoord5 = r0.zzz * gWorld[2].xyz + r0.xyw;
	r0.xyz = r1.xwy * 0.5;
	o.texcoord1.x = r0.y + r0.x;
	o.texcoord1.y = r1.w * 0.5 + -r0.z;
	o.position = r1;
	o.texcoord1.zw = r1.ww;
	o.texcoord.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3 = float4(0, 0, 0, 1);
	o.texcoord4.w = i.tangent.w;
	o.color = i.color;

	return o;
}
