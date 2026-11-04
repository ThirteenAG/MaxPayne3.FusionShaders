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

	int4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float4 r4;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r0 = r0 * int4(3, 3, 3, 3);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][0];
	r1 = gBoneMtx[r0.x / 3][0] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][0] * i.blendweight.z + r1;
	r1 = gBoneMtx[r0.w / 3][0] * i.blendweight.w + r1;
	r2.xyz = i.position.xyz;
	r2.w = 1;
	r3.x = dot(r1, r2);
	r1.x = dot(r1.xyz, i.normal.xyz);
	r4 = i.blendweight.y * gBoneMtx[r0.y / 3][1];
	r4 = gBoneMtx[r0.x / 3][1] * i.blendweight.x + r4;
	r4 = gBoneMtx[r0.z / 3][1] * i.blendweight.z + r4;
	r4 = gBoneMtx[r0.w / 3][1] * i.blendweight.w + r4;
	r3.y = dot(r4, r2);
	r1.y = dot(r4.xyz, i.normal.xyz);
	r1.yzw = r1.yyy * gWorld[1].xyz;
	r1.xyz = r1.xxx * gWorld[0].xyz + r1.yzw;
	r4 = i.blendweight.y * gBoneMtx[r0.y / 3][2];
	r4 = gBoneMtx[r0.x / 3][2] * i.blendweight.x + r4;
	r4 = gBoneMtx[r0.z / 3][2] * i.blendweight.z + r4;
	r0 = asint(gBoneMtx[r0.w / 3][2] * i.blendweight.w + r4);
	r3.z = dot(asfloat(r0), r2);
	r0.x = asint(dot(asfloat(r0.xyz), i.normal.xyz));
	o.texcoord1.xyz = asfloat(r0.xxx) * gWorld[2].xyz + r1.xyz;
	o.texcoord8.xyz = r3.xyz;
	r0.xyz = asint(r3.yyy * gWorld[1].xyz);
	r0.xyz = asint(r3.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(r3.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	o.texcoord9 = asfloat(r0.xyz) + gWorld[3].xyz;
	o.texcoord8.w = 1;
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord.zw = float2(0, 0);
	o.texcoord1.w = 1;
	r0.x = asint(dot(i.color.xy, globalDayNightEffects.zw));
	r0.x = asint(asfloat(r0.x) * globalScalars.z + -1);
	r0.x = asint(gAmbientOcclusionEffect.y * asfloat(r0.x) + 1);
	r0.y = asint(1 / gAmbientOcclusionEffect.y);
	o.texcoord2.xy = asfloat(r0.yy) * asfloat(r0.xx);
	o.texcoord2.zw = i.color.zw;
	o.texcoord7 = float3(0, 0, 0);

	return o;
}
