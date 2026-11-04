cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
	float4 gShadowParam4567 : packoffset(c3);
	float4 gShadowParam891113 : packoffset(c4);
	float4 gCascadeZScales : packoffset(c5);
	float4 gCascadeZOffsets : packoffset(c6);
	float4 gCascadeXThresholds : packoffset(c7);
	float4 gCascadeYThresholds : packoffset(c8);
	float4 gShadowParamPCF : packoffset(c9);
	row_major float4x4 gShadowMatrix : packoffset(c10);
};

Buffer<float4> clothVertexTexture : register(t2);

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float3 r6;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r1.x = (254 < r0.x) ? -1 : 0;
	if (r1.x != 0) {
		r1 = asint(clothVertexTexture.Load(r0.y));
		r2 = asint(clothVertexTexture.Load(r0.z));
		r3 = clothVertexTexture.Load(r0.w);
		r4.x = dot(gWorld[0].xyz, asfloat(r1.xyz));
		r4.y = dot(gWorld[1].xyz, asfloat(r1.xyz));
		r4.z = dot(gWorld[2].xyz, asfloat(r1.xyz));
		r1.x = asint(dot(gWorld[0].xyz, asfloat(r2.xyz)));
		r1.y = asint(dot(gWorld[1].xyz, asfloat(r2.xyz)));
		r1.z = asint(dot(gWorld[2].xyz, asfloat(r2.xyz)));
		r2.x = asint(dot(gWorld[0].xyz, r3.xyz));
		r2.y = asint(dot(gWorld[1].xyz, r3.xyz));
		r2.z = asint(dot(gWorld[2].xyz, r3.xyz));
		r3.xyz = -(asfloat(r1.zxy)) + r4.zxy;
		r5 = -(asfloat(r1.yzx)) + asfloat(r2.yzx);
		r6 = r3.xyz * r5.xyz;
		r3.xyz = r3.zxy * r5.yzx + -(r6.xyz);
		r1.w = asint(dot(r3.xyz, r3.xyz));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r3.xyz = asfloat(r1.www) * r3.xyz;
		r1.xyz = asint(asfloat(r1.xyz) * i.blendweight.yyy);
		r1.xyz = asint(i.blendweight.zzz * r4.xyz + asfloat(r1.xyz));
		r1.xyz = asint(i.blendweight.xxx * asfloat(r2.xyz) + asfloat(r1.xyz));
		r1.w = asint(i.blendweight.w + -0.5);
		r1.w = asint(asfloat(r1.w) * 0.100000001);
		r1.xyz = asint(asfloat(r1.www) * r3.xyz + asfloat(r1.xyz));
	} else {
		r0 = r0 * int4(3, 3, 3, 3);
		r2 = asint(i.blendweight.y * gBoneMtx[r0.y / 3][0]);
		r3 = i.blendweight.y * gBoneMtx[r0.y / 3][1];
		r4 = i.blendweight.y * gBoneMtx[r0.y / 3][2];
		r2 = asint(gBoneMtx[r0.x / 3][0] * i.blendweight.x + asfloat(r2));
		r3 = gBoneMtx[r0.x / 3][1] * i.blendweight.x + r3;
		r4 = gBoneMtx[r0.x / 3][2] * i.blendweight.x + r4;
		r2 = asint(gBoneMtx[r0.z / 3][0] * i.blendweight.z + asfloat(r2));
		r3 = gBoneMtx[r0.z / 3][1] * i.blendweight.z + r3;
		r4 = gBoneMtx[r0.z / 3][2] * i.blendweight.z + r4;
		r2 = asint(gBoneMtx[r0.w / 3][0] * i.blendweight.w + asfloat(r2));
		r3 = gBoneMtx[r0.w / 3][1] * i.blendweight.w + r3;
		r0 = asint(gBoneMtx[r0.w / 3][2] * i.blendweight.w + r4);
		r4.xyz = i.position.xyz;
		r4.w = 1;
		r1.x = asint(dot(asfloat(r2), r4));
		r1.y = asint(dot(r3, r4));
		r1.z = asint(dot(asfloat(r0), r4));
	}
	r0.xyz = asint(asfloat(r1.yyy) * gWorld[1].xyz);
	r0.xyz = asint(asfloat(r1.xxx) * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r1.zzz) * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + gWorld[3].xyz);
	r1.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyz);
	r1.xyz = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + gShadowMatrix[3].xyz);
	r0.w = asint(asfloat(r1.z) + gShadowParam891113.z);
	r2.xy = (gShadowParam14151617.xy == float2(0, 0)) ? -1 : 0;
	r2.y = (r2.y != 0) ? 1056964608 : -1090519040;
	r1.w = asint(dot(asfloat(r2.yy), asfloat(r0.ww)));
	r0.w = asint(dot(asfloat(r1.xyw), asfloat(r1.xyw)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r2.y = asint(-(asfloat(r1.w)) + asfloat(r0.w));
	r3.xy = asfloat(r1.xy) / asfloat(r2.yy);
	r3.w = asfloat(r1.w) * -(gShadowParam0123.w);
	r3.z = asfloat(r0.w) * -(gShadowParam0123.w);
	r4.xy = asfloat(r1.xy) * gShadowParam0123.zz;
	r4.w = asfloat(asint(-(asfloat(r1.z))));
	r0.w = asint(gShadowParam0123.x * gShadowParam891113.w);
	r0.w = asint(asfloat(r1.z) * gShadowParam891113.w + asfloat(r0.w));
	r1.x = asint(gShadowParam0123.x + -(gShadowParam891113.w));
	r4.z = asfloat(r0.w) / asfloat(r1.x);
	r1 = asint((r2.x != 0) ? r3 : r4);
	o.sv_position = asfloat(r1);
	o.texcoord1.w = asfloat(r1.w);
	o.texcoord1.xyz = asfloat(r0.xyz);

	return o;
}
