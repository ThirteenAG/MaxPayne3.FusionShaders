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
};

cbuffer PlanetAttributes : register(b4)
{
	row_major float4x4 matGrassTransform : packoffset(c0);
	float4 plantColor : packoffset(c4);
	float4 groundColor : packoffset(c5);
	float3 vecCameraPos : packoffset(c6);
	float3 vecPlayerPos : packoffset(c7);
	float4 _dimensionLOD2 : packoffset(c8);
	float2 _vecCollParams : packoffset(c9);
	float4 _vecVehCollB : packoffset(c10);
	float4 _vecVehCollM : packoffset(c11);
	float4 _vecVehCollR : packoffset(c12);
	float4 fadeAlphaDistUmTimer : packoffset(c13);
	float4 fadeAlphaLOD1Dist : packoffset(c14);
	float4 fadeAlphaLOD2Dist : packoffset(c15);
	float4 uMovementParams : packoffset(c16);
	float4 _fakedGrassNormal : packoffset(c17);
};

cbuffer grasscollide : register(b7)
{
	bool bVehCollEnabled : packoffset(c0);
};

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = asint(i.color.y * 6.28318548);
	r0.yzw = asint(globalUmScalars.zzw * uMovementParams.zzw);
	r0.xyz = asint(fadeAlphaDistUmTimer.zzz * asfloat(r0.yzw) + asfloat(r0.xxx));
	r0.xyz = asint(sin(asfloat(r0.xyz)));
	r0.w = asint(-(i.color.z) + 1);
	r0.w = asint(asfloat(r0.w) * globalUmScalars.y);
	r1.z = asfloat(r0.w) * uMovementParams.y;
	r0.w = asint(i.color.x * globalUmScalars.x);
	r1.xy = asfloat(r0.ww) * uMovementParams.xx;
	r0.xyz = asint(asfloat(r0.xyz) * r1.xyz + i.position.xyz);
	r1.xyz = asfloat(r0.yyy) * matGrassTransform[1].xyz;
	r0.xyw = asint(asfloat(r0.xxx) * matGrassTransform[0].xyz + r1.xyz);
	r0.xyz = asint(asfloat(r0.zzz) * matGrassTransform[2].xyz + asfloat(r0.xyw));
	r0.xyz = asint(asfloat(r0.xyz) + matGrassTransform[3].xyz);
	r1.xyz = asfloat(r0.xyz) + -(vecPlayerPos.xyz);
	r0.w = asint(dot(r1.xyz, r1.xyz));
	r1.xyz = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = asint(-(asfloat(r0.w)) + _vecCollParams.x);
	r0.w = asint(saturate(asfloat(r0.w) * _vecCollParams.y));
	r0.w = asint(asfloat(r0.w) * 0.5);
	r1.z = dot(r1.xyz, r1.xyz);
	r1.z = rsqrt(r1.z);
	r1.xy = r1.zz * r1.xy;
	r1.xy = asfloat(r0.ww) * r1.xy;
	r1.xy = r1.xy * i.color1.zz + asfloat(r0.xy);
	r2.xy = r1.xy + -(_vecVehCollB.xy);
	r0.w = asint(dot(_vecVehCollM.xy, r2.xy));
	r0.w = asint(saturate(asfloat(r0.w) * _vecVehCollM.w));
	r2.xy = asfloat(r0.ww) * _vecVehCollM.xy + _vecVehCollB.xy;
	r2.xy = r1.xy + -(r2.xy);
	r0.w = asint(dot(r2.xy, r2.xy));
	r2.xy = r2.xy + float2(0.00000999999975, 0.00000999999975);
	r1.w = -(asfloat(r0.w)) + _vecVehCollR.y;
	r1.w = saturate(r1.w * _vecVehCollR.z);
	r2.z = -(asfloat(r0.z)) + _vecVehCollR.w;
	r2.z = r1.w * r2.z + asfloat(r0.z);
	r1.w = r1.w * _vecVehCollR.x;
	r2.w = _vecVehCollR.x * 0.5;
	r2.w = r2.w * r2.w;
	r0.w = (asfloat(r0.w) < r2.w) ? -1 : 0;
	r2.w = _vecVehCollR.w + -0.25;
	r3.z = (r0.w != 0) ? r2.w : r2.z;
	r0.w = asint(dot(r2.xy, r2.xy));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xy = asfloat(r0.ww) * r2.xy;
	r2.xy = r1.ww * r2.xy;
	r3.xy = r2.xy * i.color1.zz + r1.xy;
	r1.z = asfloat(r0.z);
	o.texcoord2.xyz = asfloat(r0.xyz);
	r0.xyz = asint((bVehCollEnabled != 0) ? r3.xyz : r1.xyz);
	r1 = asfloat(r0.y) * gWorldViewProj[1];
	r1 = asfloat(r0.x) * gWorldViewProj[0] + r1;
	r1 = asfloat(r0.z) * gWorldViewProj[2] + r1;
	r0.xy = asint(asfloat(r0.xy) + -(vecCameraPos.xy));
	r0.x = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.x = asint(saturate(asfloat(r0.x) * fadeAlphaDistUmTimer.y + fadeAlphaDistUmTimer.x));
	o.texcoord.w = asfloat(r0.x) * plantColor.w;
	o.sv_position = r1 + gWorldViewProj[3];
	o.texcoord.xyz = plantColor.xyz;
	o.texcoord1.xyz = _fakedGrassNormal.xyz;
	o.texcoord1.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3.xyz = groundColor.xyz;
	o.texcoord3.w = i.color1.x;

	return o;
}
