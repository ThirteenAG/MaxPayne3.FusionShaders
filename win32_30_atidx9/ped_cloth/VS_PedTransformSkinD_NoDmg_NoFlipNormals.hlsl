sampler2D clothVertexSampler : register(s2);
float4 gAmbientOcclusionEffect : register(c63);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 invVertexBufferSize : register(c208);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int2 a0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float3 r8;
	float3 r9;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.xy;
	r1 = i.blendweight.y * gBoneMtx[a0.y / 3][0];
	r2 = i.blendweight.y * gBoneMtx[a0.y / 3][1];
	r3 = i.blendweight.y * gBoneMtx[a0.y / 3][2];
	r1 = gBoneMtx[a0.x / 3][0] * i.blendweight.x + r1;
	r2 = gBoneMtx[a0.x / 3][1] * i.blendweight.x + r2;
	r3 = gBoneMtx[a0.x / 3][2] * i.blendweight.x + r3;
	a0.x = r0.z;
	r1 = gBoneMtx[a0.x / 3][0] * i.blendweight.z + r1;
	r2 = gBoneMtx[a0.x / 3][1] * i.blendweight.z + r2;
	r3 = gBoneMtx[a0.x / 3][2] * i.blendweight.z + r3;
	a0.x = r0.w;
	r0 = gBoneMtx[a0.x / 3][0] * i.blendweight.w + r1;
	r1 = gBoneMtx[a0.x / 3][1] * i.blendweight.w + r2;
	r2 = gBoneMtx[a0.x / 3][2] * i.blendweight.w + r3;
	r3.x = (0.9960708 < i.blendindices.x) ? 1 : 0;
	r4 = lerp(r0, gBoneMtx[0][0], r3.x);
	r0 = lerp(r1, gBoneMtx[0][1], r3.x);
	r1 = lerp(r2, gBoneMtx[0][2], r3.x);
	r2.x = dot(r4.xyz, i.tangent.xyz);
	r2.y = dot(r0.xyz, i.tangent.xyz);
	r2.z = dot(r1.xyz, i.tangent.xyz);
	r3.xyz = r2.yyy * gWorld[1].xyz;
	r2.xyw = r2.xxx * gWorld[0].xyz + r3.xyz;
	r2.xyz = r2.zzz * gWorld[2].xyz + r2.xyw;
	if (0.9960708 < i.blendindices.x) {
		r3.xyz = i.blendindices.yzw * 255.00195 + 0.5;
		r3.xyz = r3.xyz * invVertexBufferSize.xxx;
		r3.w = 0;
		r5 = tex2Dlod(clothVertexSampler, r3.xwww);
		r6 = tex2Dlod(clothVertexSampler, r3.ywww);
		r3 = tex2Dlod(clothVertexSampler, r3.zwww);
		r7.x = dot(gWorld[0].xyz, r5.xyz);
		r7.y = dot(gWorld[1].xyz, r5.xyz);
		r7.z = dot(gWorld[2].xyz, r5.xyz);
		r5.x = dot(gWorld[0].xyz, r6.xyz);
		r5.y = dot(gWorld[1].xyz, r6.xyz);
		r5.z = dot(gWorld[2].xyz, r6.xyz);
		r6.x = dot(gWorld[0].xyz, r3.xyz);
		r6.y = dot(gWorld[1].xyz, r3.xyz);
		r6.z = dot(gWorld[2].xyz, r3.xyz);
		r3.xyz = -r5.zxy + r7.zxy;
		r8 = -r5.yzx + r6.yzx;
		r9 = r3.xyz * r8.xyz;
		r3.xyz = r3.zxy * r8.yzx + -r9.xyz;
		r8 = normalize(r3.xyz);
		r3.xyz = r5.xyz * i.blendweight.yyy;
		r3.xyz = i.blendweight.zzz * r7.xyz + r3.xyz;
		r3.xyz = i.blendweight.xxx * r6.xyz + r3.xyz;
		r3.w = -0.5 + i.blendweight.w;
		r3.w = r3.w * 0.1;
		r3.xyz = r3.www * r8.xyz + r3.xyz;
		r5.xyz = r3.yyy * gWorld[1].xyz;
		r5.xyz = r3.xxx * gWorld[0].xyz + r5.xyz;
		r5.xyz = r3.zzz * gWorld[2].xyz + r5.xyz;
		o.texcoord7 = r5.xyz + gWorld[3].xyz;
		r5.xyz = -r8.yyy * gWorld[1].xyz;
		r5.xyz = -r8.xxx * gWorld[0].xyz + r5.xyz;
		r5.xyz = -r8.zzz * gWorld[2].xyz + r5.xyz;
		r6.xyz = normalize(r5.xyz);
		r5.xyz = normalize(r2.xyz);
		r7.xyz = r6.yzx * r5.zxy;
		r7.xyz = r5.yzx * r6.zxy + -r7.xyz;
		r7.xyz = r7.xyz * i.tangent.www;
		r2.xyz = r5.xyz;
	} else {
		r5 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
		r3.x = dot(r4, r5);
		r3.y = dot(r0, r5);
		r3.z = dot(r1, r5);
		r5.xyz = r3.yyy * gWorld[1].xyz;
		r5.xyz = r3.xxx * gWorld[0].xyz + r5.xyz;
		r5.xyz = r3.zzz * gWorld[2].xyz + r5.xyz;
		o.texcoord7 = r5.xyz + gWorld[3].xyz;
		r0.w = dot(r4.xyz, i.normal.xyz);
		r0.x = dot(r0.xyz, i.normal.xyz);
		r0.y = dot(r1.xyz, i.normal.xyz);
		r1.xyz = r0.xxx * gWorld[1].xyz;
		r0.xzw = r0.www * gWorld[0].xyz + r1.xyz;
		r6.xyz = r0.yyy * gWorld[2].xyz + r0.xzw;
		r0.xyz = r2.zxy * r6.yzx;
		r0.xyz = r2.yzx * r6.zxy + -r0.xyz;
		r7.xyz = r0.xyz * i.tangent.www;
	}
	r0 = r3.y * gWorldViewProj[1];
	r0 = r3.x * gWorldViewProj[0] + r0;
	r0 = r3.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r1.z = 1;
	r1.x = i.color.x * globalScalars.z + -r1.z;
	r1.x = gAmbientOcclusionEffect.y * r1.x + r1.z;
	r1.y = 1 / gAmbientOcclusionEffect.y;
	r1.x = r1.y * r1.x;
	o.texcoord2.x = min(r1.x, 1);
	o.position = r0;
	o.texcoord = i.texcoord.xy;
	r6.w = r0.w;
	o.texcoord1 = r6;
	o.texcoord2.zw = i.color.zw;
	r2.w = i.position.z;
	o.texcoord4 = r2;
	r7.w = i.tangent.w;
	o.texcoord5 = r7;

	return o;
}
