cbuffer _Globals : register(b4)
{
	float g_fSSAOBilateralCoef : packoffset(c130);
	float g_fVolumetricLightRayIntensityMult : packoffset(c131);
};

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

SamplerState gDeferredLightSampler : register(s0);
SamplerState StereoParmsTex : register(s9);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	float4 r4;
	int4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	r0.xy = asint(i.sv_position.xy * gooDeferredLightScreenSize.xy);
	r0.xy = asint(asfloat(r0.xy) * gooDeferredLightScreenSize.zw);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz));
	r0.yzw = asint(float3(0, 0, 1));
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.y = (i.texcoord5.w == 1) ? -1 : 0;
	if (r0.y != 0) {
		r0.y = asint(1 / asfloat(r0.x));
		r1 = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)));
		r0.y = asint(asfloat(r0.y) + -(asfloat(r1.y)));
		r0.y = asint(asfloat(r0.y) * asfloat(r1.x));
		r0.y = asint(asfloat(r0.y) * gDeferredProjParams.x);
		r0.yzw = asint(-(gViewInverse[0].xyz) * asfloat(r0.yyy) + gViewInverse[3].xyz);
	} else {
		r1 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
		r0.yzw = asint(asfloat(r1.xyz) + gViewInverse[3].xyz);
	}
	r0.x = asint(asfloat(r0.x) * i.texcoord5.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.xyz = asint(-(i.texcoord5.xyz) * asfloat(r0.xxx) + asfloat(r0.yzw));
	r1 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
	r1.xyz = asint(asfloat(r1.xyz) + gViewInverse[3].xyz);
	r2.xyz = -(asfloat(r1.xyz)) + i.texcoord3.xyz;
	r3.xyz = asint(asfloat(r0.xyz) + -(asfloat(r1.xyz)));
	r0.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r1.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = (asfloat(r1.w) >= asfloat(r0.w)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r0.xyz = asint(asfloat(r0.xyz) + -(i.texcoord3.xyz));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz) + i.texcoord3.xyz);
	r1.xyz = asint(-(asfloat(r0.xyz)) + asfloat(r1.xyz));
	r2.x = dot(gShadowParam4567.xyz, asfloat(r1.xyz));
	r2.y = dot(gShadowParam891113.xyz, asfloat(r1.xyz));
	r2.z = dot(gShadowParam14151617.xyz, asfloat(r1.xyz));
	r2.w = dot(gShadowParam18192021.xyz, asfloat(r1.xyz));
	r0.w = asint(dot(gShadowParam4567.xyz, asfloat(r0.xyz)));
	r1.w = asint(dot(gShadowParam891113.xyz, asfloat(r0.xyz)));
	r3.x = asint(dot(gShadowParam14151617.xyz, asfloat(r0.xyz)));
	r3.y = asint(dot(gShadowParam18192021.xyz, asfloat(r0.xyz)));
	r4.x = -(asfloat(r0.w)) + gShadowParam4567.w;
	r4.y = -(asfloat(r1.w)) + gShadowParam891113.w;
	r4.z = -(asfloat(r3.x)) + gShadowParam14151617.w;
	r4.w = -(asfloat(r3.y)) + gShadowParam18192021.w;
	r2 = r4 / r2;
	r3 = (float4(0, 0, 0, 0) >= r2) ? -1 : 0;
	r3 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r2 = saturate(r2);
	r2 = asfloat(r3) + r2;
	r2.xy = min(r2.zw, r2.xy);
	r0.w = asint(min(r2.y, r2.x));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r2.xy = i.sv_position.xy * float2(0.333333343, 0.333333343);
	r2.xy = frac(r2.xy);
	r0.w = asint(r2.x * 0.333333343 + r2.y);
	r0.w = asint(asfloat(r0.w) * 0.899999976 + 0.0500000007);
	r2.xyz = asfloat(r1.xyz) * float3(0.0769230798, 0.0769230798, 0.0769230798);
	r0.xyz = asint(r2.xyz * asfloat(r0.www) + asfloat(r0.xyz));
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + 0.333333343);
	r0.w = asint(asfloat(r0.w) * 0.0250000004);
	r2 = asfloat(r0.y) * gShadowMatrix[1];
	r2 = asfloat(r0.x) * gShadowMatrix[0] + r2;
	r2 = asfloat(r0.z) * gShadowMatrix[2] + r2;
	r2 = r2 + gShadowMatrix[3];
	r1.w = asint(r2.w + 0.000000100000001);
	r2.xyz = r2.xyz / asfloat(r1.www);
	r3.xy = asint(r2.xy * float2(0.5, -0.5));
	r2.xy = r2.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r1.w = (0.509999990 >= asfloat(r1.w)) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r3.x = (r2.w >= 0) ? -1 : 0;
	r3.x = r3.x & 1065353216;
	r1.w = asint(asfloat(r1.w) * asfloat(r3.x));
	r3.x = asint(i.texcoord1.w * i.texcoord1.w);
	r4 = float4(0, 0, 0, 0);
	r3.yzw = r0.xyz;
	r5.xy = asint(r2.xy);
	r6.xy = r2.zw;
	r5.z = 0;
	while (true) {
		r5.w = (r5.z >= 12) ? -1 : 0;
		if (r5.w != 0) break;
		r3.yzw = asint(asfloat(r1.xyz) * float3(0.307692319, 0.307692319, 0.307692319) + asfloat(r3.yzw));
		r7 = asfloat(r3.z) * gShadowMatrix[1];
		r7 = asfloat(r3.y) * gShadowMatrix[0] + r7;
		r7 = asfloat(r3.w) * gShadowMatrix[2] + r7;
		r7 = r7 + gShadowMatrix[3];
		r7.xyz = r7.xyz / r7.www;
		r6.zw = r7.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
		r8 = -(asfloat(r5.xyxy)) + r6.zwzw;
		r9 = r8.zwzw * float4(0.375, 0.375, 0.25, 0.25) + asfloat(r5.xyxy);
		r10 = gDeferredLightSampler_tex.Sample(gDeferredLightSampler, r9.xy);
		r5.w = asint(r10.x + r10.x);
		r7.x = -(r6.y) + i.texcoord1.w;
		r7.x = r7.x + -1;
		r7.x = max(r7.x, 0);
		r7.x = r7.x * r7.x;
		r7.x = r7.x / asfloat(r3.x);
		r7.x = min(r7.x, 1);
		r7.x = asfloat(r0.w) * r7.x;
		r5.w = asint(asfloat(r5.w) * r7.x);
		r10.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r5.xy), r6.x);
		r10.y = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r9.zw, r6.x);
		r8 = r8 * float4(0.5, 0.5, 0.75, 0.75) + asfloat(r5.xyxy);
		r10.z = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.xy, r6.x);
		r10.w = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.zw, r6.x);
		r4 = r10 * asfloat(r5.w) + r4;
		r5.z = r5.z + 4;
		r5.xy = asint(r6.zw);
		r6.xy = r7.zw;
	}
	r0.x = asint(dot(r4, float4(1, 1, 1, 1)));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x));
	r0.xyz = asint(asfloat(r0.xxx) * i.texcoord2.xyz);
	o.xyz = asfloat(r0.xyz) * g_fVolumetricLightRayIntensityMult;
	o.w = 0;

	return o;
}
