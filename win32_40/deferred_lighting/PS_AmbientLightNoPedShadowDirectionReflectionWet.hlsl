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

SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D deferredLightTexture0P : register(t3);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D<uint4> gbufferStencilTexture : register(t11);
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
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	int4 r7;
	float3 r8;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r2 = gbufferStencilTexture.Load(r0.xyw);
	r3 = asint(gbufferTexture0.Load(r0.xyw));
	r4 = asint(gbufferTexture2.Load(r0.xyw));
	r5 = asint(gbufferTexture1.Load(r0.xyw));
	r0 = asint(deferredLightTexture0P.Load(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(16, 16, 16));
	r1.yzw = asint(asfloat(r3.xyz) * asfloat(r3.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord1.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xzw = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + gViewInverse[3].xyz);
	r3.xy = r2.yy & int2(7, 64);
	r1.x = (r3.x == 1) ? -1 : 0;
	r3.x = ~r3.y;
	r2.y = r2.y & r3.x;
	r3.x = asint(asfloat(r4.y) * asfloat(r4.y));
	r3.x = asint(asfloat(r3.x) * asfloat(r3.x));
	r3.y = asint(asfloat(r3.x) * 196);
	r5.xyz = asint(asfloat(r5.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r3.z = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
	r3.z = asint(rsqrt(asfloat(r3.z)));
	r5.xyz = asint(asfloat(r3.zzz) * asfloat(r5.xyz));
	r3.z = asint(saturate(asfloat(r5.z) * 4));
	r3.z = asint(asfloat(r3.z) * dReflectionParams.y);
	r2.y = (r2.y != 0) ? 0 : r3.z;
	r6.xyz = asint(-(asfloat(r2.xzw)) + gViewInverse[3].xyz);
	r3.z = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
	r3.z = asint(rsqrt(asfloat(r3.z)));
	r6.xyz = asint(asfloat(r3.zzz) * asfloat(r6.xyz));
	r3.z = asint(dot(asfloat(r6.xyz), asfloat(r5.xyz)));
	r3.z = asint(-(abs(asfloat(r3.z))) + 1);
	r3.z = asint(max(asfloat(r3.z), 0));
	r3.z = asint(asfloat(r3.z) + 0.00000999999975);
	r3.w = asint(asfloat(r3.z) * asfloat(r3.z));
	r3.w = asint(asfloat(r3.w) * asfloat(r3.w));
	r3.z = asint(asfloat(r3.w) * asfloat(r3.z));
	r3.z = asint(asfloat(r3.z) * 0.800000012 + 0.200000003);
	r3.w = asint(saturate(-(asfloat(r4.x)) + 1));
	r3.w = asint(asfloat(r2.y) * asfloat(r3.w));
	r3.w = asint(asfloat(r3.w) * asfloat(r3.z) + asfloat(r4.x));
	r3.x = asint(-(asfloat(r3.x)) * 196 + 512);
	r3.x = asint(asfloat(r3.x) * 0.001953125);
	r3.x = asint(max(asfloat(r3.x), 0));
	r2.y = asint(asfloat(r2.y) * asfloat(r3.x));
	r2.y = asint(asfloat(r3.z) * asfloat(r2.y));
	r2.y = asint(asfloat(r2.y) * 512 + asfloat(r3.y));
	r3.xyz = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r3.xyz = asint(asfloat(r0.www) * asfloat(r3.xyz));
	r0.w = asint(dot(asfloat(r3.xyz), asfloat(r5.xyz)));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r3.xyz = asint(asfloat(r5.xyz) * -(asfloat(r0.www)) + asfloat(r3.xyz));
	if (r1.x == 0) {
		r0.w = asint(dot(asfloat(r5.xyz), -(gDirectionalLight.xyz)));
		r1.x = asint(saturate(asfloat(r0.w) + -0.25));
		r1.x = asint(asfloat(r1.x) * 1.33333337);
		r4.x = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r3.xyz))));
		r4.x = asint(asfloat(r4.x) + 0.00000999999975);
		r4.y = asint(asfloat(r2.y) + 0.00000999999975);
		r4.x = asint(log2(asfloat(r4.x)));
		r4.x = asint(asfloat(r4.x) * asfloat(r4.y));
		r4.x = asint(exp2(asfloat(r4.x)));
		r0.w = asint(saturate(asfloat(r0.w) * 2 + -0.5));
		r0.w = asint(asfloat(r0.w) * asfloat(r4.x));
		r4.xyw = asint(asfloat(r2.zzz) * gShadowMatrix[1].xyz);
		r4.xyw = asint(asfloat(r2.xxx) * gShadowMatrix[0].xyz + asfloat(r4.xyw));
		r2.xzw = asint(asfloat(r2.www) * gShadowMatrix[2].xyz + asfloat(r4.xyw));
		r2.xzw = asint(asfloat(r2.xzw) + gShadowMatrix[3].xyz);
		r4.xy = asint(asfloat(r2.xz) + -(gShadowParam18192021.zw));
		r6.xy = (asfloat(r4.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
		r6.zw = (gCascadeXMinThresholds.xy >= asfloat(r4.xx)) ? -1 : 0;
		r6 = r6 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r7.xy = (asfloat(r4.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
		r7.zw = (gCascadeYMinThresholds.xy >= asfloat(r4.yy)) ? -1 : 0;
		r7 = r7 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r6.xy = asint(asfloat(r6.zw) + asfloat(r6.xy));
		r6.xy = asint(asfloat(r7.xy) + asfloat(r6.xy));
		r6.xy = asint(asfloat(r7.zw) + asfloat(r6.xy));
		r6.yz = asint(min(asfloat(r6.xy), float2(1, 1)));
		r6.x = 1065353216;
		r7.x = asint(dot(asfloat(r6.xyz), gShadowParam0123.xyz));
		r7.y = asint(dot(asfloat(r6.xyz), gShadowParam4567.xyz));
		r7.z = asint(dot(asfloat(r6.xyz), gCascadeZScales.xyz));
		r8.x = dot(asfloat(r6.xyz), gShadowParam891113.xyz);
		r8.y = dot(asfloat(r6.xyz), gShadowParam14151617.xyz);
		r8.z = dot(asfloat(r6.xyz), gCascadeZOffsets.xyz);
		r2.xzw = asint(asfloat(r2.wxz) * asfloat(r7.zxy) + r8.zxy);
		r2.x = asint(saturate(asfloat(r2.x)));
		r6.x = asint(-(gCascadeXMinThresholds.w));
		r6.y = asint(-(gCascadeXMaxThresholds.w));
		r4.xy = asint(saturate(abs(asfloat(r4.xy)) * float2(4, 4) + asfloat(r6.xy)));
		r4.x = asint(max(asfloat(r4.y), asfloat(r4.x)));
		r2.x = asint(-(asfloat(r2.x)) + 0.999999523);
		r4.yw = int2(0, -2);
		while (true) {
			r5.w = (r4.w >= 3) ? -1 : 0;
			if (r5.w != 0) break;
			r5.w = asint((float)r4.w);
			r6.x = asint(asfloat(r5.w) * gShadowParam18192021.x);
			r5.w = r4.y;
			r6.z = -2;
			while (true) {
				r6.w = (r6.z >= 3) ? -1 : 0;
				if (r6.w != 0) break;
				r6.w = asint((float)r6.z);
				r6.y = asint(asfloat(r6.w) * gShadowParam18192021.y);
				r6.yw = asint(asfloat(r2.zw) + asfloat(r6.xy));
				r6.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r6.yw), asfloat(r2.x)));
				r5.w = asint(asfloat(r5.w) + asfloat(r6.y));
				r6.z = r6.z + 1;
			}
			r4.y = r5.w;
			r4.w = r4.w + 1;
		}
		r2.x = asint(asfloat(r4.y) * 0.0399999991 + asfloat(r4.x));
		r2.x = asint(asfloat(r2.x) * 1.25);
		r2.x = asint(min(asfloat(r2.x), 1));
		r2.z = asint(asfloat(r2.x) * -2 + 3);
		r2.x = asint(asfloat(r2.x) * asfloat(r2.x));
		r2.x = asint(asfloat(r2.x) * asfloat(r2.z));
		r2.xzw = asint(asfloat(r2.xxx) * gDirectionalColour.xyz);
		r4.xyw = asint(asfloat(r0.www) * asfloat(r2.xzw));
		r2.xzw = asint(asfloat(r1.xxx) * asfloat(r2.xzw));
	} else {
		r0.w = asint(dot(asfloat(r5.xyz), -(gDirectionalLight.xyz)));
		r1.x = asint(saturate(asfloat(r0.w) + -0.25));
		r1.x = asint(asfloat(r1.x) * 1.33333337);
		r3.x = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r3.xyz))));
		r3.x = asint(asfloat(r3.x) + 0.00000999999975);
		r2.y = asint(asfloat(r2.y) + 0.00000999999975);
		r3.x = asint(log2(asfloat(r3.x)));
		r2.y = asint(asfloat(r2.y) * asfloat(r3.x));
		r2.y = asint(exp2(asfloat(r2.y)));
		r0.w = asint(saturate(asfloat(r0.w) * 2 + -0.5));
		r0.w = asint(asfloat(r0.w) * asfloat(r2.y));
		r4.xyw = asint(asfloat(r0.www) * gDirectionalColour.xyz);
		r2.xzw = asint(asfloat(r1.xxx) * gDirectionalColour.xyz);
	}
	r0.w = asint(sqrt(asfloat(r4.z)));
	r1.x = asint(dot(gLightAmbientDir0.xyz, asfloat(r5.xyz)));
	r1.x = asint(saturate(asfloat(r1.x) + gLightAmbientDir0.w));
	r2.y = asint(dot(gLightAmbientDir1.xyz, asfloat(r5.xyz)));
	r2.y = asint(saturate(asfloat(r2.y) + gLightAmbientDir0.w));
	r3.xyz = asint(asfloat(r2.yyy) * gLightAmbient1.xyz);
	r3.xyz = asint(asfloat(r1.xxx) * gLightAmbient0.xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r4.zzz) * asfloat(r3.xyz));
	r2.xyz = asint(asfloat(r2.xzw) * asfloat(r0.www) + asfloat(r3.xyz));
	r0.w = asint(dot(asfloat(r2.xyz), float3(0.333333343, 0.333333343, 0.333333343)));
	r0.w = asint(asfloat(r0.w) + 0.0149999997);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r4.xyw) * asfloat(r3.www) + asfloat(r0.xyz));
	o.xyz = asfloat(r1.yzw) * asfloat(r2.xyz) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
