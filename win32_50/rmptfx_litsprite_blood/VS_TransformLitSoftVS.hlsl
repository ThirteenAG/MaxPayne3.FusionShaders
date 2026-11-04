cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_ptx : register(b3)
{
	float4 gForcedColor : packoffset(c0);
	float4 gAspectRatio : packoffset(c1);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
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
};

cbuffer rage_SoftParticleBuffer : register(b4)
{
	float4 NearFarPlane : packoffset(c0);
};

cbuffer CacheHybrid : register(b7)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleGlobals : register(b8)
{
	float4 gBloodLightingTuners : packoffset(c0);
};

cbuffer ParticleSprite : register(b9)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gSpecularIntensity : packoffset(c1);
	float gSpecularExponent : packoffset(c1.y);
	float gExtraLights : packoffset(c1.z);
	float gAmbientAmount : packoffset(c1.w);
	float gSuperAlpha : packoffset(c2);
	float gNormalArc : packoffset(c2.y);
	float gScaleFade : packoffset(c2.z);
	float gUseShadows : packoffset(c2.w);
	float gAmbientShadow : packoffset(c3);
	float gLightIntensityClamp : packoffset(c3.y);
	float4 gTexCoordScaleOffset0 : packoffset(c4);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float3 r2;
	float4 r3;
	float4 r4;
	r0.zw = int2(0, 0);
	r1.x = (0.000000999999997 >= i.color.w) ? -1 : 0;
	r1.y = asint(1 / gScaleFade);
	r2 = -(i.position.xyz) + gViewInverse[3].xyz;
	r1.z = asint(gBiasToCamera * 0.100000001);
	r2 = r2.xyz * asfloat(r1.zzz) + i.position.xyz;
	r3 = r2.y * gWorldViewProj[1];
	r3 = r2.x * gWorldViewProj[0] + r3;
	r3 = r2.z * gWorldViewProj[2] + r3;
	r3 = r3 + gWorldViewProj[3];
	r1.z = asint(r3.w + -(NearFarPlane.x));
	r1.y = asint(saturate(asfloat(r1.y) * asfloat(r1.z)));
	r1.x = (r1.x != 0) ? 0 : r1.y;
	r1.yz = asint(asfloat(r1.xx) * i.normal.yx);
	r1.x = asint(asfloat(r1.x) * i.color.w);
	o.texcoord.w = saturate(asfloat(r1.x) * gSuperAlpha);
	r1.x = asint(sin(i.normal.z));
	r4.x = cos(i.normal.z);
	r1.xw = asint(asfloat(r1.xx) * asfloat(r1.yz));
	r0.x = asint(asfloat(r1.z) * r4.x + -(asfloat(r1.x)));
	r0.y = asint(asfloat(r1.y) * r4.x + asfloat(r1.w));
	o.sv_position = asfloat(r0) * gAspectRatio + r3;
	o.texcoord3.y = r3.w;
	r0.xyz = asint(r2.yyy * gWorldView[1].xyz);
	r0.xyz = asint(r2.xxx * gWorldView[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(r2.zzz * gWorldView[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + gWorldView[3].xyz);
	r1 = asint(-(asfloat(r0.x)) + gLightPosX);
	r3 = asfloat(r1) * -(gLightDirX);
	r1 = asint(asfloat(r1) * asfloat(r1));
	r4 = -(asfloat(r0.y)) + gLightPosY;
	r0 = asint(-(asfloat(r0.z)) + gLightPosZ);
	r3 = r4 * -(gLightDirY) + r3;
	r1 = asint(r4 * r4 + asfloat(r1));
	r1 = asint(asfloat(r0) * asfloat(r0) + asfloat(r1));
	r3 = asfloat(r0) * -(gLightDirZ) + r3;
	r4 = asfloat(r1) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1 = asint(-(asfloat(r1)) * gLightFallOff + float4(1, 1, 1, 1));
	r1 = asint(max(asfloat(r1), float4(0, 0, 0, 0)));
	r1 = asint(asfloat(r1) * asfloat(r1));
	r1 = asint(asfloat(r1) * asfloat(r1) + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001));
	r1 = asint(max(asfloat(r1), float4(0, 0, 0, 0)));
	r0 = asint(asfloat(r0) * asfloat(r1));
	r1 = asint(rsqrt(r4));
	r3 = asfloat(r1) * r3;
	r0 = asint(asfloat(r0) * asfloat(r1));
	r0 = asint(saturate(asfloat(r0) * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116)));
	r1 = asint(saturate(r3 * gLightConeScale + gLightConeOffset));
	r0 = asint(asfloat(r0) * asfloat(r1));
	r1.x = asint(dot(gLightColR, asfloat(r0)));
	r1.w = asint(dot(gLightColG, asfloat(r0)));
	r0.x = asint(dot(gLightColB, asfloat(r0)));
	r1.z = asint(asfloat(r0.x) * 1.25);
	r1.xy = asint(asfloat(r1.xw) * float2(1.25, 1.25));
	r0.xyz = asint(max(asfloat(r1.xyz), gBloodLightingTuners.xxx));
	r0.xyz = asint(min(asfloat(r0.xyz), gBloodLightingTuners.yyy));
	r0.xyz = asint(asfloat(r0.xyz) * i.color.xyz);
	r0.xyz = asint(max(asfloat(r0.xyz), float3(0, 0, 0)));
	r0.w = asint(max(-(gDirectionalLight.z), -(gLightIntensityClamp)));
	r0.w = asint(min(asfloat(r0.w), gLightIntensityClamp));
	r1.x = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(gNormalArc * asfloat(r1.x) + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gWrapScale + gWrapBias);
	r0.w = asint(asfloat(r0.w) * gDirectionalColour.x);
	r0.w = asint(asfloat(r0.w) * gDiffuse);
	r0.w = asint(max(asfloat(r0.w), gBloodLightingTuners.x));
	r0.w = asint(min(asfloat(r0.w), gBloodLightingTuners.y));
	r1.xyz = asint(asfloat(r0.www) * i.color.xyz);
	r1.xyz = asint(max(asfloat(r1.xyz), float3(0, 0, 0)));
	r1.xyz = asint(asfloat(r1.xyz) + i.color.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + asfloat(r1.xyz));
	r0.w = asint(saturate(gLightAmbientDir0.w + gLightAmbientDir1.z));
	r1.xyz = asint(asfloat(r0.www) * gLightAmbient1.xyz);
	r0.w = asint(saturate(gLightAmbientDir0.w + gLightAmbientDir0.z));
	r1.xyz = asint(asfloat(r0.www) * gLightAmbient0.xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * gBloodLightingTuners.zzz);
	r1.xyz = asint(asfloat(r1.xyz) * i.color.xyz);
	r1.xyz = asint(max(asfloat(r1.xyz), float3(0, 0, 0)));
	r0.xyz = asint(asfloat(r1.xyz) * gAmbientShadow + asfloat(r0.xyz));
	r0.w = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	r0 = asint(r2.y * gWorldView[1]);
	r0 = asint(r2.x * gWorldView[0] + asfloat(r0));
	r0 = asint(r2.z * gWorldView[2] + asfloat(r0));
	r1.xyz = asint(r2.xyz + -(gViewInverse[3].xyz));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.w = i.texcoord3.y;
	r0.x = asint(asfloat(r1.z) * globalFogParams.x);
	r0.y = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * globalFogParams.z);
	r0.z = asint(asfloat(r0.x) * -1.44269502);
	r0.z = asint(exp2(asfloat(r0.z)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(asfloat(r0.z) / asfloat(r0.x));
	r0.x = (0.0000999999975 < abs(asfloat(r0.x))) ? -1 : 0;
	r0.z = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.x = (r0.x != 0) ? r0.z : r0.y;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
