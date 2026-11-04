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

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
};

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	float3 r3;
	float4 r4;
	float4 r5;
	r0.x = dot(gWorldView[3], gWorldView[3]);
	r0.x = sqrt(r0.x);
	r0.x = r0.x * gDirectionalColour.x;
	r1 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r1 = (int4)asfloat(r1);
	r1 = r1 * int4(3, 3, 3, 3);
	r2 = i.blendweight.y * gBoneMtx[r1.y / 3][0];
	r2 = gBoneMtx[r1.x / 3][0] * i.blendweight.x + r2;
	r2 = gBoneMtx[r1.z / 3][0] * i.blendweight.z + r2;
	r2 = gBoneMtx[r1.w / 3][0] * i.blendweight.w + r2;
	r3.x = dot(r2.xyz, i.normal.xyz);
	r4 = i.blendweight.y * gBoneMtx[r1.y / 3][1];
	r4 = gBoneMtx[r1.x / 3][1] * i.blendweight.x + r4;
	r4 = gBoneMtx[r1.z / 3][1] * i.blendweight.z + r4;
	r4 = gBoneMtx[r1.w / 3][1] * i.blendweight.w + r4;
	r3.y = dot(r4.xyz, i.normal.xyz);
	r5 = i.blendweight.y * gBoneMtx[r1.y / 3][2];
	r5 = gBoneMtx[r1.x / 3][2] * i.blendweight.x + r5;
	r5 = gBoneMtx[r1.z / 3][2] * i.blendweight.z + r5;
	r1 = asint(gBoneMtx[r1.w / 3][2] * i.blendweight.w + r5);
	r3.z = dot(asfloat(r1.xyz), i.normal.xyz);
	r5.xyz = i.position.xyz;
	r5.w = 1;
	r2.x = dot(r2, r5);
	r2.y = dot(r4, r5);
	r2.z = dot(asfloat(r1), r5);
	r0.xyz = r3.xyz * r0.xxx + r2.xyz;
	r1 = asint(r0.y * gWorldViewProj[1]);
	r1 = asint(r0.x * gWorldViewProj[0] + asfloat(r1));
	r1 = asint(r0.z * gWorldViewProj[2] + asfloat(r1));
	r1 = asint(asfloat(r1) + gWorldViewProj[3]);
	o.sv_position = asfloat(r1);
	r0.y = r0.y * gWorldView[1].z;
	r0.x = r0.x * gWorldView[0].z + r0.y;
	r0.x = r0.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord.z = -(r0.x);
	r0 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.25), 0);
	r0.y = -(r0.y) + asfloat(r1.w);
	r1.x = asint(r0.x * r0.y + asfloat(r1.x));
	r0.xy = asfloat(r1.xy) * float2(0.5, -0.5);
	r0.xy = r0.xy / asfloat(r1.ww);
	o.texcoord.xy = r0.xy + float2(0.5, 0.5);

	return o;
}
