cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float displacementScale : packoffset(c0.y);
	float4 matMaterialColorScale : packoffset(c1);
	float4 gBloodData : packoffset(c2);
};

cbuffer BloodHitData : register(b7)
{
	float4 gBloodHeadHits[4] : packoffset(c0);
	float4 gBloodHeadCentreMass : packoffset(c4);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord7 : TEXCOORD7;
	float3 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	float3 r3;
	float4 r4;
	r0.xyz = -(i.position.xyz) + gBloodHeadHits[0].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = -(r0.x) + 0.0500000007;
	r0.x = r0.x * 0.239999995;
	r0.x = max(r0.x, 0);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[1].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[2].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[3].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadCentreMass.xyz;
	r0.yzw = r0.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r0.yzw, r0.yzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.yzw = r0.yzw * asfloat(r1.xxx);
	r0.xyz = r0.xxx * r0.yzw;
	r0.xyz = r0.xyz * gBloodData.xxx + i.position.xyz;
	r1 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r1 = (int4)asfloat(r1);
	r1 = r1 * int4(3, 3, 3, 3);
	r2 = i.blendweight.y * gBoneMtx[r1.y / 3][0];
	r2 = gBoneMtx[r1.x / 3][0] * i.blendweight.x + r2;
	r2 = gBoneMtx[r1.z / 3][0] * i.blendweight.z + r2;
	r2 = gBoneMtx[r1.w / 3][0] * i.blendweight.w + r2;
	r0.w = 1;
	r3.x = dot(r2, r0);
	r2.x = dot(r2.xyz, i.normal.xyz);
	r4 = i.blendweight.y * gBoneMtx[r1.y / 3][1];
	r4 = gBoneMtx[r1.x / 3][1] * i.blendweight.x + r4;
	r4 = gBoneMtx[r1.z / 3][1] * i.blendweight.z + r4;
	r4 = gBoneMtx[r1.w / 3][1] * i.blendweight.w + r4;
	r3.y = dot(r4, r0);
	r2.y = dot(r4.xyz, i.normal.xyz);
	r2.yzw = r2.yyy * gWorld[1].xyz;
	r2.xyz = r2.xxx * gWorld[0].xyz + r2.yzw;
	r4 = i.blendweight.y * gBoneMtx[r1.y / 3][2];
	r4 = gBoneMtx[r1.x / 3][2] * i.blendweight.x + r4;
	r4 = gBoneMtx[r1.z / 3][2] * i.blendweight.z + r4;
	r1 = asint(gBoneMtx[r1.w / 3][2] * i.blendweight.w + r4);
	r3.z = dot(asfloat(r1), r0);
	r0.x = dot(asfloat(r1.xyz), i.normal.xyz);
	o.texcoord1.xyz = r0.xxx * gWorld[2].xyz + r2.xyz;
	o.texcoord8.xyz = r3.xyz;
	r0.xyz = r3.yyy * gWorld[1].xyz;
	r0.xyz = r3.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = r3.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord9 = r0.xyz + gWorld[3].xyz;
	o.texcoord8.w = 1;
	o.texcoord = i.texcoord;
	o.texcoord1.w = 1;
	r0.x = dot(i.color.xy, globalDayNightEffects.zw);
	r0.x = r0.x * globalScalars.z + -1;
	r0.x = gAmbientOcclusionEffect.y * r0.x + 1;
	r0.y = 1 / gAmbientOcclusionEffect.y;
	o.texcoord2.xy = r0.yy * r0.xx;
	o.texcoord2.zw = i.color.zw;
	o.texcoord7 = float3(0, 0, 0);

	return o;
}
