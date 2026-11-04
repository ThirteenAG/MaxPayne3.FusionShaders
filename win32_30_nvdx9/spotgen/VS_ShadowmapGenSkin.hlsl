sampler2D clothVertexSampler : register(s2);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gShadowMatrix : register(c57);
row_major float4x4 gWorld : register(c0);
float4 invVertexBufferSize : register(c208);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
};

struct VS_OUT
{
	float4 position : POSITION;
	float texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	int2 a0;
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
		r5 = r0.xyz * r4.xyz;
		r0.xyz = r0.zxy * r4.yzx + -r5.xyz;
		r4.xyz = normalize(r0.xyz);
		r0.xyz = r1.xyz * i.blendweight.yyy;
		r0.xyz = i.blendweight.zzz * r3.xyz + r0.xyz;
		r0.xyz = i.blendweight.xxx * r2.xyz + r0.xyz;
		r0.w = -0.5 + i.blendweight.w;
		r0.w = r0.w * 0.1;
		r0.xyz = r0.www * r4.xyz + r0.xyz;
	} else {
		r1 = 765.00586 * i.blendindices;
		a0 = r1.xy;
		r2 = i.blendweight.y * gBoneMtx[a0.y / 3][0];
		r3 = i.blendweight.y * gBoneMtx[a0.y / 3][1];
		r4 = i.blendweight.y * gBoneMtx[a0.y / 3][2];
		r2 = gBoneMtx[a0.x / 3][0] * i.blendweight.x + r2;
		r3 = gBoneMtx[a0.x / 3][1] * i.blendweight.x + r3;
		r4 = gBoneMtx[a0.x / 3][2] * i.blendweight.x + r4;
		a0.x = r1.z;
		r2 = gBoneMtx[a0.x / 3][0] * i.blendweight.z + r2;
		r3 = gBoneMtx[a0.x / 3][1] * i.blendweight.z + r3;
		r4 = gBoneMtx[a0.x / 3][2] * i.blendweight.z + r4;
		a0.x = r1.w;
		r1 = gBoneMtx[a0.x / 3][0] * i.blendweight.w + r2;
		r2 = gBoneMtx[a0.x / 3][1] * i.blendweight.w + r3;
		r3 = gBoneMtx[a0.x / 3][2] * i.blendweight.w + r4;
		r4 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
		r0.x = dot(r1, r4);
		r0.y = dot(r2, r4);
		r0.z = dot(r3, r4);
	}
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = r0.y * gShadowMatrix[1];
	r1 = r0.x * gShadowMatrix[0] + r1;
	r0 = r0.z * gShadowMatrix[2] + r1;
	r0 = r0 + gShadowMatrix[3];
	o.position = r0;
	o.texcoord = r0.w;

	return o;
}
