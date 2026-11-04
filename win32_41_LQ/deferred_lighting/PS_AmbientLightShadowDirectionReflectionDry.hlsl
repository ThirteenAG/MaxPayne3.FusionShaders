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
	float4 r1;
	float4 r2;
	int4 r3;
	int3 r4;
	float3 r5;
	float3 r6;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xyw).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord1.w;
	r1.x = 1 / r1.x;
	r1.yzw = -(i.texcoord1.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2.xyz = -(i.texcoord1.xyz) * r1.xxx + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.xyz = asint(r1.zzz * gShadowMatrix[1].xyz);
	r1.xyz = r1.yyy * gShadowMatrix[0].xyz + asfloat(r3.xyz);
	r1.xyz = r1.www * gShadowMatrix[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gShadowMatrix[3].xyz;
	r3.xy = asint(r1.xy + -(gShadowParam18192021.zw));
	r3.zw = (asfloat(r3.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r3.zw = r3.zw & int2(1065353216, 1065353216);
	r4.xy = (gCascadeXMinThresholds.xy >= asfloat(r3.xx)) ? -1 : 0;
	r4.xy = r4.xy & int2(1065353216, 1065353216);
	r3.zw = asint(asfloat(r3.zw) + asfloat(r4.xy));
	r4.xy = (asfloat(r3.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r4.xy = r4.xy & int2(1065353216, 1065353216);
	r3.zw = asint(asfloat(r3.zw) + asfloat(r4.xy));
	r4.xy = (gCascadeYMinThresholds.xy >= asfloat(r3.yy)) ? -1 : 0;
	r4.xy = r4.xy & int2(1065353216, 1065353216);
	r3.zw = asint(asfloat(r3.zw) + asfloat(r4.xy));
	r4.yz = asint(min(asfloat(r3.zw), float2(1, 1)));
	r4.x = 1065353216;
	r5.x = dot(asfloat(r4.xyz), gShadowParam0123.xyz);
	r5.y = dot(asfloat(r4.xyz), gShadowParam4567.xyz);
	r5.z = dot(asfloat(r4.xyz), gCascadeZScales.xyz);
	r6.x = dot(asfloat(r4.xyz), gShadowParam891113.xyz);
	r6.y = dot(asfloat(r4.xyz), gShadowParam14151617.xyz);
	r6.z = dot(asfloat(r4.xyz), gCascadeZOffsets.xyz);
	r1.xyz = r1.zxy * r5.zxy + r6.zxy;
	r1.x = saturate(r1.x);
	r1.x = -(r1.x) + 0.999999523;
	r1.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r1.yz, r1.x);
	r4.x = asint(-(gCascadeXMinThresholds.w));
	r4.y = asint(-(gCascadeXMaxThresholds.w));
	r1.yz = saturate(abs(asfloat(r3.xy)) * float2(4, 4) + asfloat(r4.xy));
	r1.y = max(r1.z, r1.y);
	r1.x = r1.y + r1.x;
	r1.x = r1.x * 1.25;
	r1.x = min(r1.x, 1);
	r1.y = r1.x * -2 + 3;
	r1.x = r1.x * r1.x;
	r1.x = r1.x * r1.y;
	r1.xyz = r1.xxx * gDirectionalColour.xyz;
	r3.xyz = asint(gbufferTexture1.Load(r0.xyw).xyz);
	r3.xyz = asint(asfloat(r3.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.w = dot(asfloat(r3.xyz), asfloat(r3.xyz));
	r1.w = rsqrt(r1.w);
	r3.xyz = asint(r1.www * asfloat(r3.xyz));
	r1.w = dot(asfloat(r3.xyz), -(gDirectionalLight.xyz));
	r2.w = saturate(r1.w + -0.25);
	r1.w = saturate(r1.w * 2 + -0.5);
	r2.w = r2.w * 1.33333337;
	r4 = asint(r1.xyz * r2.www);
	r2.w = dot(gLightAmbientDir1.xyz, asfloat(r3.xyz));
	r2.w = saturate(r2.w + gLightAmbientDir0.w);
	r5 = r2.www * gLightAmbient1.xyz;
	r2.w = dot(gLightAmbientDir0.xyz, asfloat(r3.xyz));
	r2.w = saturate(r2.w + gLightAmbientDir0.w);
	r5 = r2.www * gLightAmbient0.xyz + r5.xyz;
	r6 = gbufferTexture2.Load(r0.xyw).xyz;
	r5 = r5.xyz * r6.zzz;
	r2.w = sqrt(r6.z);
	r4 = asint(asfloat(r4.xyz) * r2.www + r5.xyz);
	r2.w = dot(asfloat(r4.xyz), float3(0.333333343, 0.333333343, 0.333333343));
	r2.w = r2.w + 0.0149999997;
	r5 = deferredLightTexture0P.Load(r0.xyz).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r5 = r5.xyz * r5.xyz;
	r5 = r5.xyz * float3(16, 16, 16);
	r5 = r2.www * r5.xyz;
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asfloat(r0.www) * r2.xyz;
	r0.w = asint(dot(r2.xyz, asfloat(r3.xyz)));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r2.xyz = asfloat(r3.xyz) * -(asfloat(r0.www)) + r2.xyz;
	r0.w = asint(saturate(dot(-(gDirectionalLight.xyz), r2.xyz)));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r2.x = r6.y * r6.y;
	r2.x = r2.x * r2.x;
	r2.x = r2.x * 196 + 0.00000999999975;
	r0.w = asint(asfloat(r0.w) * r2.x);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(r1.w * asfloat(r0.w));
	r1.xyz = asfloat(r0.www) * r1.xyz;
	r1.xyz = r1.xyz * r6.xxx + r5.xyz;
	o.xyz = asfloat(r0.xyz) * asfloat(r4.xyz) + r1.xyz;
	o.w = 1;

	return o;
}
