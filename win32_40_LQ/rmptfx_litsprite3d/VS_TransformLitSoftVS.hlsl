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

cbuffer CacheHybrid : register(b4)
{
	float HybridAdd : packoffset(c0);
};

cbuffer CustomVertexVariables : register(b7)
{
	float HybridAddRatio : packoffset(c0);
	float HDRIntensityMultiplier : packoffset(c0.y);
	float4 gActiveUnit : packoffset(c1);
};

cbuffer ParticleSprite : register(b8)
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
	float4 gTextureAngleRads : packoffset(c4);
	float4 gInterpolationFactor : packoffset(c5);
	float4 gPositionOffset : packoffset(c6);
	float4 gPositionScale : packoffset(c7);
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
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = asint(abs(gViewInverse[2].z) * -0.0187292993 + 0.0742610022);
	r0.x = asint(asfloat(r0.x) * abs(gViewInverse[2].z) + -0.212114394);
	r0.x = asint(asfloat(r0.x) * abs(gViewInverse[2].z) + 1.57072878);
	r0.y = asint(-(abs(gViewInverse[2].z)) + 1);
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.z = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.z = asint(asfloat(r0.z) * -2 + 3.14159274);
	r0.w = (gViewInverse[2].z < -(gViewInverse[2].z)) ? -1 : 0;
	r0.z = r0.w & r0.z;
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y) + asfloat(r0.z));
	r0.x = asint(-(asfloat(r0.x)) + 1.57079637);
	r0 = asint(abs(asfloat(r0.x)) + -(gTextureAngleRads));
	r0 = asint(cos(asfloat(r0)));
	r0 = asint(abs(asfloat(r0)) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0 = asint(log2(asfloat(r0)));
	r1 = asint(gInterpolationFactor + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0 = asint(asfloat(r0) * asfloat(r1));
	r0 = asint(exp2(asfloat(r0)));
	r0 = asint(asfloat(r0) * gActiveUnit + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = asint(dot(asfloat(r0), asfloat(r0)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0 = asint(asfloat(r0) * asfloat(r1.x));
	r1.x = asint(dot(asfloat(r0), gPositionScale));
	r1.xy = asint(asfloat(r1.xx) * i.normal.yx);
	r2.x = sin(i.normal.z);
	r3.x = cos(i.normal.z);
	r1.zw = asint(asfloat(r1.xy) * r2.xx);
	r2.x = asfloat(r1.y) * r3.x + -(asfloat(r1.z));
	r2.y = asfloat(r1.x) * r3.x + asfloat(r1.w);
	r1.z = asint(dot(asfloat(r0), gPositionOffset));
	o.texcoord6 = asfloat(r0);
	r1.xy = int2(0, 0);
	r0.xyz = asint(-(i.position.xyz) + gViewInverse[3].xyz);
	r0.w = asint(gBiasToCamera * 0.100000001);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + i.position.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + asfloat(r0.xyz));
	r3 = asfloat(r1.y) * gWorldViewProj[1];
	r3 = asfloat(r1.x) * gWorldViewProj[0] + r3;
	r1 = asint(asfloat(r1.z) * gWorldViewProj[2] + r3);
	r1 = asint(asfloat(r1) + gWorldViewProj[3]);
	r2.zw = float2(0, 0);
	o.sv_position = r2 * gAspectRatio + asfloat(r1);
	r1.xyz = asint(asfloat(r0.yyy) * gWorldView[1].xyz);
	r1.xyz = asint(asfloat(r0.xxx) * gWorldView[0].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r0.zzz) * gWorldView[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + gWorldView[3].xyz);
	r2 = -(asfloat(r1.x)) + gLightPosX;
	r3 = r2 * -(gLightDirX);
	r2 = r2 * r2;
	r4 = -(asfloat(r1.y)) + gLightPosY;
	r1 = asint(-(asfloat(r1.z)) + gLightPosZ);
	r3 = r4 * -(gLightDirY) + r3;
	r2 = r4 * r4 + r2;
	r2 = asfloat(r1) * asfloat(r1) + r2;
	r3 = asfloat(r1) * -(gLightDirZ) + r3;
	r4 = r2 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2 = -(r2) * gLightFallOff + float4(1, 1, 1, 1);
	r2 = max(r2, float4(0, 0, 0, 0));
	r2 = r2 * r2;
	r2 = r2 * r2 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r2 = max(r2, float4(0, 0, 0, 0));
	r1 = asint(asfloat(r1) * r2);
	r2 = rsqrt(r4);
	r3 = r2 * r3;
	r1 = asint(asfloat(r1) * r2);
	r1 = asint(saturate(asfloat(r1) * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116)));
	r2 = saturate(r3 * gLightConeScale + gLightConeOffset);
	r1 = asint(asfloat(r1) * r2);
	r0.w = asint(dot(gLightColR, asfloat(r1)));
	r2.x = asfloat(r0.w) * i.color.x;
	r0.w = asint(dot(gLightColG, asfloat(r1)));
	r1.x = asint(dot(gLightColB, asfloat(r1)));
	r2.z = asfloat(r1.x) * i.color.z;
	r2.y = asfloat(r0.w) * i.color.y;
	r1.xyz = asint(r2.xyz * float3(1.25, 1.25, 1.25));
	r1.xyz = asint(max(asfloat(r1.xyz), float3(0, 0, 0)));
	r0.w = asint(max(-(gDirectionalLight.z), -(gLightIntensityClamp)));
	r0.w = asint(min(asfloat(r0.w), gLightIntensityClamp));
	r1.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(gNormalArc * asfloat(r1.w) + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gWrapScale + gWrapBias);
	r0.w = asint(asfloat(r0.w) * gDirectionalColour.x);
	r0.w = asint(asfloat(r0.w) * gDiffuse);
	r2.xyz = asfloat(r0.www) * i.color.xyz;
	r2.xyz = max(r2.xyz, float3(0, 0, 0));
	r2.xyz = r2.xyz + i.color.xyz;
	r1.xyz = asint(asfloat(r1.xyz) + r2.xyz);
	r0.w = asint(saturate(gWorldView[2].z * -0.5 + 0.5));
	r2.xyz = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r2.xyz = asfloat(r0.www) * r2.xyz + gLightAmbient0.xyz;
	r2.xyz = r2.xyz * gAmbientOcclusionEffect.yyy;
	r2.xyz = r2.xyz * gAmbientAmount;
	r2.xyz = r2.xyz / gAmbientOcclusionEffect.yyy;
	r2.xyz = r2.xyz * i.color.xyz;
	r2.xyz = max(r2.xyz, float3(0, 0, 0));
	r1.xyz = asint(r2.xyz * gAmbientShadow + asfloat(r1.xyz));
	r0.w = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.www) * asfloat(r1.xyz);
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r1 = asint(asfloat(r0.y) * gWorldView[1]);
	r1 = asint(asfloat(r0.x) * gWorldView[0] + asfloat(r1));
	r1 = asint(asfloat(r0.z) * gWorldView[2] + asfloat(r1));
	r0.xyz = asint(asfloat(r0.xyz) + -(gViewInverse[3].xyz));
	o.texcoord7 = asfloat(r1) + gWorldView[3];
	o.texcoord1 = i.texcoord;
	r0.w = asint(-(i.texcoord3.x) + 1);
	r1.x = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r1.x != 0) ? asfloat(r0.w) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.y = 0;
	o.texcoord3.w = i.texcoord3.y;
	r0.w = asint(asfloat(r0.z) * globalFogParams.x);
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * globalFogParams.z);
	r0.y = asint(asfloat(r0.w) * -1.44269502);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(asfloat(r0.y) / asfloat(r0.w));
	r0.z = (0.0000999999975 < abs(asfloat(r0.w))) ? -1 : 0;
	r0.y = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = (r0.z != 0) ? r0.y : r0.x;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
