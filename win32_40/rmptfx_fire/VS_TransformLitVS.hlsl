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

cbuffer rage_SoftParticleBuffer : register(b1)
{
	float4 NearFarPlane : packoffset(c0);
};

cbuffer CacheHybrid : register(b4)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleFire : register(b7)
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
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.x = (0.000000999999997 >= i.color.w) ? -1 : 0;
	r0.y = asint(1 / gScaleFade);
	r1.xyz = -(i.position.xyz) + gViewInverse[3].xyz;
	r0.z = asint(gBiasToCamera * 0.100000001);
	r1.xyz = r1.xyz * asfloat(r0.zzz) + i.position.xyz;
	r2 = r1.y * gWorldViewProj[1];
	r2 = r1.x * gWorldViewProj[0] + r2;
	r2 = r1.z * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	r0.z = asint(r2.w + -(NearFarPlane.x));
	r0.y = asint(saturate(asfloat(r0.y) * asfloat(r0.z)));
	r0.x = (r0.x != 0) ? 0 : r0.y;
	r0.yz = asint(asfloat(r0.xx) * i.normal.yx);
	r0.x = asint(asfloat(r0.x) * i.color.w);
	o.texcoord.w = saturate(asfloat(r0.x) * gSuperAlpha);
	r0.x = asint(sin(i.normal.z));
	r3.x = cos(i.normal.z);
	r0.xw = asint(asfloat(r0.xx) * asfloat(r0.yz));
	r4.x = asfloat(r0.z) * r3.x + -(asfloat(r0.x));
	r4.y = asfloat(r0.y) * r3.x + asfloat(r0.w);
	r4.zw = float2(0, 0);
	o.sv_position = r4 * gAspectRatio + r2;
	r0.xyz = asint(r4.xyz * gAspectRatio.xyz);
	r2.xy = gAspectRatio.xy;
	r2.z = 1;
	r0.xyz = asint(asfloat(r0.xyz) / r2.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2.xyz = r1.yyy * gWorldView[1].xyz;
	r2.xyz = r1.xxx * gWorldView[0].xyz + r2.xyz;
	r2.xyz = r1.zzz * gWorldView[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gWorldView[3].xyz;
	r3 = -(r2.x) + gLightPosX;
	r4 = asfloat(r0.x) * r3;
	r5 = -(r2.y) + gLightPosY;
	r2 = -(r2.z) + gLightPosZ;
	r4 = r5 * asfloat(r0.y) + r4;
	r4 = r2 * asfloat(r0.z) + r4;
	r6 = r3 * r3;
	r3 = r3 * -(gLightDirX);
	r3 = r5 * -(gLightDirY) + r3;
	r5 = r5 * r5 + r6;
	r5 = r2 * r2 + r5;
	r3 = r2 * -(gLightDirZ) + r3;
	r6 = -(r5) * gLightFallOff + float4(1, 1, 1, 1);
	r5 = r5 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r5 = rsqrt(r5);
	r6 = max(r6, float4(0, 0, 0, 0));
	r6 = r6 * r6;
	r6 = r6 * r6 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r6 = max(r6, float4(0, 0, 0, 0));
	r6 = r6 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r4 = r4 * r6;
	r2 = r2 * r6;
	r2 = saturate(r5 * r2);
	r4 = saturate(r5 * r4);
	r3 = r3 * r5;
	r3 = saturate(r3 * gLightConeScale + gLightConeOffset);
	r4 = r4 * r3;
	r2 = r2 * r3;
	r0.z = asint(dot(gLightColR, r4));
	r1.w = dot(gLightColR, r2);
	r3.x = r1.w * 0.25 + asfloat(r0.z);
	r0.z = asint(dot(gLightColG, r4));
	r1.w = dot(gLightColB, r4);
	r3.w = dot(gLightColG, r2);
	r2.x = dot(gLightColB, r2);
	r3.z = r2.x * 0.25 + r1.w;
	r3.y = r3.w * 0.25 + asfloat(r0.z);
	r2.xyz = r3.xyz * i.color.xyz;
	r2.xyz = r2.xyz * gExtraLights;
	r2.xyz = max(r2.xyz, float3(0, 0, 0));
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
	r0.xzw = asint(r2.xyz + asfloat(r0.xzw));
	r2.xyz = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r2.xyz = asfloat(r0.yyy) * r2.xyz + gLightAmbient0.xyz;
	r2.xyz = r2.xyz * gAmbientOcclusionEffect.yyy;
	r2.xyz = r2.xyz * gAmbientAmount;
	r2.xyz = r2.xyz / gAmbientOcclusionEffect.yyy;
	r2.xyz = r2.xyz * i.color.xyz;
	r2.xyz = max(r2.xyz, float3(0, 0, 0));
	r0.xyz = asint(r2.xyz * gAmbientShadow + asfloat(r0.xzw));
	r0.w = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	r0 = asint(r1.y * gWorldView[1]);
	r0 = asint(r1.x * gWorldView[0] + asfloat(r0));
	r0 = asint(r1.z * gWorldView[2] + asfloat(r0));
	r1.xyz = r1.xyz + -(gViewInverse[3].xyz);
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.y = 0;
	o.texcoord3.w = i.texcoord3.y;
	r0.x = asint(r1.z * globalFogParams.x);
	r0.y = asint(dot(r1.xyz, r1.xyz));
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
