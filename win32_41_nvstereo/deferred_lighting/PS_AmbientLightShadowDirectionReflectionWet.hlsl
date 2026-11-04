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

SamplerState StereoParmsTex : register(s9);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D<uint4> gbufferStencilTexture : register(t2);
Texture2D deferredLightTexture0P : register(t3);
Texture2D gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
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
	float4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	float3 r7;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.y = gbufferStencilTexture.Load(r0.xyw).y;
	r2.xyz = gbufferTexture0.Load(r0.xyw).xyz;
	r3.xyz = asint(gbufferTexture2.Load(r0.xyw).xyz);
	r4.xyz = asint(gbufferTexture1.Load(r0.xyw).xyz);
	r0.xyz = asint(deferredLightTexture0P.Load(r0.xyz).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(16, 16, 16));
	r2.xyz = r2.xyz * r2.xyz;
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord1.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r1.zw = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(-(asfloat(r1.w)) + asfloat(r1.x));
		r1.x = asint(asfloat(r1.x) * asfloat(r1.z));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r1.xzw = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r5.xyz = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz);
		r1.xzw = asint(asfloat(r5.xyz) + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord1.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xzw = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + asfloat(r1.xzw));
	r0.w = r1.y & 64;
	r0.w = ~r0.w;
	r0.w = r0.w & r1.y;
	r1.y = asint(asfloat(r3.y) * asfloat(r3.y));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r2.w = asfloat(r1.y) * 196;
	r4.xyz = asint(asfloat(r4.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r3.y = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r3.y = asint(rsqrt(asfloat(r3.y)));
	r4.xyz = asint(asfloat(r3.yyy) * asfloat(r4.xyz));
	r3.y = asint(saturate(asfloat(r4.z) * 4));
	r3.y = asint(asfloat(r3.y) * dReflectionParams.y);
	r0.w = (r0.w != 0) ? 0 : r3.y;
	r5.xyz = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz);
	r5.xyz = asint(asfloat(r5.xyz) + gViewInverse[3].xyz);
	r6.xyz = asint(-(asfloat(r1.xzw)) + asfloat(r5.xyz));
	r3.y = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
	r3.y = asint(rsqrt(asfloat(r3.y)));
	r6.xyz = asint(asfloat(r3.yyy) * asfloat(r6.xyz));
	r3.y = asint(dot(asfloat(r6.xyz), asfloat(r4.xyz)));
	r3.y = asint(-(abs(asfloat(r3.y))) + 1);
	r3.y = asint(max(asfloat(r3.y), 0));
	r3.y = asint(asfloat(r3.y) + 0.00000999999975);
	r3.w = asint(asfloat(r3.y) * asfloat(r3.y));
	r3.w = asint(asfloat(r3.w) * asfloat(r3.w));
	r3.y = asint(asfloat(r3.w) * asfloat(r3.y));
	r3.y = asint(asfloat(r3.y) * 0.800000012 + 0.200000003);
	r3.w = asint(saturate(-(asfloat(r3.x)) + 1));
	r3.w = asint(asfloat(r0.w) * asfloat(r3.w));
	r3.x = asint(asfloat(r3.w) * asfloat(r3.y) + asfloat(r3.x));
	r1.y = asint(-(asfloat(r1.y)) * 196 + 512);
	r1.y = asint(asfloat(r1.y) * 0.001953125);
	r1.y = asint(max(asfloat(r1.y), 0));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.y));
	r0.w = asint(asfloat(r3.y) * asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * 512 + r2.w);
	r5.xyz = asint(asfloat(r1.xzw) + -(asfloat(r5.xyz)));
	r5.xyz = asint(asfloat(r5.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.y = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r5.xyz = asint(asfloat(r1.yyy) * asfloat(r5.xyz));
	r1.y = asint(dot(asfloat(r5.xyz), asfloat(r4.xyz)));
	r1.y = asint(asfloat(r1.y) + asfloat(r1.y));
	r5.xyz = asint(asfloat(r4.xyz) * -(asfloat(r1.yyy)) + asfloat(r5.xyz));
	r1.y = asint(dot(asfloat(r4.xyz), -(gDirectionalLight.xyz)));
	r2.w = saturate(asfloat(r1.y) + -0.25);
	r2.w = r2.w * 1.33333337;
	r3.y = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r5.xyz))));
	r3.y = asint(asfloat(r3.y) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r3.y = asint(log2(asfloat(r3.y)));
	r0.w = asint(asfloat(r0.w) * asfloat(r3.y));
	r0.w = asint(exp2(asfloat(r0.w)));
	r1.y = asint(saturate(asfloat(r1.y) * 2 + -0.5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.y));
	r5.xyz = asint(asfloat(r1.zzz) * gShadowMatrix[1].xyz);
	r1.xyz = asint(asfloat(r1.xxx) * gShadowMatrix[0].xyz + asfloat(r5.xyz));
	r1.xyz = asint(asfloat(r1.www) * gShadowMatrix[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + gShadowMatrix[3].xyz);
	r3.yw = asint(asfloat(r1.xy) + -(gShadowParam18192021.zw));
	r5.xy = (asfloat(r3.yy) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r5.zw = (gCascadeXMinThresholds.xy >= asfloat(r3.yy)) ? -1 : 0;
	r5 = r5 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r6.xy = (asfloat(r3.ww) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r6.zw = (gCascadeYMinThresholds.xy >= asfloat(r3.ww)) ? -1 : 0;
	r6 = r6 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r5.xy = asint(asfloat(r5.zw) + asfloat(r5.xy));
	r5.xy = asint(asfloat(r6.xy) + asfloat(r5.xy));
	r5.xy = asint(asfloat(r6.zw) + asfloat(r5.xy));
	r5.yz = asint(min(asfloat(r5.xy), float2(1, 1)));
	r5.x = 1065353216;
	r6.x = asint(dot(asfloat(r5.xyz), gShadowParam0123.xyz));
	r6.y = asint(dot(asfloat(r5.xyz), gShadowParam4567.xyz));
	r6.z = asint(dot(asfloat(r5.xyz), gCascadeZScales.xyz));
	r7.x = dot(asfloat(r5.xyz), gShadowParam891113.xyz);
	r7.y = dot(asfloat(r5.xyz), gShadowParam14151617.xyz);
	r7.z = dot(asfloat(r5.xyz), gCascadeZOffsets.xyz);
	r1.xyz = asint(asfloat(r1.zxy) * asfloat(r6.zxy) + r7.zxy);
	r1.x = asint(saturate(asfloat(r1.x)));
	r5.x = asint(-(gCascadeXMinThresholds.w));
	r5.y = asint(-(gCascadeXMaxThresholds.w));
	r3.yw = asint(saturate(abs(asfloat(r3.yw)) * float2(4, 4) + asfloat(r5.xy)));
	r1.w = asint(max(asfloat(r3.w), asfloat(r3.y)));
	r1.x = asint(-(asfloat(r1.x)) + 0.999999523);
	r3.yw = int2(0, -2);
	while (true) {
		r4.w = (r3.w >= 3) ? -1 : 0;
		if (r4.w != 0) break;
		r4.w = asint((float)r3.w);
		r5.x = asint(asfloat(r4.w) * gShadowParam18192021.x);
		r4.w = r3.y;
		r5.z = -2;
		while (true) {
			r5.w = (r5.z >= 3) ? -1 : 0;
			if (r5.w != 0) break;
			r5.w = asint((float)r5.z);
			r5.y = asint(asfloat(r5.w) * gShadowParam18192021.y);
			r5.yw = asint(asfloat(r1.yz) + asfloat(r5.xy));
			r5.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r5.yw), asfloat(r1.x)));
			r4.w = asint(asfloat(r4.w) + asfloat(r5.y));
			r5.z = r5.z + 1;
		}
		r3.y = r4.w;
		r3.w = r3.w + 1;
	}
	r1.x = asint(asfloat(r3.y) * 0.0399999991 + asfloat(r1.w));
	r1.x = asint(asfloat(r1.x) * 1.25);
	r1.x = asint(min(asfloat(r1.x), 1));
	r1.y = asint(asfloat(r1.x) * -2 + 3);
	r1.x = asint(asfloat(r1.x) * asfloat(r1.x));
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r1.xyz = asint(asfloat(r1.xxx) * gDirectionalColour.xyz);
	r5.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r1.xyz = asint(r2.www * asfloat(r1.xyz));
	r0.w = asint(sqrt(asfloat(r3.z)));
	r1.w = asint(dot(gLightAmbientDir0.xyz, asfloat(r4.xyz)));
	r1.w = asint(saturate(asfloat(r1.w) + gLightAmbientDir0.w));
	r2.w = dot(gLightAmbientDir1.xyz, asfloat(r4.xyz));
	r2.w = saturate(r2.w + gLightAmbientDir0.w);
	r4.xyz = asint(r2.www * gLightAmbient1.xyz);
	r4.xyz = asint(asfloat(r1.www) * gLightAmbient0.xyz + asfloat(r4.xyz));
	r3.yzw = asint(asfloat(r3.zzz) * asfloat(r4.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r0.www) + asfloat(r3.yzw));
	r0.w = asint(dot(asfloat(r1.xyz), float3(0.333333343, 0.333333343, 0.333333343)));
	r0.w = asint(asfloat(r0.w) + 0.0149999997);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r5.xyz) * asfloat(r3.xxx) + asfloat(r0.xyz));
	o.xyz = r2.xyz * asfloat(r1.xyz) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
