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

SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D<float> gbufferTextureDepth : register(t10);
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
	float4 r5;
	int4 r6;
	int4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 r12;
	r0.xy = asint(i.sv_position.xy * gooDeferredLightScreenSize.xy);
	r0.xy = asint(asfloat(r0.xy) * gooDeferredLightScreenSize.zw);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.x = asint(asfloat(r0.x) * i.texcoord5.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.yzw = asint(asfloat(r0.xxx) * i.texcoord5.xyz);
	r1.xyz = asint(-(i.texcoord5.xyz) * asfloat(r0.xxx) + gViewInverse[3].xyz);
	r2.xyz = i.texcoord3.xyz + -(gViewInverse[3].xyz);
	r0.x = asint(dot(-(asfloat(r0.yzw)), -(asfloat(r0.yzw))));
	r0.y = asint(dot(r2.xyz, r2.xyz));
	r0.x = (asfloat(r0.y) >= asfloat(r0.x)) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.yzw = asint(asfloat(r1.xyz) + -(i.texcoord3.xyz));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw) + i.texcoord3.xyz);
	r1.xyz = asint(-(asfloat(r0.xyz)) + gViewInverse[3].xyz);
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
	r3.zw = asint(r2.xy * float2(0.5, -0.5) + float2(0.5, 0.5));
	r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r1.w = (0.509999990 >= asfloat(r1.w)) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r3.x = (r2.w >= 0) ? -1 : 0;
	r3.x = r3.x & 1065353216;
	r1.w = asint(asfloat(r1.w) * asfloat(r3.x));
	r4.x = dot(r2.xy, r2.xy);
	r3.x = asint(i.texcoord1.w * i.texcoord1.w);
	r5 = float4(0, 0, 0, 0);
	r6.xyz = r0.xyz;
	r7.xy = r3.zw;
	r8.xy = r2.zw;
	r3.y = 0;
	while (true) {
		r6.w = (r3.y >= 12) ? -1 : 0;
		if (r6.w != 0) break;
		r6.xyz = asint(asfloat(r1.xyz) * float3(0.307692319, 0.307692319, 0.307692319) + asfloat(r6.xyz));
		r9 = asfloat(r6.y) * gShadowMatrix[1];
		r9 = asfloat(r6.x) * gShadowMatrix[0] + r9;
		r9 = asfloat(r6.z) * gShadowMatrix[2] + r9;
		r9 = r9 + gShadowMatrix[3];
		r9.xyz = r9.xyz / r9.www;
		r7.zw = asint(r9.xy * float2(0.5, -0.5) + float2(0.5, 0.5));
		r8.zw = -(asfloat(r7.xy)) + asfloat(r7.zw);
		r9.xy = -(r2.xy) + r9.xy;
		r10 = r9.xyxy * float4(0.25, 0.25, 0.5, 0.5) + r2.xyxy;
		r4.y = dot(r10.xy, r10.xy);
		r4.z = dot(r10.zw, r10.zw);
		r9.xy = r9.xy * float2(0.75, 0.75) + r2.xy;
		r4.w = dot(r9.xy, r9.xy);
		r10 = r4 + float4(0.5, 0.5, 0.5, 0.5);
		r10 = float4(1, 1, 1, 1) / r10;
		r11 = -(r4) + float4(1, 1, 1, 1);
		r11 = max(r11, float4(0, 0, 0, 0));
		r10 = r10 * r11;
		r4.y = -(r8.y) + i.texcoord1.w;
		r4.y = r4.y + -1;
		r4.y = max(r4.y, 0);
		r4.y = r4.y * r4.y;
		r4.y = r4.y / asfloat(r3.x);
		r4.y = min(r4.y, 1);
		r4.y = asfloat(r0.w) * r4.y;
		r10 = r10 * r4.y;
		r11.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r7.xy), r8.x);
		r12 = r8.zwzw * float4(0.25, 0.25, 0.5, 0.5) + asfloat(r7.xyxy);
		r11.y = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r12.xy, r8.x);
		r11.z = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r12.zw, r8.x);
		r4.yz = r8.zw * float2(0.75, 0.75) + asfloat(r7.xy);
		r11.w = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r4.yz, r8.x);
		r5 = r11 * r10 + r5;
		r3.y = r3.y + 4;
		r7.xy = r7.zw;
		r8.xy = r9.zw;
	}
	r0.x = asint(dot(r5, float4(1, 1, 1, 1)));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x));
	r0.xyz = asint(asfloat(r0.xxx) * i.texcoord2.xyz);
	o.xyz = asfloat(r0.xyz) * g_fVolumetricLightRayIntensityMult;
	o.w = 0;

	return o;
}
