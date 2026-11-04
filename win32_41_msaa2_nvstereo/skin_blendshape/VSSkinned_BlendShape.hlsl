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
	float3 position1 : POSITION1;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r0 = r0 * int4(3, 3, 3, 3);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][1];
	r1 = gBoneMtx[r0.x / 3][1] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][1] * i.blendweight.z + r1;
	r1 = gBoneMtx[r0.w / 3][1] * i.blendweight.w + r1;
	r2.xyz = i.position.xyz + i.position1.xyz;
	r2.w = 1;
	r1.w = dot(r1, r2);
	r1.y = dot(r1.xyz, i.normal.xyz);
	r3 = r1.w * gWorldViewProj[1];
	r4 = r1.www * gWorld[1].xyz;
	r5 = i.blendweight.y * gBoneMtx[r0.y / 3][0];
	r5 = gBoneMtx[r0.x / 3][0] * i.blendweight.x + r5;
	r5 = gBoneMtx[r0.z / 3][0] * i.blendweight.z + r5;
	r5 = gBoneMtx[r0.w / 3][0] * i.blendweight.w + r5;
	r1.w = dot(r5, r2);
	r1.x = dot(r5.xyz, i.normal.xyz);
	r3 = r1.w * gWorldViewProj[0] + r3;
	r4 = r1.www * gWorld[0].xyz + r4.xyz;
	r5 = i.blendweight.y * gBoneMtx[r0.y / 3][2];
	r5 = gBoneMtx[r0.x / 3][2] * i.blendweight.x + r5;
	r5 = gBoneMtx[r0.z / 3][2] * i.blendweight.z + r5;
	r0 = asint(gBoneMtx[r0.w / 3][2] * i.blendweight.w + r5);
	r0.w = asint(dot(asfloat(r0), r2));
	r1.z = dot(asfloat(r0.xyz), i.normal.xyz);
	r2 = asfloat(r0.w) * gWorldViewProj[2] + r3;
	r0.xyz = asint(asfloat(r0.www) * gWorld[2].xyz + r4.xyz);
	o.texcoord2.xyz = asfloat(r0.xyz) + gWorld[3].xyz;
	r0 = asint(r2 + gWorldViewProj[3]);
	o.sv_position = asfloat(r0);
	r0.z = asint(dot(r1.xyz, r1.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r1.xyz = asfloat(r0.zzz) * r1.xyz;
	r2.xyz = r1.yyy * gWorld[1].xyz;
	r1.xyw = r1.xxx * gWorld[0].xyz + r2.xyz;
	r1.xyz = r1.zzz * gWorld[2].xyz + r1.xyw;
	r0.z = asint(dot(r1.xyz, r1.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	o.texcoord.xyz = asfloat(r0.zzz) * r1.xyz;
	o.texcoord.w = i.texcoord.x;
	r0.xyz = asint(asfloat(r0.xwy) * float3(0.5, 0.5, 0.5));
	o.texcoord1.y = asfloat(r0.w) * 0.5 + -(asfloat(r0.z));
	o.texcoord1.x = asfloat(r0.y) + asfloat(r0.x);
	o.texcoord1.zw = asfloat(r0.ww);
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3 = float4(0, 0, 0, 1);
	o.color = i.color;

	return o;
}
