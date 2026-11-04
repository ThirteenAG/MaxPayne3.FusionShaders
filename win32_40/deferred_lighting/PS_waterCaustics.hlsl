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
	int4 r2;
	int4 r3;
	int4 r4;
	int3 r5;
	float3 r6;
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
	r2.xy = asint(gDirectionalLight.xy * asfloat(r1.zz) + asfloat(r1.xy));
	r0.w = asint(-(asfloat(r1.z)) + gDeferredLightVolumeParams.x);
	r1.w = (asfloat(r0.w) < 0) ? -1 : 0;
	if (r1.w != 0) discard;
	r1.w = asint(saturate(asfloat(r0.w) * gDeferredLightVolumeParams.z));
	r2.xy = asint(asfloat(r2.xy) * gDeferredLightVolumeParams.ww);
	r2.xy = asint(frac(asfloat(r2.xy)));
	r1.w = asint(asfloat(r1.w) * 4);
	r3 = asint(gDeferredLightSampler_tex.SampleBias(gDeferredLightSampler, asfloat(r2.xy), asfloat(r1.w)));
	r2 = asint(gDeferredLightSampler1_tex.SampleBias(gDeferredLightSampler1, asfloat(r2.xy), asfloat(r1.w)));
	r2.xyz = asint(-(asfloat(r3.xyz)) + asfloat(r2.xyz));
	r2.xyz = asint(gDeferredLightRadiusProjShearParams.xxx * asfloat(r2.xyz) + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r1.yyy) * gShadowMatrix[1].xyz);
	r1.xyw = asint(asfloat(r1.xxx) * gShadowMatrix[0].xyz + asfloat(r3.xyz));
	r1.xyz = asint(asfloat(r1.zzz) * gShadowMatrix[2].xyz + asfloat(r1.xyw));
	r1.xyz = asint(asfloat(r1.xyz) + gShadowMatrix[3].xyz);
	r3.xy = asint(asfloat(r1.xy) + -(gShadowParam18192021.zw));
	r3.zw = (asfloat(r3.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r3.zw = r3.zw & int2(1065353216, 1065353216);
	r4.xy = (gCascadeXMinThresholds.xy >= asfloat(r3.xx)) ? -1 : 0;
	r4.zw = (asfloat(r3.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r4 = r4 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r5.xy = (gCascadeYMinThresholds.xy >= asfloat(r3.yy)) ? -1 : 0;
	r5.xy = r5.xy & int2(1065353216, 1065353216);
	r3.zw = asint(asfloat(r3.zw) + asfloat(r4.xy));
	r3.zw = asint(asfloat(r4.zw) + asfloat(r3.zw));
	r3.zw = asint(asfloat(r5.xy) + asfloat(r3.zw));
	r4.yz = asint(min(asfloat(r3.zw), float2(1, 1)));
	r4.x = 1065353216;
	r5.x = asint(dot(asfloat(r4.xyz), gShadowParam0123.xyz));
	r5.y = asint(dot(asfloat(r4.xyz), gShadowParam4567.xyz));
	r5.z = asint(dot(asfloat(r4.xyz), gCascadeZScales.xyz));
	r6.x = dot(asfloat(r4.xyz), gShadowParam891113.xyz);
	r6.y = dot(asfloat(r4.xyz), gShadowParam14151617.xyz);
	r6.z = dot(asfloat(r4.xyz), gCascadeZOffsets.xyz);
	r1.xyz = asint(asfloat(r1.zxy) * asfloat(r5.zxy) + r6.zxy);
	r1.x = asint(saturate(asfloat(r1.x)));
	r4.x = asint(-(gCascadeXMinThresholds.w));
	r4.y = asint(-(gCascadeXMaxThresholds.w));
	r3.xy = asint(saturate(abs(asfloat(r3.xy)) * float2(4, 4) + asfloat(r4.xy)));
	r1.w = asint(max(asfloat(r3.y), asfloat(r3.x)));
	r1.x = asint(-(asfloat(r1.x)) + 0.999999523);
	r2.w = 0;
	r3.x = -2;
	while (true) {
		r3.y = (r3.x >= 3) ? -1 : 0;
		if (r3.y != 0) break;
		r3.y = asint((float)r3.x);
		r4.x = asint(asfloat(r3.y) * gShadowParam18192021.x);
		r3.y = r2.w;
		r3.z = -2;
		while (true) {
			r3.w = (r3.z >= 3) ? -1 : 0;
			if (r3.w != 0) break;
			r3.w = asint((float)r3.z);
			r4.y = asint(asfloat(r3.w) * gShadowParam18192021.y);
			r4.yz = asint(asfloat(r1.yz) + asfloat(r4.xy));
			r3.w = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r4.yz), asfloat(r1.x)));
			r3.y = asint(asfloat(r3.w) + asfloat(r3.y));
			r3.z = r3.z + 1;
		}
		r2.w = r3.y;
		r3.x = r3.x + 1;
	}
	r1.x = asint(asfloat(r2.w) * 0.0399999991 + asfloat(r1.w));
	r1.x = asint(asfloat(r1.x) * 1.25);
	r1.x = asint(min(asfloat(r1.x), 1));
	r1.y = asint(asfloat(r1.x) * -2 + 3);
	r1.x = asint(asfloat(r1.x) * asfloat(r1.x));
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r1.yzw = asint(asfloat(r2.xyz) * gDeferredLightColourAndIntensity.xyz);
	r1.yzw = asint(asfloat(r1.yzw) * gDeferredLightColourAndIntensity.www);
	r1.xyz = asint(asfloat(r1.xxx) * asfloat(r1.yzw));
	r0.w = asint(-(asfloat(r0.w)) * gDeferredLightVolumeParams.y);
	r0.w = asint(asfloat(r0.w) * 1.44269502);
	r0.w = asint(exp2(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	o.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	o.w = 1;

	return o;
}
