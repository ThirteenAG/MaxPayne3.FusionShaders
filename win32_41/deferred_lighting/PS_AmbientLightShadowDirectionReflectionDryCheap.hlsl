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

cbuffer DeferredLight : register(b4)
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
Texture2D deferredLightTexture0P : register(t3);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float3 r3;
	float3 r4;
	float3 r5;
	float3 r6;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = asint(asfloat(r1.x) * i.texcoord1.w);
	r1.x = asint(1 / asfloat(r1.x));
	r1.yzw = asint(-(i.texcoord1.xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	r2.xyz = asint(-(i.texcoord1.xyz) * asfloat(r1.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3 = asfloat(r1.zzz) * gShadowMatrix[1].xyz;
	r1.xyz = asint(asfloat(r1.yyy) * gShadowMatrix[0].xyz + r3.xyz);
	r1.xyz = asint(asfloat(r1.www) * gShadowMatrix[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + gShadowMatrix[3].xyz);
	r3.xy = asfloat(r1.xy) + -(gShadowParam18192021.zw);
	r1.w = (r3.x >= gCascadeXMaxThresholds.x) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.w = (gCascadeXMinThresholds.x >= r3.x) ? -1 : 0;
	r2.w = r2.w & 1065353216;
	r1.w = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.w = (r3.y >= gCascadeYMaxThresholds.x) ? -1 : 0;
	r2.w = r2.w & 1065353216;
	r1.w = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.w = (gCascadeYMinThresholds.x >= r3.y) ? -1 : 0;
	r2.w = r2.w & 1065353216;
	r1.w = asint(asfloat(r1.w) + asfloat(r2.w));
	r4.y = min(asfloat(r1.w), 1);
	r4.x = 1;
	r5.x = dot(r4.xy, gShadowParam0123.xy);
	r5.y = dot(r4.xy, gShadowParam4567.xy);
	r5.z = dot(r4.xy, gCascadeZScales.xy);
	r6.x = dot(r4.xy, gShadowParam891113.xy);
	r6.y = dot(r4.xy, gShadowParam14151617.xy);
	r6.z = dot(r4.xy, gCascadeZOffsets.xy);
	r1.xyz = asint(asfloat(r1.zxy) * r5.zxy + r6.zxy);
	r1.x = asint(saturate(asfloat(r1.x)));
	r1.x = asint(-(asfloat(r1.x)) + 1);
	r1.x = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r1.yz), asfloat(r1.x)));
	r4.x = -(gCascadeXMinThresholds.w);
	r4.y = -(gCascadeXMaxThresholds.w);
	r1.yz = asint(saturate(abs(r3.xy) * float2(4, 4) + r4.xy));
	r1.y = asint(max(asfloat(r1.z), asfloat(r1.y)));
	r1.x = asint(asfloat(r1.y) + asfloat(r1.x));
	r1.x = asint(min(asfloat(r1.x), 1));
	r1.xyz = asint(asfloat(r1.xxx) * gDirectionalColour.xyz);
	r3 = gbufferTexture1.Load(r0.xyw).xyz;
	r3 = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.w = asint(dot(r3.xyz, r3.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3 = asfloat(r1.www) * r3.xyz;
	r1.w = asint(dot(r3.xyz, -(gDirectionalLight.xyz)));
	r2.w = asint(saturate(asfloat(r1.w) + -0.25));
	r1.w = asint(saturate(asfloat(r1.w) * 2 + -0.5));
	r2.w = asint(asfloat(r2.w) * 1.33333337);
	r4 = asfloat(r1.xyz) * asfloat(r2.www);
	r2.w = asint(dot(gLightAmbientDir1.xyz, r3.xyz));
	r2.w = asint(saturate(asfloat(r2.w) + gLightAmbientDir0.w));
	r5 = asfloat(r2.www) * gLightAmbient1.xyz;
	r2.w = asint(dot(gLightAmbientDir0.xyz, r3.xyz));
	r2.w = asint(saturate(asfloat(r2.w) + gLightAmbientDir0.w));
	r5 = asfloat(r2.www) * gLightAmbient0.xyz + r5.xyz;
	r6 = gbufferTexture2.Load(r0.xyw).xyz;
	r5 = r5.xyz * r6.zzz;
	r2.w = asint(sqrt(r6.z));
	r4 = r4.xyz * asfloat(r2.www) + r5.xyz;
	r2.w = asint(dot(r4.xyz, float3(0.333333343, 0.333333343, 0.333333343)));
	r2.w = asint(asfloat(r2.w) + 0.0149999997);
	r5 = deferredLightTexture0P.Load(r0.xyz).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r5 = r5.xyz * r5.xyz;
	r5 = r5.xyz * float3(16, 16, 16);
	r5 = asfloat(r2.www) * r5.xyz;
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asint(asfloat(r0.www) * asfloat(r2.xyz));
	r0.w = asint(dot(asfloat(r2.xyz), r3.xyz));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r2.xyz = asint(r3.xyz * -(asfloat(r0.www)) + asfloat(r2.xyz));
	r0.w = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r2.xyz))));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r2.x = asint(r6.y * r6.y);
	r2.x = asint(asfloat(r2.x) * asfloat(r2.x));
	r2.x = asint(asfloat(r2.x) * 196 + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * asfloat(r2.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(asfloat(r1.w) * asfloat(r0.w));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * r6.xxx + r5.xyz);
	o.xyz = asfloat(r0.xyz) * r4.xyz + asfloat(r1.xyz);
	o.w = 1;

	return o;
}
