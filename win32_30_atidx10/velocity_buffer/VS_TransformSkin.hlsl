sampler2D clothVertexSampler : register(s2);
float fAge : register(c247);
float fIntensity : register(c248);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 invVertexBufferSize : register(c208);
float4 vBoneVelocitiesX[19] : register(c209);
float4 vBoneVelocitiesY[19] : register(c228);

static const float4 c196[6] =
{
	float4(1, 0, 0, 0),
	float4(0, 1, 0, 0),
	float4(0, 0, 1, 0),
	float4(0, 0, 0, 1),
	float4(0.9960708, 255.00195, 0.5, -0.5),
	float4(0.1, 765.00586, 63.75049, 4),
};

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	int4 a0;
	if (0.9960708 < i.blendindices.x) {
		r0.xyz = i.blendindices.yzw * 255.00195 + 0.5;
		r0.xyz = r0.xyz * invVertexBufferSize.xxx;
		r0.w = 0;
		r1 = tex2Dlod(clothVertexSampler, r0.xwww);
		r2 = tex2Dlod(clothVertexSampler, r0.ywww);
		r0 = tex2Dlod(clothVertexSampler, r0.zwww);
		r3.x = dot(gWorld[0].xyz, r1.xyz);
		r3.y = dot(gWorld[1].xyz, r1.xyz);
		r3.z = dot(gWorld[2].xyz, r1.xyz);
		r1.x = dot(gWorld[0].xyz, r2.xyz);
		r1.y = dot(gWorld[1].xyz, r2.xyz);
		r1.z = dot(gWorld[2].xyz, r2.xyz);
		r2.x = dot(gWorld[0].xyz, r0.xyz);
		r2.y = dot(gWorld[1].xyz, r0.xyz);
		r2.z = dot(gWorld[2].xyz, r0.xyz);
		r0.xyz = -r1.zxy + r3.zxy;
		r4.xyz = -r1.yzx + r2.yzx;
		r5.xyz = r0.xyz * r4.xyz;
		r0.xyz = r0.zxy * r4.yzx + -r5.xyz;
		r4.xyz = normalize(r0.xyz);
		r0.xyz = r1.xyz * i.blendweight.yyy;
		r0.xyz = i.blendweight.zzz * r3.xyz + r0.xyz;
		r0.xyz = i.blendweight.xxx * r2.xyz + r0.xyz;
		r0.w = i.blendweight.w + -0.5;
		r0.w = r0.w * 0.1;
		r0.xyz = r0.www * r4.xyz + r0.xyz;
	} else {
		r1 = i.blendindices * 765.00586;
		a0.w = r1.y;
		r2 = i.blendweight.y * gBoneMtx[a0.w / 3][0];
		a0.w = r1.y;
		r3 = i.blendweight.y * gBoneMtx[a0.w / 3][1];
		a0.w = r1.y;
		r4 = i.blendweight.y * gBoneMtx[a0.w / 3][2];
		a0.w = r1.x;
		r2 = gBoneMtx[a0.w / 3][0] * i.blendweight.x + r2;
		a0.w = r1.x;
		r3 = gBoneMtx[a0.w / 3][1] * i.blendweight.x + r3;
		a0.w = r1.x;
		r4 = gBoneMtx[a0.w / 3][2] * i.blendweight.x + r4;
		a0.w = r1.z;
		r2 = gBoneMtx[a0.w / 3][0] * i.blendweight.z + r2;
		a0.w = r1.z;
		r3 = gBoneMtx[a0.w / 3][1] * i.blendweight.z + r3;
		a0.w = r1.z;
		r4 = gBoneMtx[a0.w / 3][2] * i.blendweight.z + r4;
		a0.w = r1.w;
		r2 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r2;
		a0.w = r1.w;
		r3 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r3;
		a0.w = r1.w;
		r1 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r4;
		r4 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
		r0.x = dot(r2, r4);
		r0.y = dot(r3, r4);
		r0.z = dot(r1, r4);
	}
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	r0 = i.blendindices * 63.75049;
	r1 = frac(r0);
	r2 = r1 * 4;
	r3 = frac(r2);
	r2 = r2 + -r3;
	r0 = r0 + -r1;
	a0.w = r2.x;
	r1 = c196[a0.w];
	a0.w = r0.x;
	r3.x = dot(vBoneVelocitiesX[a0.w], r1);
	a0.w = r2.y;
	r4 = c196[a0.w];
	a0.w = r0.y;
	r3.y = dot(vBoneVelocitiesX[a0.w], r4);
	a0.w = r2.z;
	r5 = c196[a0.w];
	a0.w = r0.z;
	r3.z = dot(vBoneVelocitiesX[a0.w], r5);
	a0.w = r2.w;
	r2 = c196[a0.w];
	a0.w = r0.w;
	r3.w = dot(vBoneVelocitiesX[a0.w], r2);
	a0.w = r0.x;
	r1.x = dot(vBoneVelocitiesY[a0.w], r1);
	a0.w = r0.y;
	r1.y = dot(vBoneVelocitiesY[a0.w], r4);
	a0.w = r0.z;
	r1.z = dot(vBoneVelocitiesY[a0.w], r5);
	a0.w = r0.w;
	r1.w = dot(vBoneVelocitiesY[a0.w], r2);
	r0.x = dot(r3, i.blendweight);
	r0.x = r0.x * fIntensity.x;
	o.texcoord.x = r0.x * 0.5 + 0.5;
	r0.x = dot(r1, i.blendweight);
	r0.x = r0.x * fIntensity.x;
	o.texcoord.y = r0.x * 0.5 + 0.5;
	r0.xy = float2(1, 0);
	o.texcoord.zw = fAge.xx * r0.xy + r0.yx;

	return o;
}
