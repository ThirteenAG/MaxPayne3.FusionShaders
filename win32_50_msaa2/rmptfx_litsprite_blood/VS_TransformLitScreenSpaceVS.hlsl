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

cbuffer CacheHybrid : register(b4)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleGlobals : register(b7)
{
	float4 gBloodLightingTuners : packoffset(c0);
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
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.x = asint(sin(i.normal.z));
	r1.x = cos(i.normal.z);
	r0.xy = asint(asfloat(r0.xx) * i.normal.yx);
	r2.x = i.normal.x * r1.x + -(asfloat(r0.x));
	r2.y = i.normal.y * r1.x + asfloat(r0.y);
	r2.z = 0;
	r0.xy = asint(i.position.xy);
	r0.z = 0;
	r1.xyz = r2.xyz * gAspectRatio.xyz + asfloat(r0.xyz);
	r2.xyz = r2.xyz * gAspectRatio.xyz;
	r0.w = (i.normal.w == 1) ? -1 : 0;
	o.sv_position.xyz = (r0.www != 0) ? r1.xyz : asfloat(r0.xyz);
	r0.xyz = asint((r0.www != 0) ? r2.xyz : i.position.xyz);
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
	r0.w = asint(dot(gLightColR, r3));
	r2.x = dot(gLightColR, r1);
	r2.x = r2.x * 0.25 + asfloat(r0.w);
	r0.w = asint(dot(gLightColG, r1));
	r1.x = dot(gLightColB, r1);
	r1.y = dot(gLightColG, r3);
	r1.z = dot(gLightColB, r3);
	r2.z = r1.x * 0.25 + r1.z;
	r2.y = asfloat(r0.w) * 0.25 + r1.y;
	r1.xyz = max(r2.xyz, gBloodLightingTuners.xxx);
	r1.xyz = min(r1.xyz, gBloodLightingTuners.yyy);
	r1.xyz = r1.xyz * i.color.xyz;
	r1.xyz = max(r1.xyz, float3(0, 0, 0));
	r0.w = asint(dot(asfloat(r0.xyz), -(gDirectionalLight.xyz)));
	r0.w = asint(max(asfloat(r0.w), -(gLightIntensityClamp)));
	r0.w = asint(min(asfloat(r0.w), gLightIntensityClamp));
	r1.w = -(asfloat(r0.w)) + 1;
	r0.w = asint(gNormalArc * r1.w + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gWrapScale + gWrapBias);
	r0.w = asint(asfloat(r0.w) * gDirectionalColour.x);
	r0.w = asint(asfloat(r0.w) * gDiffuse);
	r0.w = asint(max(asfloat(r0.w), gBloodLightingTuners.x));
	r0.w = asint(min(asfloat(r0.w), gBloodLightingTuners.y));
	r2.xyz = asfloat(r0.www) * i.color.xyz;
	r2.xyz = max(r2.xyz, float3(0, 0, 0));
	r2.xyz = r2.xyz + i.color.xyz;
	r1.xyz = r1.xyz + r2.xyz;
	r0.w = asint(dot(gLightAmbientDir1.xyz, asfloat(r0.xyz)));
	r0.x = asint(dot(gLightAmbientDir0.xyz, asfloat(r0.xyz)));
	r0.xy = asint(saturate(asfloat(r0.xw) + gLightAmbientDir0.ww));
	r0.yzw = asint(asfloat(r0.yyy) * gLightAmbient1.xyz);
	r0.xyz = asint(asfloat(r0.xxx) * gLightAmbient0.xyz + asfloat(r0.yzw));
	r0.xyz = asint(asfloat(r0.xyz) * gBloodLightingTuners.zzz);
	r0.xyz = asint(asfloat(r0.xyz) * i.color.xyz);
	r0.xyz = asint(max(asfloat(r0.xyz), float3(0, 0, 0)));
	r0.xyz = asint(asfloat(r0.xyz) * gAmbientShadow + r1.xyz);
	r0.w = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r0 = asint(i.position.y * gWorldView[1]);
	r0 = asint(i.position.x * gWorldView[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldView[2] + asfloat(r0));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
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
