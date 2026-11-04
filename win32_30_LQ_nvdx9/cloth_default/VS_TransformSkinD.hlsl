float4 deSatContrastGamma : register(c46);
float4 gAmbientOcclusionEffect : register(c63);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float3 globalAnimUV0 : register(c196);
float3 globalAnimUV1 : register(c197);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 a0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0 = 765.00586 * i.blendindices;
	a0 = r0.yxzw;
	r1 = i.blendweight.y * gBoneMtx[a0.x / 3][1];
	r1 = gBoneMtx[a0.y / 3][1] * i.blendweight.x + r1;
	r0 = gBoneMtx[a0.z / 3][1] * i.blendweight.z + r1;
	r0 = gBoneMtx[a0.w / 3][1] * i.blendweight.w + r0;
	r1 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	r0.w = dot(r0, r1);
	r0.x = dot(r0.xyz, i.normal.xyz);
	r0.xyz = r0.xxx * gWorld[1].xyz;
	r2.xyz = r0.www * gWorld[1].xyz;
	r3 = r0.w * gWorldViewProj[1];
	r4 = i.blendweight.y * gBoneMtx[a0.x / 3][0];
	r5 = i.blendweight.y * gBoneMtx[a0.x / 3][2];
	r5 = gBoneMtx[a0.y / 3][2] * i.blendweight.x + r5;
	r4 = gBoneMtx[a0.y / 3][0] * i.blendweight.x + r4;
	r4 = gBoneMtx[a0.z / 3][0] * i.blendweight.z + r4;
	r5 = gBoneMtx[a0.z / 3][2] * i.blendweight.z + r5;
	r5 = gBoneMtx[a0.w / 3][2] * i.blendweight.w + r5;
	r4 = gBoneMtx[a0.w / 3][0] * i.blendweight.w + r4;
	r0.w = dot(r4, r1);
	r2.w = dot(r4.xyz, i.normal.xyz);
	r0.xyz = r2.www * gWorld[0].xyz + r0.xyz;
	r1.x = dot(r5, r1);
	r1.y = dot(r5.xyz, i.normal.xyz);
	r0.xyz = r1.yyy * gWorld[2].xyz + r0.xyz;
	o.texcoord1.xyz = r0.xyz * deSatContrastGamma.yyy;
	r0.xyz = r0.www * gWorld[0].xyz + r2.xyz;
	r2 = r0.w * gWorldViewProj[0] + r3;
	r2 = r1.x * gWorldViewProj[2] + r2;
	r0.xyz = r1.xxx * gWorld[2].xyz + r0.xyz;
	o.texcoord6.xyz = r0.xyz + gWorld[3].xyz;
	r0 = r2 + gWorldViewProj[3];
	r1.xyz = i.texcoord.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord.x = dot(globalAnimUV0.xyz, r1.xyz);
	o.texcoord.y = dot(globalAnimUV1.xyz, r1.xyz);
	r1.xy = globalDayNightEffects.zw * i.color.xy;
	r1.x = r1.y + r1.x;
	r1.yw = float2(1, -1);
	r1.x = r1.x * globalScalars.z + r1.w;
	r1.x = gAmbientOcclusionEffect.x * r1.x + r1.y;
	o.color.xy = r1.xx * gAmbientOcclusionEffect.yy;
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.color.zw = i.color.zw;
	o.texcoord6.w = 1;

	return o;
}
