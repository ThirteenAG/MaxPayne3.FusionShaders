cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
	float4 gLightPointColR : packoffset(c16);
	float4 gLightPointColG : packoffset(c17);
	float4 gLightPointColB : packoffset(c18);
	float4 gLightPointPosX : packoffset(c19);
	float4 gLightPointPosY : packoffset(c20);
	float4 gLightPointPosZ : packoffset(c21);
	float4 gLightDir2X : packoffset(c22);
	float4 gLightDir2Y : packoffset(c23);
	float4 gLightDir2Z : packoffset(c24);
	float4 gLightConeScale2 : packoffset(c25);
	float4 gLightConeOffset2 : packoffset(c26);
	float4 gLightPointFallOff : packoffset(c27);
	float4 gDistFadeParams : packoffset(c28);
	float4 gAdrenoFXVars : packoffset(c29);
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
};

struct VS_IN
{
	float3 position : POSITION;
	float3 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float3 r1;
	r0 = asint(i.position.y * gWorldViewProj[1]);
	r0 = asint(i.position.x * gWorldViewProj[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldViewProj[2] + asfloat(r0));
	r0 = asint(asfloat(r0) + gWorldViewProj[3]);
	o.sv_position = asfloat(r0);
	r0.x = asint(saturate(-(asfloat(r0.w)) * gDepthFxParams.z + gDepthFxParams.w));
	r0.y = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(asfloat(r0.y) * gDepthFxParams.y + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) + -0.999989986);
	r0.yzw = asint(i.color.xyz * globalScalars.yyy);
	r1.x = dot(asfloat(r0.yzw), float3(0.212500006, 0.715399981, 0.0720999986));
	r1.x = r1.x + 0.00000999999975;
	r1.x = abs(r1.x) + 0.00000999999975;
	r1.x = log2(r1.x);
	r0.x = asint(asfloat(r0.x) * r1.x);
	r0.x = asint(exp2(asfloat(r0.x)));
	r0.xyz = asint(asfloat(r0.yzw) * asfloat(r0.xxx) + -(globalFogColorN.xyz));
	r1 = i.position.yyy * gWorld[1].xyz;
	r1 = i.position.xxx * gWorld[0].xyz + r1.xyz;
	r1 = i.position.zzz * gWorld[2].xyz + r1.xyz;
	r1 = r1.xyz + gWorld[3].xyz;
	r1 = r1.xyz + -(gViewInverse[3].xyz);
	r0.w = asint(r1.z * globalFogParams.x);
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = sqrt(r1.x);
	r1.x = r1.x * globalFogParams.z;
	r1.y = asfloat(r0.w) * -1.44269502;
	r1.y = exp2(r1.y);
	r1.y = -(r1.y) + 1;
	r1.y = r1.y / asfloat(r0.w);
	r0.w = (0.0000999999975 < abs(asfloat(r0.w))) ? -1 : 0;
	r1.y = r1.y * r1.x;
	r0.w = asint((r0.w != 0) ? r1.y : r1.x);
	r0.w = asint(asfloat(r0.w) * -(globalFogParams.y));
	r0.w = asint(asfloat(r0.w) * 1.44269502);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(min(asfloat(r0.w), 1));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz) + globalFogColorN.xyz);
	r0.w = asint(dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986)));
	r0.xyz = asint(-(asfloat(r0.www)) + asfloat(r0.xyz));
	r1.x = gAdrenoFXVars.x * deSatContrastGamma.x;
	o.texcoord = r1.xxx * asfloat(r0.xyz) + asfloat(r0.www);

	return o;
}
