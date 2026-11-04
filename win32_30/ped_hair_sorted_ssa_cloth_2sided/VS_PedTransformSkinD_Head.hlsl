sampler2D clothVertexSampler : register(s2);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
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
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
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
	float3 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float3 r9;
	float3 r10;
	float3 r11;
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
	r2 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r3.x = dot(r4, r2);
	r3.y = dot(r0, r2);
	r3.z = dot(r1, r2);
	r2.xyz = r3.yyy * gWorld[1].xyz;
	r2.xyz = r3.xxx * gWorld[0].xyz + r2.xyz;
	r2.xyz = r3.zzz * gWorld[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	o.texcoord3 = -r2.xyz + gViewInverse[3].xyz;
	r0.w = dot(r4.xyz, i.tangent.xyz);
	r1.w = dot(r0.xyz, i.tangent.xyz);
	r2.w = dot(r1.xyz, i.tangent.xyz);
	r5 = r1.www * gWorld[1].xyz;
	r5 = r0.www * gWorld[0].xyz + r5.xyz;
	r5 = r2.www * gWorld[2].xyz + r5.xyz;
	if (0.9960708 < i.blendindices.x) {
		r6.xyz = i.blendindices.yzw * 255.00195 + 0.5;
		r6.xyz = r6.xyz * invVertexBufferSize.xxx;
		r6.w = 0;
		r7 = tex2Dlod(clothVertexSampler, r6.xwww);
		r8 = tex2Dlod(clothVertexSampler, r6.ywww);
		r6 = tex2Dlod(clothVertexSampler, r6.zwww);
		r9.x = dot(gWorld[0].xyz, r7.xyz);
		r9.y = dot(gWorld[1].xyz, r7.xyz);
		r9.z = dot(gWorld[2].xyz, r7.xyz);
		r7.x = dot(gWorld[0].xyz, r8.xyz);
		r7.y = dot(gWorld[1].xyz, r8.xyz);
		r7.z = dot(gWorld[2].xyz, r8.xyz);
		r8.x = dot(gWorld[0].xyz, r6.xyz);
		r8.y = dot(gWorld[1].xyz, r6.xyz);
		r8.z = dot(gWorld[2].xyz, r6.xyz);
		r6.xyz = -r7.zxy + r9.zxy;
		r10 = -r7.yzx + r8.yzx;
		r11 = r6.xyz * r10.xyz;
		r6.xyz = r6.zxy * r10.yzx + -r11.xyz;
		r10 = normalize(r6.xyz);
		r6.xyz = r7.xyz * i.blendweight.yyy;
		r6.xyz = i.blendweight.zzz * r9.xyz + r6.xyz;
		r6.xyz = i.blendweight.xxx * r8.xyz + r6.xyz;
		r0.w = -0.5 + i.blendweight.w;
		r0.w = r0.w * 0.1;
		r3.xyz = r0.www * r10.xyz + r6.xyz;
		r6.xyz = r3.yyy * gWorld[1].xyz;
		r6.xyz = r3.xxx * gWorld[0].xyz + r6.xyz;
		r6.xyz = r3.zzz * gWorld[2].xyz + r6.xyz;
		o.texcoord7 = r6.xyz + gWorld[3].xyz;
		r6.xyz = -r10.yyy * gWorld[1].xyz;
		r6.xyz = -r10.xxx * gWorld[0].xyz + r6.xyz;
		r6.xyz = -r10.zzz * gWorld[2].xyz + r6.xyz;
		r7.xyz = normalize(r6.xyz);
		r6.xyz = normalize(r5.xyz);
		r8.xyz = r7.yzx * r6.zxy;
		r8.xyz = r6.yzx * r7.zxy + -r8.xyz;
		r8.xyz = r8.xyz * i.tangent.www;
		o.texcoord4 = r6.xyz;
	} else {
		r0.w = dot(r4.xyz, i.normal.xyz);
		r0.x = dot(r0.xyz, i.normal.xyz);
		r0.y = dot(r1.xyz, i.normal.xyz);
		r1.xyz = r0.xxx * gWorld[1].xyz;
		r0.xzw = r0.www * gWorld[0].xyz + r1.xyz;
		r7.xyz = r0.yyy * gWorld[2].xyz + r0.xzw;
		r0.xyz = r5.zxy * r7.yzx;
		r0.xyz = r5.yzx * r7.zxy + -r0.xyz;
		r8.xyz = r0.xyz * i.tangent.www;
		o.texcoord4 = r5.xyz;
		o.texcoord7 = r2.xyz;
	}
	r0 = r3.y * gWorldViewProj[1];
	r0 = r3.x * gWorldViewProj[0] + r0;
	r0 = r3.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.texcoord2.y = globalScalars2.w * i.color.y;
	o.position = r0;
	o.texcoord = i.texcoord.xy;
	r7.w = r0.w;
	o.texcoord1 = r7;
	o.texcoord2.xzw = i.color.xzw;
	r8.w = i.tangent.w;
	o.texcoord5 = r8;

	return o;
}
