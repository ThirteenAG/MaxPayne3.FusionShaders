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

cbuffer UV_Anim : register(b4)
{
	float3 globalAnimUV0 : packoffset(c0);
	float3 globalAnimUV1 : packoffset(c1);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r0 = r0 * int4(3, 3, 3, 3);
	r1 = i.blendweight.y * gBoneMtx[r0.y / 3][1];
	r1 = gBoneMtx[r0.x / 3][1] * i.blendweight.x + r1;
	r1 = gBoneMtx[r0.z / 3][1] * i.blendweight.z + r1;
	r1 = gBoneMtx[r0.w / 3][1] * i.blendweight.w + r1;
	r2.xyz = i.position.xyz;
	r2.w = 1;
	r1.x = dot(r1, r2);
	r3 = r1.x * gWorldViewProj[1];
	r1.xyz = r1.xxx * gWorld[1].xyz;
	r4 = i.blendweight.y * gBoneMtx[r0.y / 3][0];
	r4 = gBoneMtx[r0.x / 3][0] * i.blendweight.x + r4;
	r4 = gBoneMtx[r0.z / 3][0] * i.blendweight.z + r4;
	r4 = gBoneMtx[r0.w / 3][0] * i.blendweight.w + r4;
	r1.w = dot(r4, r2);
	r3 = r1.w * gWorldViewProj[0] + r3;
	r1.xyz = r1.www * gWorld[0].xyz + r1.xyz;
	r4 = i.blendweight.y * gBoneMtx[r0.y / 3][2];
	r4 = gBoneMtx[r0.x / 3][2] * i.blendweight.x + r4;
	r4 = gBoneMtx[r0.z / 3][2] * i.blendweight.z + r4;
	r0 = asint(gBoneMtx[r0.w / 3][2] * i.blendweight.w + r4);
	r0.x = asint(dot(asfloat(r0), r2));
	r2 = asfloat(r0.x) * gWorldViewProj[2] + r3;
	r0.xyz = asint(asfloat(r0.xxx) * gWorld[2].xyz + r1.xyz);
	o.texcoord6.xyz = asfloat(r0.xyz) + gWorld[3].xyz;
	o.sv_position = r2 + gWorldViewProj[3];
	r0.x = asint(dot(i.color.xy, globalDayNightEffects.zw));
	r0.x = asint(asfloat(r0.x) * globalScalars.z + -1);
	r0.x = asint(gAmbientOcclusionEffect.x * asfloat(r0.x) + 1);
	o.color.xy = asfloat(r0.xx) * gAmbientOcclusionEffect.yy;
	o.color.zw = i.color.zw;
	r0.xy = asint(i.texcoord.xy);
	r0.z = 1065353216;
	o.texcoord.x = dot(globalAnimUV0.xyz, asfloat(r0.xyz));
	o.texcoord.y = dot(globalAnimUV1.xyz, asfloat(r0.xyz));
	o.texcoord6.w = 1;

	return o;
}
