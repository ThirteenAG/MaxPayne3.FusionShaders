cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 tangent : TANGENT;
	float3 position1 : POSITION1;
	float3 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
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
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.xyz = i.position.xyz + i.position1.xyz;
	r1 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r1 = (int4)asfloat(r1);
	r1 = r1 * int4(3, 3, 3, 3);
	r2 = i.blendweight.y * gBoneMtx[r1.y / 3][1];
	r2 = gBoneMtx[r1.x / 3][1] * i.blendweight.x + r2;
	r2 = gBoneMtx[r1.z / 3][1] * i.blendweight.z + r2;
	r2 = gBoneMtx[r1.w / 3][1] * i.blendweight.w + r2;
	r0.w = 1;
	r2.w = dot(r2, r0);
	r3 = r2.w * gWorldViewProj[1];
	r4.xyz = r2.www * gWorld[1].xyz;
	r5 = i.blendweight.y * gBoneMtx[r1.y / 3][0];
	r5 = gBoneMtx[r1.x / 3][0] * i.blendweight.x + r5;
	r5 = gBoneMtx[r1.z / 3][0] * i.blendweight.z + r5;
	r5 = gBoneMtx[r1.w / 3][0] * i.blendweight.w + r5;
	r2.w = dot(r5, r0);
	r3 = r2.w * gWorldViewProj[0] + r3;
	r4.xyz = r2.www * gWorld[0].xyz + r4.xyz;
	r6 = i.blendweight.y * gBoneMtx[r1.y / 3][2];
	r6 = gBoneMtx[r1.x / 3][2] * i.blendweight.x + r6;
	r6 = gBoneMtx[r1.z / 3][2] * i.blendweight.z + r6;
	r1 = asint(gBoneMtx[r1.w / 3][2] * i.blendweight.w + r6);
	r0.x = dot(asfloat(r1), r0);
	r3 = r0.x * gWorldViewProj[2] + r3;
	r0.xyz = r0.xxx * gWorld[2].xyz + r4.xyz;
	o.texcoord2.xyz = r0.xyz + gWorld[3].xyz;
	r0 = r3 + gWorldViewProj[3];
	o.sv_position = r0;
	r3.xyz = i.normal.yzx + i.normal1.yzx;
	r4.x = dot(r5.yzx, r3.xyz);
	r4.y = dot(r2.yzx, r3.xyz);
	r4.z = dot(asfloat(r1.yzx), r3.xyz);
	r0.z = dot(r4.xyz, r4.xyz);
	r0.z = rsqrt(r0.z);
	r4.xyz = r0.zzz * r4.xyz;
	r6.xyz = r4.yyy * gWorld[1].xyz;
	r4.xyw = r4.xxx * gWorld[0].xyz + r6.xyz;
	r4.xyz = r4.zzz * gWorld[2].xyz + r4.xyw;
	r0.z = dot(r4.xyz, r4.xyz);
	r0.z = rsqrt(r0.z);
	o.texcoord.xyz = r0.zzz * r4.xyz;
	o.texcoord.w = i.texcoord.x;
	r0.xyz = r0.xwy * float3(0.5, 0.5, 0.5);
	o.texcoord1.y = r0.w * 0.5 + -(r0.z);
	o.texcoord1.x = r0.y + r0.x;
	o.texcoord1.zw = r0.ww;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3 = float4(0, 0, 0, 1);
	r0 = i.tangent + i.tangent1;
	r4.x = dot(r5.xyz, r0.xyz);
	r4.y = dot(r2.xyz, r0.xyz);
	r4.z = dot(asfloat(r1.xyz), r0.xyz);
	r1.w = asint(dot(r4.xyz, r4.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4.xyz = asfloat(r1.www) * r4.xyz;
	r6.xyz = r4.yyy * gWorld[1].xyz;
	r4.xyw = r4.xxx * gWorld[0].xyz + r6.xyz;
	o.texcoord4.xyz = r4.zzz * gWorld[2].xyz + r4.xyw;
	o.texcoord4.w = i.tangent.w;
	r4.xyz = r3.xyz * r0.zxy;
	r0.xyz = r0.yzx * r3.yzx + -(r4.xyz);
	r0.xyz = r0.www * r0.xyz;
	r3.x = dot(r5.xyz, r0.xyz);
	r3.y = dot(r2.xyz, r0.xyz);
	r3.z = dot(asfloat(r1.xyz), r0.xyz);
	r0.x = dot(r3.xyz, r3.xyz);
	r0.x = rsqrt(r0.x);
	r0.xyz = r0.xxx * r3.xyz;
	r1.xyz = asint(r0.yyy * gWorld[1].xyz);
	r0.xyw = r0.xxx * gWorld[0].xyz + asfloat(r1.xyz);
	o.texcoord5 = r0.zzz * gWorld[2].xyz + r0.xyw;
	o.color = i.color;

	return o;
}
