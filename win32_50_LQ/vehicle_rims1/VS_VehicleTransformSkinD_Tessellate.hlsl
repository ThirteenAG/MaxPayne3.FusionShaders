cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float2 texcoord : TEXCOORD;
	float2 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	o.texcoord8.w = 1;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r0 = r0 * int4(3, 3, 3, 3);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][0];
	r1 = gBoneMtx[r0.x / 3][0] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][0] * i.blendweight.z + r1;
	r1 = gBoneMtx[r0.w / 3][0] * i.blendweight.w + r1;
	r2.xyz = i.position.xyz;
	r2.w = 1;
	o.texcoord8.x = dot(r1, r2);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][1];
	r1 = gBoneMtx[r0.x / 3][1] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][1] * i.blendweight.z + r1;
	r1 = gBoneMtx[r0.w / 3][1] * i.blendweight.w + r1;
	o.texcoord8.y = dot(r1, r2);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][2];
	r1 = gBoneMtx[r0.x / 3][2] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][2] * i.blendweight.z + r1;
	r0 = asint(gBoneMtx[r0.w / 3][2] * i.blendweight.w + r1);
	o.texcoord8.z = dot(asfloat(r0), r2);
	o.texcoord = i.texcoord.xy;
	o.texcoord7 = i.texcoord.zw;
	r0.x = asint(i.blendindices.x * 255.001953);
	r0.x = (int)asfloat(r0.x);
	r0.x = r0.x * 3;
	r0.y = asint(dot(gBoneMtx[r0.x / 3][1], r2));
	r0.z = asint(asfloat(r0.y) * gWorldViewProj[1].w);
	r0.w = asint(dot(gBoneMtx[r0.x / 3][0], r2));
	r1.x = dot(gBoneMtx[r0.x / 3][2], r2);
	r0.z = asint(asfloat(r0.w) * gWorldViewProj[0].w + asfloat(r0.z));
	r0.z = asint(r1.x * gWorldViewProj[2].w + asfloat(r0.z));
	o.texcoord1.w = asfloat(r0.z) + gWorldViewProj[3].w;
	r0.z = asint(dot(gBoneMtx[r0.x / 3][1].xyz, i.normal.xyz));
	r1.yzw = asfloat(r0.zzz) * gWorld[1].xyz;
	r0.z = asint(dot(gBoneMtx[r0.x / 3][0].xyz, i.normal.xyz));
	r0.x = asint(dot(gBoneMtx[r0.x / 3][2].xyz, i.normal.xyz));
	r1.yzw = asfloat(r0.zzz) * gWorld[0].xyz + r1.yzw;
	o.texcoord1.xyz = asfloat(r0.xxx) * gWorld[2].xyz + r1.yzw;
	o.texcoord2.xyz = i.color.xyz;
	o.texcoord2.w = 1;
	r1.yzw = asfloat(r0.yyy) * gWorld[1].xyz;
	r2 = asfloat(r0.y) * gWorld[1];
	r2 = asfloat(r0.w) * gWorld[0] + r2;
	r0.xyz = asint(asfloat(r0.www) * gWorld[0].xyz + r1.yzw);
	r0.xyz = asint(r1.xxx * gWorld[2].xyz + asfloat(r0.xyz));
	r1 = r1.x * gWorld[2] + r2;
	o.texcoord6 = r1 + gWorld[3];
	r0.xyz = asint(asfloat(r0.xyz) + gWorld[3].xyz);
	o.texcoord3 = -(asfloat(r0.xyz)) + gViewInverse[3].xyz;
	o.texcoord9 = i.normal.xyz;

	return o;
}
