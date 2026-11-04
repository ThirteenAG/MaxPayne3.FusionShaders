cbuffer _Globals : register(b4)
{
	float g_fSSAOBilateralCoef : packoffset(c130);
	float g_fVolumetricLightRayIntensityMult : packoffset(c131);
	float4 dReflectionParams : packoffset(c132);
};

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

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
	float4 gShadowParam4567 : packoffset(c3);
	float4 gShadowParam891113 : packoffset(c4);
	float4 gCascadeZScales : packoffset(c5);
	float4 gCascadeZOffsets : packoffset(c6);
	float4 gCascadeXMinThresholds : packoffset(c7);
	float4 gCascadeXMaxThresholds : packoffset(c8);
	float4 gCascadeYMinThresholds : packoffset(c9);
	float4 gCascadeYMaxThresholds : packoffset(c10);
	row_major float4x4 gShadowMatrix : packoffset(c11);
};

cbuffer DeferredLight : register(b7)
{
	float gDeferredLightType : packoffset(c0);
	float3 gDeferredLightPosition : packoffset(c0.y);
	float3 gDeferredLightDirection : packoffset(c1);
	float3 gDeferredLightTangent : packoffset(c2);
	float4 gDeferredLightRadiusProjShearParams : packoffset(c3);
	float gDeferredLightInvSqrRadius : packoffset(c4);
	float gDeferredVolumeRadiusScale : packoffset(c4.y);
	float gDeferredLightConeAngleI : packoffset(c4.z);
	float gDeferredLightConeAngle : packoffset(c4.w);
	float gDeferredLightConeOffset : packoffset(c5);
	float gDeferredLightConeScale : packoffset(c5.y);
	float4 gDeferredLightColourAndIntensity : packoffset(c6);
	float4 gooDeferredLightScreenSize : packoffset(c7);
	float4 gDeferredProjParams : packoffset(c8);
};

SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2DMS<float4> deferredLightTexture0P : register(t3);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
Texture2DMS<uint4> gbufferStencilTexture : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	float3 r5;
	float3 r6;
	float3 r7;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord1.w;
	r1.x = 1 / r1.x;
	r1.yzw = -(i.texcoord1.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2.xyz = asint(-(i.texcoord1.xyz) * r1.xxx + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.xyz = asint(-(r1.yzw) + gViewInverse[3].xyz);
	r1.x = dot(asfloat(r3.xyz), asfloat(r3.xyz));
	r1.x = rsqrt(r1.x);
	r3.xyz = asint(r1.xxx * asfloat(r3.xyz));
	r4.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r4.xyz = asint(asfloat(r4.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = dot(asfloat(r4.xyz), asfloat(r4.xyz));
	r1.x = rsqrt(r1.x);
	r4.xyz = asint(r1.xxx * asfloat(r4.xyz));
	r1.x = dot(asfloat(r3.xyz), asfloat(r4.xyz));
	r1.x = -(abs(r1.x)) + 1;
	r1.x = max(r1.x, 0);
	r1.x = r1.x + 0.00000999999975;
	r2.w = asint(r1.x * r1.x);
	r2.w = asint(asfloat(r2.w) * asfloat(r2.w));
	r1.x = r1.x * asfloat(r2.w);
	r1.x = r1.x * 0.800000012 + 0.200000003;
	r2.w = gbufferStencilTexture.Load(r0.xy, i.sv_sampleindex).y;
	r3.x = r2.w & 64;
	r3.x = ~r3.x;
	r2.w = r2.w & r3.x;
	r3.x = asint(saturate(asfloat(r4.z) * 4));
	r3.x = asint(asfloat(r3.x) * dReflectionParams.y);
	r2.w = (r2.w != 0) ? 0 : r3.x;
	r3.xyz = asint(gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xyz);
	r3.y = asint(asfloat(r3.y) * asfloat(r3.y));
	r3.y = asint(asfloat(r3.y) * asfloat(r3.y));
	r3.w = asint(-(asfloat(r3.y)) * 196 + 512);
	r3.yw = asint(asfloat(r3.yw) * float2(196, 0.001953125));
	r3.w = asint(max(asfloat(r3.w), 0));
	r3.w = asint(asfloat(r2.w) * asfloat(r3.w));
	r3.w = asint(r1.x * asfloat(r3.w));
	r3.y = asint(asfloat(r3.w) * 512 + asfloat(r3.y));
	r3.y = asint(asfloat(r3.y) + 0.00000999999975);
	r3.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r3.www));
	r3.w = asint(dot(asfloat(r2.xyz), asfloat(r4.xyz)));
	r3.w = asint(asfloat(r3.w) + asfloat(r3.w));
	r2.xyz = asint(asfloat(r4.xyz) * -(asfloat(r3.www)) + asfloat(r2.xyz));
	r2.x = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r2.xyz))));
	r2.x = asint(asfloat(r2.x) + 0.00000999999975);
	r2.x = asint(log2(asfloat(r2.x)));
	r2.x = asint(asfloat(r2.x) * asfloat(r3.y));
	r2.x = asint(exp2(asfloat(r2.x)));
	r2.y = asint(dot(asfloat(r4.xyz), -(gDirectionalLight.xyz)));
	r2.z = asint(saturate(asfloat(r2.y) * 2 + -0.5));
	r2.y = asint(saturate(asfloat(r2.y) + -0.25));
	r2.y = asint(asfloat(r2.y) * 1.33333337);
	r2.x = asint(asfloat(r2.z) * asfloat(r2.x));
	r5 = r1.zzz * gShadowMatrix[1].xyz;
	r5 = r1.yyy * gShadowMatrix[0].xyz + r5.xyz;
	r1.yzw = r1.www * gShadowMatrix[2].xyz + r5.xyz;
	r1.yzw = r1.yzw + gShadowMatrix[3].xyz;
	r3.yw = asint(r1.yz + -(gShadowParam18192021.zw));
	r2.z = (asfloat(r3.y) >= gCascadeXMaxThresholds.x) ? -1 : 0;
	r2.z = r2.z & 1065353216;
	r4.w = (gCascadeXMinThresholds.x >= asfloat(r3.y)) ? -1 : 0;
	r4.w = r4.w & 1065353216;
	r2.z = asint(asfloat(r2.z) + asfloat(r4.w));
	r4.w = (asfloat(r3.w) >= gCascadeYMaxThresholds.x) ? -1 : 0;
	r4.w = r4.w & 1065353216;
	r2.z = asint(asfloat(r2.z) + asfloat(r4.w));
	r4.w = (gCascadeYMinThresholds.x >= asfloat(r3.w)) ? -1 : 0;
	r4.w = r4.w & 1065353216;
	r2.z = asint(asfloat(r2.z) + asfloat(r4.w));
	r5.y = min(asfloat(r2.z), 1);
	r5.x = 1;
	r6.x = dot(r5.xy, gShadowParam0123.xy);
	r6.y = dot(r5.xy, gShadowParam4567.xy);
	r6.z = dot(r5.xy, gCascadeZScales.xy);
	r7.x = dot(r5.xy, gShadowParam891113.xy);
	r7.y = dot(r5.xy, gShadowParam14151617.xy);
	r7.z = dot(r5.xy, gCascadeZOffsets.xy);
	r1.yzw = r1.wyz * r6.zxy + r7.zxy;
	r1.y = saturate(r1.y);
	r1.y = -(r1.y) + 1;
	r1.y = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r1.zw, r1.y);
	r5.x = -(gCascadeXMinThresholds.w);
	r5.y = -(gCascadeXMaxThresholds.w);
	r1.zw = saturate(abs(asfloat(r3.yw)) * float2(4, 4) + r5.xy);
	r1.z = max(r1.w, r1.z);
	r1.y = r1.z + r1.y;
	r1.y = min(r1.y, 1);
	r1.yzw = r1.yyy * gDirectionalColour.xyz;
	r5 = asfloat(r2.xxx) * r1.yzw;
	r1.yzw = asfloat(r2.yyy) * r1.yzw;
	r2.x = asint(dot(gLightAmbientDir1.xyz, asfloat(r4.xyz)));
	r2.y = asint(dot(gLightAmbientDir0.xyz, asfloat(r4.xyz)));
	r2.xy = asint(saturate(asfloat(r2.xy) + gLightAmbientDir0.ww));
	r4.xyz = asint(asfloat(r2.xxx) * gLightAmbient1.xyz);
	r2.xyz = asint(asfloat(r2.yyy) * gLightAmbient0.xyz + asfloat(r4.xyz));
	r2.xyz = asint(asfloat(r3.zzz) * asfloat(r2.xyz));
	r3.y = asint(sqrt(asfloat(r3.z)));
	r1.yzw = r1.yzw * asfloat(r3.yyy) + asfloat(r2.xyz);
	r2.x = asint(dot(r1.yzw, float3(0.333333343, 0.333333343, 0.333333343)));
	r2.x = asint(asfloat(r2.x) + 0.0149999997);
	r3.yzw = asint(deferredLightTexture0P.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r3.yzw = asint(asfloat(r3.yzw) * asfloat(r3.yzw));
	r3.yzw = asint(asfloat(r3.yzw) * float3(16, 16, 16));
	r2.xyz = asint(asfloat(r2.xxx) * asfloat(r3.yzw));
	r0.w = asint(saturate(-(asfloat(r3.x)) + 1));
	r0.w = asint(asfloat(r2.w) * asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * r1.x + asfloat(r3.x));
	r2.xyz = asint(r5.xyz * asfloat(r0.www) + asfloat(r2.xyz));
	o.xyz = asfloat(r0.xyz) * r1.yzw + asfloat(r2.xyz);
	o.w = 1;

	return o;
}
