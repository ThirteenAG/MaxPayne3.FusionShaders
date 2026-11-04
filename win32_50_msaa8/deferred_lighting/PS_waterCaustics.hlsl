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
	float4 gDeferredLightShaftParams : packoffset(c9);
	float4 gDeferredLightVolumeParams : packoffset(c10);
};

SamplerState gDeferredLightSampler : register(s0);
SamplerState gDeferredLightSampler1 : register(s1);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D gDeferredLightSampler1_tex : register(t1);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float3 r2;
	int4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, 0).x);
	r0.xyz = asint(gbufferTexture0.Load(r0.xy, 0).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + gViewInverse[3].xyz);
	r0.w = asint(-(asfloat(r1.z)) + gDeferredLightVolumeParams.x);
	r1.w = (asfloat(r0.w) < 0) ? -1 : 0;
	if (r1.w != 0) discard;
	r2 = asfloat(r1.yyy) * gShadowMatrix[1].xyz;
	r2 = asfloat(r1.xxx) * gShadowMatrix[0].xyz + r2.xyz;
	r2 = asfloat(r1.zzz) * gShadowMatrix[2].xyz + r2.xyz;
	r1.xy = asint(gDirectionalLight.xy * asfloat(r1.zz) + asfloat(r1.xy));
	r1.xy = asint(asfloat(r1.xy) * gDeferredLightVolumeParams.ww);
	r1.xy = asint(frac(asfloat(r1.xy)));
	r2 = r2.xyz + gShadowMatrix[3].xyz;
	r1.zw = asint(r2.xy + -(gShadowParam18192021.zw));
	r3.xy = (asfloat(r1.zz) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r3.zw = (gCascadeXMinThresholds.xy >= asfloat(r1.zz)) ? -1 : 0;
	r3 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r3.xy = asint(asfloat(r3.zw) + asfloat(r3.xy));
	r3.zw = (asfloat(r1.ww) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r3.zw = r3.zw & int2(1065353216, 1065353216);
	r3.xy = asint(asfloat(r3.zw) + asfloat(r3.xy));
	r3.zw = (gCascadeYMinThresholds.xy >= asfloat(r1.ww)) ? -1 : 0;
	r3.zw = r3.zw & int2(1065353216, 1065353216);
	r3.xy = asint(asfloat(r3.zw) + asfloat(r3.xy));
	r3.yz = asint(min(asfloat(r3.xy), float2(1, 1)));
	r3.x = 1065353216;
	r4.x = dot(asfloat(r3.xyz), gShadowParam0123.xyz);
	r4.y = dot(asfloat(r3.xyz), gShadowParam4567.xyz);
	r4.z = dot(asfloat(r3.xyz), gCascadeZScales.xyz);
	r5.x = dot(asfloat(r3.xyz), gShadowParam891113.xyz);
	r5.y = dot(asfloat(r3.xyz), gShadowParam14151617.xyz);
	r5.z = dot(asfloat(r3.xyz), gCascadeZOffsets.xyz);
	r2 = r2.zxy * r4.zxy + r5.zxy;
	r3.xy = asint(r2.yz + gShadowParam18192021.xy);
	r4 = asfloat(r3.xxyy) / gShadowParam18192021.xxyy;
	r4 = frac(r4);
	r3.zw = (float2(0.5, 0.5) < r4.yw) ? -1 : 0;
	r4 = r4 + float4(-0.5, 0.5, -0.5, 0.5);
	r3.zw = asint((r3.zw != 0) ? r4.xz : r4.yw);
	r4.xy = r2.yz + -(gShadowParam18192021.xy);
	r2.x = saturate(r2.x);
	r5 = gShadowParam18192021.xyxy * float4(-1, 1, 1, -1) + r2.yzyz;
	r2.x = -(r2.x) + 0.999999523;
	r4 = ShadowZTextureDir.GatherCmp(gShadowZSamplerDir, r4.xy, r2.x).zxyw;
	r2.yz = -(r4.wx) + r4.yz;
	r2.yz = asfloat(r3.ww) * r2.yz + r4.wx;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r6 = ShadowZTextureDir.GatherCmp(gShadowZSamplerDir, r5.xy, r2.x).zxyw;
	r5 = ShadowZTextureDir.GatherCmp(gShadowZSamplerDir, r5.zw, r2.x);
	r7 = ShadowZTextureDir.GatherCmp(gShadowZSamplerDir, asfloat(r3.xy), r2.x);
	r2.xz = -(r6.wx) + r6.yz;
	r2.xz = asfloat(r3.ww) * r2.xz + r6.wx;
	r2.z = -(r2.x) + r2.z;
	r2.x = asfloat(r3.z) * r2.z + r2.x;
	r2.x = r2.x + r2.y;
	r2.yz = -(r5.wz) + r5.xy;
	r2.yz = asfloat(r3.ww) * r2.yz + r5.wz;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r7.wz) + r7.xy;
	r2.yz = asfloat(r3.ww) * r2.yz + r7.wz;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r4.yz) + r6.wx;
	r2.yz = asfloat(r3.ww) * r2.yz + r4.yz;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r5.xy) + r7.wz;
	r6.yw = r7.wx;
	r2.yz = asfloat(r3.ww) * r2.yz + r5.xy;
	r4.yw = r5.wx;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r4.xy) + r4.zw;
	r2.yz = asfloat(r3.ww) * r2.yz + r4.xy;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r4.zw) + r6.xy;
	r2.yz = asfloat(r3.ww) * r2.yz + r4.zw;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r2.yz = -(r6.xy) + r6.zw;
	r2.yz = asfloat(r3.ww) * r2.yz + r6.xy;
	r2.z = -(r2.y) + r2.z;
	r2.y = asfloat(r3.z) * r2.z + r2.y;
	r2.x = r2.y + r2.x;
	r3.x = asint(-(gCascadeXMinThresholds.w));
	r3.y = asint(-(gCascadeXMaxThresholds.w));
	r1.zw = asint(saturate(abs(asfloat(r1.zw)) * float2(4, 4) + asfloat(r3.xy)));
	r1.z = asint(max(asfloat(r1.w), asfloat(r1.z)));
	r1.z = asint(r2.x * 0.111111112 + asfloat(r1.z));
	r1.z = asint(saturate(asfloat(r1.z) * 1.25));
	r1.w = asint(asfloat(r1.z) * -2 + 3);
	r1.z = asint(asfloat(r1.z) * asfloat(r1.z));
	r1.z = asint(asfloat(r1.z) * asfloat(r1.w));
	r1.w = asint(saturate(asfloat(r0.w) * gDeferredLightVolumeParams.z));
	r0.w = asint(-(asfloat(r0.w)) * gDeferredLightVolumeParams.y);
	r0.w = asint(asfloat(r0.w) * 1.44269502);
	r0.w = asint(exp2(asfloat(r0.w)));
	r1.w = asint(asfloat(r1.w) * 4);
	r2 = gDeferredLightSampler1_tex.SampleBias(gDeferredLightSampler1, asfloat(r1.xy), asfloat(r1.w)).xyz;
	r1.xyw = asint(gDeferredLightSampler_tex.SampleBias(gDeferredLightSampler, asfloat(r1.xy), asfloat(r1.w)).xyz);
	r2 = -(asfloat(r1.xyw)) + r2.xyz;
	r1.xyw = asint(gDeferredLightRadiusProjShearParams.xxx * r2.xyz + asfloat(r1.xyw));
	r1.xyw = asint(asfloat(r1.xyw) * gDeferredLightColourAndIntensity.xyz);
	r1.xyw = asint(asfloat(r1.xyw) * gDeferredLightColourAndIntensity.www);
	r1.xyz = asint(asfloat(r1.zzz) * asfloat(r1.xyw));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	o.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	o.w = 1;

	return o;
}
