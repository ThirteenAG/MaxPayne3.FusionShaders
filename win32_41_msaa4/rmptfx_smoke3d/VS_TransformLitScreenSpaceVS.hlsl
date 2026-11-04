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

cbuffer CacheHybrid : register(b1)
{
	float HybridAdd : packoffset(c0);
};

cbuffer CustomVertexVariables : register(b4)
{
	float HybridAddRatio : packoffset(c0);
	float HDRIntensityMultiplier : packoffset(c0.y);
	float4 gActiveUnit : packoffset(c1);
};

cbuffer ParticleSmoke : register(b7)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gExtraLights : packoffset(c1);
	float gAmbientAmount : packoffset(c1.y);
	float gSuperAlpha : packoffset(c1.z);
	float gNormalArc : packoffset(c1.w);
	float gScaleFade : packoffset(c2);
	float gUseShadows : packoffset(c2.y);
	float gAmbientShadow : packoffset(c2.z);
	float gLightIntensityClamp : packoffset(c2.w);
	float4 gTextureAngleRads : packoffset(c3);
	float4 gInterpolationFactor : packoffset(c4);
	float4 gPositionOffset : packoffset(c5);
	float4 gPositionScale : packoffset(c6);
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
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
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
	r1 = gInterpolationFactor + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0 = asint(asfloat(r0) * r1);
	r0 = asint(exp2(asfloat(r0)));
	r0 = asint(asfloat(r0) * gActiveUnit + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0), asfloat(r0));
	r1.x = rsqrt(r1.x);
	r0 = asint(asfloat(r0) * r1.x);
	r1.x = dot(asfloat(r0), gPositionScale);
	o.texcoord6 = asfloat(r0);
	r0.xy = asint(r1.xx * i.normal.yx);
	r1.x = sin(i.normal.z);
	r2.x = cos(i.normal.z);
	r0.zw = asint(asfloat(r0.xy) * r1.xx);
	r1.x = asfloat(r0.y) * r2.x + -(asfloat(r0.z));
	r1.y = asfloat(r0.x) * r2.x + asfloat(r0.w);
	r1.z = 0;
	r0.xy = asint(i.position.xy);
	r0.z = 0;
	r2.xyz = r1.xyz * gAspectRatio.xyz + asfloat(r0.xyz);
	r1.xyz = r1.xyz * gAspectRatio.xyz;
	r0.w = (i.normal.w == 1) ? -1 : 0;
	o.sv_position.xyz = (r0.www != 0) ? r2.xyz : asfloat(r0.xyz);
	r0.xyz = asint((r0.www != 0) ? r1.xyz : i.position.xyz);
	o.sv_position.w = 1;
	r1.xy = gAspectRatio.xy;
	r1.z = 1;
	r0.xyz = asint(asfloat(r0.xyz) / r1.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r1.xyz = i.position.yyy * gWorldView[1].xyz;
	r1.xyz = i.position.xxx * gWorldView[0].xyz + r1.xyz;
	r1.xyz = i.position.zzz * gWorldView[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gWorldView[3].xyz;
	r2 = -(r1.x) + gLightPosX;
	r3 = asfloat(r0.x) * r2;
	r4 = -(r1.y) + gLightPosY;
	r1 = -(r1.z) + gLightPosZ;
	r3 = r4 * asfloat(r0.y) + r3;
	r3 = r1 * asfloat(r0.z) + r3;
	r5 = r2 * r2;
	r2 = r2 * -(gLightDirX);
	r2 = r4 * -(gLightDirY) + r2;
	r4 = r4 * r4 + r5;
	r4 = r1 * r1 + r4;
	r2 = r1 * -(gLightDirZ) + r2;
	r5 = -(r4) * gLightFallOff + float4(1, 1, 1, 1);
	r4 = r4 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r4 = rsqrt(r4);
	r5 = max(r5, float4(0, 0, 0, 0));
	r5 = r5 * r5;
	r5 = r5 * r5 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r5 = max(r5, float4(0, 0, 0, 0));
	r5 = r5 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r3 = r3 * r5;
	r1 = r1 * r5;
	r1 = saturate(r4 * r1);
	r3 = saturate(r4 * r3);
	r2 = r2 * r4;
	r2 = saturate(r2 * gLightConeScale + gLightConeOffset);
	r3 = r3 * r2;
	r1 = r1 * r2;
	r0.z = asint(dot(gLightColR, r3));
	r2.x = dot(gLightColR, r1);
	r2.x = r2.x * 0.25 + asfloat(r0.z);
	r0.z = asint(dot(gLightColG, r1));
	r1.x = dot(gLightColB, r1);
	r1.y = dot(gLightColG, r3);
	r1.z = dot(gLightColB, r3);
	r2.z = r1.x * 0.25 + r1.z;
	r2.y = asfloat(r0.z) * 0.25 + r1.y;
	r1.xyz = r2.xyz * i.color.xyz;
	r1.xyz = r1.xyz * gExtraLights;
	r1.xyz = max(r1.xyz, float3(0, 0, 0));
	r0.z = asint(saturate(-(gDirectionalLight.z)));
	r0.w = asint(asfloat(r0.z) * 0.375);
	r0.x = asint(dot(asfloat(r0.xyw), -(gDirectionalLight.xyz)));
	r0.y = asint(saturate(asfloat(r0.y) * -0.5 + 0.5));
	r0.x = asint(max(asfloat(r0.x), -(gLightIntensityClamp)));
	r0.x = asint(min(asfloat(r0.x), gLightIntensityClamp));
	r0.z = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(gNormalArc * asfloat(r0.z) + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * gWrapScale + gWrapBias);
	r0.x = asint(asfloat(r0.x) * gDirectionalColour.x);
	r0.x = asint(asfloat(r0.x) * gDiffuse);
	r0.xzw = asint(asfloat(r0.xxx) * i.color.xyz);
	r0.xzw = asint(max(asfloat(r0.xzw), float3(0, 0, 0)));
	r0.xzw = asint(asfloat(r0.xzw) + i.color.xyz);
	r0.xzw = asint(r1.xyz + asfloat(r0.xzw));
	r1.xyz = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r1.xyz = asfloat(r0.yyy) * r1.xyz + gLightAmbient0.xyz;
	r1.xyz = r1.xyz * gAmbientOcclusionEffect.yyy;
	r1.xyz = r1.xyz * gAmbientAmount;
	r1.xyz = r1.xyz / gAmbientOcclusionEffect.yyy;
	r1.xyz = r1.xyz * i.color.xyz;
	r1.xyz = max(r1.xyz, float3(0, 0, 0));
	r0.xyz = asint(r1.xyz * gAmbientShadow + asfloat(r0.xzw));
	r0.w = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r0 = asint(i.position.y * gWorldView[1]);
	r0 = asint(i.position.x * gWorldView[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldView[2] + asfloat(r0));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.y = 0;
	o.texcoord3.w = i.texcoord3.y;
	r0.xyz = asint(i.position.xyz + -(gViewInverse[3].xyz));
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
