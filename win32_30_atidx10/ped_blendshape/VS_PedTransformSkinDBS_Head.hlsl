sampler2D BloodSamplerVS : register(s1);
float4 gAmbientOcclusionEffect : register(c63);
float4 gBloodData : register(c206);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
	float4 position1 : POSITION1;
	float4 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	int4 a0;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0 = float4(1, 1, 0, 0) * i.texcoord.zwzz;
	r0 = tex2Dlod(BloodSamplerVS, r0);
	r0.xyw = i.texcoord1.xyz * float3(1, -1, 1) + float3(0, 1, 0);
	r0.xyz = r0.zzz * r0.xyw;
	r1.xyz = i.position.xyz;
	r1.xyz = r1.xyz + i.position1.xyz;
	r0.xyz = r0.xyz * gBloodData.xxx + r1.xyz;
	r1 = 765.00586 * i.blendindices;
	a0 = r1.yxzw;
	r2 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r2 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r2;
	r1 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r2;
	r1 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r1;
	r0.w = 1;
	r1.w = dot(r1, r0);
	r2.xyz = r1.www * gWorld[1].xyz;
	r3 = r1.w * gWorldViewProj[1];
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r5 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r5 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r5;
	r4 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r4;
	r4 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r4;
	r5 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r5;
	r5 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r5;
	r4 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r4;
	r1.w = dot(r4, r0);
	r0.x = dot(r5, r0);
	r0.yzw = r1.www * gWorld[0].xyz + r2.xyz;
	r2 = r1.w * gWorldViewProj[0] + r3;
	r2 = r0.x * gWorldViewProj[2] + r2;
	r0.xyz = r0.xxx * gWorld[2].xyz + r0.yzw;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r2 = r2 + gWorldViewProj[3];
	r3.xyz = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord7 = r0.xyz;
	r0 = i.tangent;
	r0 = r0 + i.tangent1;
	r1.w = dot(r1.xyz, r0.xyz);
	r6 = r1.www * gWorld[1].xyz;
	r1.w = dot(r4.xyz, r0.xyz);
	r6 = r1.www * gWorld[0].xyz + r6.xyz;
	r0.x = dot(r5.xyz, r0.xyz);
	r0.xyz = r0.xxx * gWorld[2].xyz + r6.xyz;
	o.texcoord6.x = dot(r0.xyz, r3.xyz);
	r6 = i.normal.xyz;
	r6 = r6.xyz + i.normal1.xyz;
	r1.x = dot(r1.xyz, r6.xyz);
	r1.xyz = r1.xxx * gWorld[1].xyz;
	r1.w = dot(r4.xyz, r6.xyz);
	r3.w = dot(r5.xyz, r6.xyz);
	r1.xyz = r1.www * gWorld[0].xyz + r1.xyz;
	r1.xyz = r3.www * gWorld[2].xyz + r1.xyz;
	r4.xyz = r0.zxy * r1.yzx;
	r4.xyz = r0.yzx * r1.zxy + -r4.xyz;
	o.texcoord4 = r0.xyz;
	r0.xyz = r0.www * r4.xyz;
	o.texcoord6.y = dot(r0.xyz, r3.xyz);
	o.texcoord5 = r0;
	o.texcoord6.z = dot(r1.xyz, r3.xyz);
	o.texcoord3 = r3.xyz;
	o.texcoord1.xyz = r1.xyz;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r0.xz = float2(1, -1);
	r0.y = i.color.x * globalScalars.z + r0.z;
	r0.x = gAmbientOcclusionEffect.y * r0.y + r0.x;
	r0.y = 1 / gAmbientOcclusionEffect.y;
	r0.x = r0.y * r0.x;
	o.texcoord2.x = min(r0.x, 1);
	o.position = r2;
	o.texcoord1.w = r2.w;
	o.texcoord = i.texcoord;
	o.texcoord2.zw = i.color.zw;

	return o;
}
