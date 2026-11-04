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

SamplerState StereoParmsTex : register(s9);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D ShadowZTextureDir : register(t15);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	int4 r2;
	int3 r3;
	float3 r4;
	r0.xy = sv_position.xy * gooDeferredLightScreenSize.zw;
	r0.xy = r0.xy * float2(2, 2) + float2(-1, -1);
	r1 = asint(r0.y * gViewInverse[1]);
	r0 = r0.x * gViewInverse[0] + asfloat(r1);
	r0 = r0 + gViewInverse[2];
	r1.xy = (int2)sv_position.xy;
	r1.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r1.xyz));
	r1.yzw = asint(float3(0, 0, 1));
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.y = (r0.w == 1) ? -1 : 0;
	if (r1.y != 0) {
		r1.y = asint(1 / asfloat(r1.x));
		r2 = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)));
		r1.y = asint(asfloat(r1.y) + -(asfloat(r2.y)));
		r1.y = asint(asfloat(r1.y) * asfloat(r2.x));
		r1.y = asint(asfloat(r1.y) * gDeferredProjParams.x);
		r1.yzw = asint(-(gViewInverse[0].xyz) * asfloat(r1.yyy) + gViewInverse[3].xyz);
	} else {
		r2 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
		r1.yzw = asint(asfloat(r2.xyz) + gViewInverse[3].xyz);
	}
	r0.w = r0.w * asfloat(r1.x);
	r0.w = 1 / r0.w;
	r0.xyz = -(r0.xyz) * r0.www + asfloat(r1.yzw);
	r1.xyz = asint(r0.yyy * gShadowMatrix[1].xyz);
	r0.xyw = r0.xxx * gShadowMatrix[0].xyz + asfloat(r1.xyz);
	r0.xyz = r0.zzz * gShadowMatrix[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gShadowMatrix[3].xyz;
	r1.xy = asint(r0.xy + -(gShadowParam18192021.zw));
	r1.zw = (asfloat(r1.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r1.zw = r1.zw & int2(1065353216, 1065353216);
	r2.xy = (gCascadeXMinThresholds.xy >= asfloat(r1.xx)) ? -1 : 0;
	r2.zw = (asfloat(r1.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r2 = r2 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r3.xy = (gCascadeYMinThresholds.xy >= asfloat(r1.yy)) ? -1 : 0;
	r3.xy = r3.xy & int2(1065353216, 1065353216);
	r1.zw = asint(asfloat(r1.zw) + asfloat(r2.xy));
	r1.zw = asint(asfloat(r2.zw) + asfloat(r1.zw));
	r1.zw = asint(asfloat(r3.xy) + asfloat(r1.zw));
	r2.yz = asint(min(asfloat(r1.zw), float2(1, 1)));
	r2.x = 1065353216;
	r3.x = asint(dot(asfloat(r2.xyz), gShadowParam0123.xyz));
	r3.y = asint(dot(asfloat(r2.xyz), gShadowParam4567.xyz));
	r3.z = asint(dot(asfloat(r2.xyz), gCascadeZScales.xyz));
	r4.x = dot(asfloat(r2.xyz), gShadowParam891113.xyz);
	r4.y = dot(asfloat(r2.xyz), gShadowParam14151617.xyz);
	r4.z = dot(asfloat(r2.xyz), gCascadeZOffsets.xyz);
	r0.xyz = r0.zxy * asfloat(r3.zxy) + r4.zxy;
	r0.x = saturate(r0.x);
	r2.x = asint(-(gCascadeXMinThresholds.w));
	r2.y = asint(-(gCascadeXMaxThresholds.w));
	r1.xy = asint(saturate(abs(asfloat(r1.xy)) * float2(4, 4) + asfloat(r2.xy)));
	r0.w = max(asfloat(r1.y), asfloat(r1.x));
	r0.x = -(r0.x) + 1;
	r0.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r0.yz, r0.x);
	r0.x = r0.w + r0.x;
	o = min(r0.x, float4(1, 1, 1, 1));

	return o;
}
