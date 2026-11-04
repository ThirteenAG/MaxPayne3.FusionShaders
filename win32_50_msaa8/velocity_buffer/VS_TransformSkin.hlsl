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

cbuffer BoneVelocity : register(b4)
{
	float4 vBoneVelocitiesX[19] : packoffset(c0);
	float4 vBoneVelocitiesY[19] : packoffset(c19);
	float fAge : packoffset(c38);
	float fIntensity : packoffset(c38.y);
};

static const float4 icb[4] =
{
	float4(1, 0, 0, 0),
	float4(0, 1, 0, 0),
	float4(0, 0, 1, 0),
	float4(0, 0, 0, 1),
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
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r1.x = (254 < r0.x) ? -1 : 0;
	if (r1.x != 0) {
		r1.xyz = asint(clothVertexTexture.Load(r0.y).xyz);
		r2.xyz = asint(clothVertexTexture.Load(r0.z).xyz);
		r3.xyz = clothVertexTexture.Load(r0.w).xyz;
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
		r5.xyz = -(asfloat(r1.yzx)) + asfloat(r2.yzx);
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
		r2 = r0 * int4(3, 3, 3, 3);
		r3 = i.blendweight.y * gBoneMtx[r2.y / 3][0];
		r4 = i.blendweight.y * gBoneMtx[r2.y / 3][1];
		r5 = i.blendweight.y * gBoneMtx[r2.y / 3][2];
		r3 = gBoneMtx[r2.x / 3][0] * i.blendweight.x + r3;
		r4 = gBoneMtx[r2.x / 3][1] * i.blendweight.x + r4;
		r5 = gBoneMtx[r2.x / 3][2] * i.blendweight.x + r5;
		r3 = gBoneMtx[r2.z / 3][0] * i.blendweight.z + r3;
		r4 = gBoneMtx[r2.z / 3][1] * i.blendweight.z + r4;
		r5 = gBoneMtx[r2.z / 3][2] * i.blendweight.z + r5;
		r3 = gBoneMtx[r2.w / 3][0] * i.blendweight.w + r3;
		r4 = gBoneMtx[r2.w / 3][1] * i.blendweight.w + r4;
		r2 = asint(gBoneMtx[r2.w / 3][2] * i.blendweight.w + r5);
		r5.xyz = i.position.xyz;
		r5.w = 1;
		r1.x = asint(dot(r3, r5));
		r1.y = asint(dot(r4, r5));
		r1.z = asint(dot(asfloat(r2), r5));
	}
	r2 = asint(asfloat(r1.y) * gWorldViewProj[1]);
	r2 = asint(asfloat(r1.x) * gWorldViewProj[0] + asfloat(r2));
	r1 = asint(asfloat(r1.z) * gWorldViewProj[2] + asfloat(r2));
	o.sv_position = asfloat(r1) + gWorldViewProj[3];
	r1 = r0 & int4(3, 3, 3, 3);
	r0 = (uint4)r0 >> uint4(2, 2, 2, 2);
	r2.x = asint(dot(vBoneVelocitiesX[r0.x], icb[r1.x]));
	r2.y = asint(dot(vBoneVelocitiesX[r0.y], icb[r1.y]));
	r2.z = asint(dot(vBoneVelocitiesX[r0.z], icb[r1.z]));
	r2.w = asint(dot(vBoneVelocitiesX[r0.w], icb[r1.w]));
	r3.x = dot(vBoneVelocitiesY[r0.x], icb[r1.x]);
	r3.y = dot(vBoneVelocitiesY[r0.y], icb[r1.y]);
	r3.z = dot(vBoneVelocitiesY[r0.z], icb[r1.z]);
	r3.w = dot(vBoneVelocitiesY[r0.w], icb[r1.w]);
	r0.x = asint(dot(asfloat(r2), i.blendweight));
	r0.x = asint(asfloat(r0.x) * fIntensity);
	o.texcoord.x = asfloat(r0.x) * 0.5 + 0.5;
	r0.x = asint(dot(r3, i.blendweight));
	r0.x = asint(asfloat(r0.x) * fIntensity);
	o.texcoord.y = asfloat(r0.x) * 0.5 + 0.5;
	o.texcoord.z = fAge;
	o.texcoord.w = 1;

	return o;
}
