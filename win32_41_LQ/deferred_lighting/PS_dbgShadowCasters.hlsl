cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D ShadowZTextureDir : register(t15);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int3 r2;
	float3 r3;
	float3 r4;
	r0.xy = (int2)sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.yz = asint(sv_position.xy * gooDeferredLightScreenSize.zw);
	r0.yz = asint(asfloat(r0.yz) * float2(2, 2) + float2(-1, -1));
	r1 = asint(asfloat(r0.z) * gViewInverse[1]);
	r1 = asint(asfloat(r0.y) * gViewInverse[0] + asfloat(r1));
	r1 = asint(asfloat(r1) + gViewInverse[2]);
	r0.x = asint(asfloat(r0.x) * asfloat(r1.w));
	r0.x = asint(1 / asfloat(r0.x));
	r0.xyz = asint(-(asfloat(r1.xyz)) * asfloat(r0.xxx) + gViewInverse[3].xyz);
	r1.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyz);
	r0.xyw = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyz + asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyz + asfloat(r0.xyw));
	r0.xyz = asint(asfloat(r0.xyz) + gShadowMatrix[3].xyz);
	r1.xy = asint(asfloat(r0.xy) + -(gShadowParam18192021.zw));
	r1.zw = (asfloat(r1.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r1.zw = r1.zw & int2(1065353216, 1065353216);
	r2.xy = (gCascadeXMinThresholds.xy >= asfloat(r1.xx)) ? -1 : 0;
	r2.xy = r2.xy & int2(1065353216, 1065353216);
	r1.zw = asint(asfloat(r1.zw) + asfloat(r2.xy));
	r2.xy = (asfloat(r1.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r2.xy = r2.xy & int2(1065353216, 1065353216);
	r1.zw = asint(asfloat(r1.zw) + asfloat(r2.xy));
	r2.xy = (gCascadeYMinThresholds.xy >= asfloat(r1.yy)) ? -1 : 0;
	r2.xy = r2.xy & int2(1065353216, 1065353216);
	r1.zw = asint(asfloat(r1.zw) + asfloat(r2.xy));
	r2.yz = asint(min(asfloat(r1.zw), float2(1, 1)));
	r2.x = 1065353216;
	r3.x = dot(asfloat(r2.xyz), gShadowParam0123.xyz);
	r3.y = dot(asfloat(r2.xyz), gShadowParam4567.xyz);
	r3.z = dot(asfloat(r2.xyz), gCascadeZScales.xyz);
	r4.x = dot(asfloat(r2.xyz), gShadowParam891113.xyz);
	r4.y = dot(asfloat(r2.xyz), gShadowParam14151617.xyz);
	r4.z = dot(asfloat(r2.xyz), gCascadeZOffsets.xyz);
	r0.xyz = asint(asfloat(r0.zxy) * r3.zxy + r4.zxy);
	r0.x = asint(saturate(asfloat(r0.x)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r0.yz), asfloat(r0.x)));
	r2.x = asint(-(gCascadeXMinThresholds.w));
	r2.y = asint(-(gCascadeXMaxThresholds.w));
	r0.yz = asint(saturate(abs(asfloat(r1.xy)) * float2(4, 4) + asfloat(r2.xy)));
	r0.y = asint(max(asfloat(r0.z), asfloat(r0.y)));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	o = min(asfloat(r0.x), float4(1, 1, 1, 1));

	return o;
}
