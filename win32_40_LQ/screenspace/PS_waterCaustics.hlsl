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

cbuffer DeferredLight : register(b1)
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
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	float3 r4;
	float3 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r0 = asint(gbufferTexture0.Load(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + gViewInverse[3].xyz);
	r0.w = asint(-(asfloat(r1.z)) + gDeferredLightVolumeParams.x);
	r1.w = (asfloat(r0.w) < 0) ? -1 : 0;
	if (r1.w != 0) discard;
	r2.xyz = asfloat(r1.yyy) * gShadowMatrix[1].xyz;
	r2.xyz = asfloat(r1.xxx) * gShadowMatrix[0].xyz + r2.xyz;
	r2.xyz = asfloat(r1.zzz) * gShadowMatrix[2].xyz + r2.xyz;
	r1.xy = asint(gDirectionalLight.xy * asfloat(r1.zz) + asfloat(r1.xy));
	r1.xy = asint(asfloat(r1.xy) * gDeferredLightVolumeParams.ww);
	r1.xy = asint(frac(asfloat(r1.xy)));
	r2.xyz = r2.xyz + gShadowMatrix[3].xyz;
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
	r2.xyz = r2.zxy * r4.zxy + r5.zxy;
	r2.x = saturate(r2.x);
	r2.x = -(r2.x) + 0.999999523;
	r2.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r2.yz, r2.x);
	r3.x = asint(-(gCascadeXMinThresholds.w));
	r3.y = asint(-(gCascadeXMaxThresholds.w));
	r1.zw = asint(saturate(abs(asfloat(r1.zw)) * float2(4, 4) + asfloat(r3.xy)));
	r1.z = asint(max(asfloat(r1.w), asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) + r2.x);
	r1.z = asint(asfloat(r1.z) * 1.25);
	r1.z = asint(min(asfloat(r1.z), 1));
	r1.w = asint(asfloat(r1.z) * -2 + 3);
	r1.z = asint(asfloat(r1.z) * asfloat(r1.z));
	r1.z = asint(asfloat(r1.z) * asfloat(r1.w));
	r1.w = asint(saturate(asfloat(r0.w) * gDeferredLightVolumeParams.z));
	r0.w = asint(-(asfloat(r0.w)) * gDeferredLightVolumeParams.y);
	r0.w = asint(asfloat(r0.w) * 1.44269502);
	r0.w = asint(exp2(asfloat(r0.w)));
	r1.w = asint(asfloat(r1.w) * 4);
	r2 = gDeferredLightSampler1_tex.SampleBias(gDeferredLightSampler1, asfloat(r1.xy), asfloat(r1.w));
	r3 = asint(gDeferredLightSampler_tex.SampleBias(gDeferredLightSampler, asfloat(r1.xy), asfloat(r1.w)));
	r1.xyw = asint(r2.xyz + -(asfloat(r3.xyz)));
	r1.xyw = asint(gDeferredLightRadiusProjShearParams.xxx * asfloat(r1.xyw) + asfloat(r3.xyz));
	r1.xyw = asint(asfloat(r1.xyw) * gDeferredLightColourAndIntensity.xyz);
	r1.xyw = asint(asfloat(r1.xyw) * gDeferredLightColourAndIntensity.www);
	r1.xyz = asint(asfloat(r1.zzz) * asfloat(r1.xyw));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	o.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	o.w = 1;

	return o;
}
