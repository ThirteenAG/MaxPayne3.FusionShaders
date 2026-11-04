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

SamplerState StereoParmsTex : register(s9);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2DMS<float4> deferredLightTexture0P : register(t3);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2DMS<float> gbufferTextureDepth : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	float3 r5;
	float2 r6;
	float3 r7;
	float3 r8;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r2.xyz = asint(gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xyz);
	r3.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(deferredLightTexture0P.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(16, 16, 16));
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord1.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r4.xy = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(asfloat(r1.x) + -(asfloat(r4.y)));
		r1.x = asint(asfloat(r1.x) * asfloat(r4.x));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r4.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r5 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r4.xyz = asint(r5.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord1.w);
	r0.w = asint(1 / asfloat(r0.w));
	r4.xyz = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + asfloat(r4.xyz));
	r0.w = asint(asfloat(r2.y) * asfloat(r2.y));
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r3.xyz = asint(asfloat(r3.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3.xyz = asint(asfloat(r1.xxx) * asfloat(r3.xyz));
	r5 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r5 = r5.xyz + gViewInverse[3].xyz;
	r5 = asfloat(r4.xyz) + -(r5.xyz);
	r5 = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r5.xyz, r5.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r5 = asfloat(r1.xxx) * r5.xyz;
	r1.x = asint(dot(r5.xyz, asfloat(r3.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r5 = asfloat(r3.xyz) * -(asfloat(r1.xxx)) + r5.xyz;
	r1.x = asint(dot(asfloat(r3.xyz), -(gDirectionalLight.xyz)));
	r2.y = asint(saturate(asfloat(r1.x) + -0.25));
	r2.y = asint(asfloat(r2.y) * 1.33333337);
	r2.w = asint(saturate(dot(-(gDirectionalLight.xyz), r5.xyz)));
	r2.w = asint(asfloat(r2.w) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r2.w = asint(log2(asfloat(r2.w)));
	r0.w = asint(asfloat(r0.w) * asfloat(r2.w));
	r0.w = asint(exp2(asfloat(r0.w)));
	r1.x = asint(saturate(asfloat(r1.x) * 2 + -0.5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r5 = asfloat(r4.yyy) * gShadowMatrix[1].xyz;
	r4.xyw = asint(asfloat(r4.xxx) * gShadowMatrix[0].xyz + r5.xyz);
	r4.xyz = asint(asfloat(r4.zzz) * gShadowMatrix[2].xyz + asfloat(r4.xyw));
	r4.xyz = asint(asfloat(r4.xyz) + gShadowMatrix[3].xyz);
	r5.xy = asfloat(r4.xy) + -(gShadowParam18192021.zw);
	r1.x = (r5.x >= gCascadeXMaxThresholds.x) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r2.w = (gCascadeXMinThresholds.x >= r5.x) ? -1 : 0;
	r2.w = r2.w & 1065353216;
	r3.w = (r5.y >= gCascadeYMaxThresholds.x) ? -1 : 0;
	r3.w = r3.w & 1065353216;
	r4.w = (gCascadeYMinThresholds.x >= r5.y) ? -1 : 0;
	r4.w = r4.w & 1065353216;
	r1.x = asint(asfloat(r1.x) + asfloat(r2.w));
	r1.x = asint(asfloat(r3.w) + asfloat(r1.x));
	r1.x = asint(asfloat(r4.w) + asfloat(r1.x));
	r6.y = min(asfloat(r1.x), 1);
	r6.x = 1;
	r7.x = dot(r6.xy, gShadowParam0123.xy);
	r7.y = dot(r6.xy, gShadowParam4567.xy);
	r7.z = dot(r6.xy, gCascadeZScales.xy);
	r8.x = dot(r6.xy, gShadowParam891113.xy);
	r8.y = dot(r6.xy, gShadowParam14151617.xy);
	r8.z = dot(r6.xy, gCascadeZOffsets.xy);
	r4.xyz = asint(asfloat(r4.zxy) * r7.zxy + r8.zxy);
	r4.x = asint(saturate(asfloat(r4.x)));
	r1.x = asint(-(asfloat(r4.x)) + 1);
	r1.x = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r4.yz), asfloat(r1.x)));
	r4.x = asint(-(gCascadeXMinThresholds.w));
	r4.y = asint(-(gCascadeXMaxThresholds.w));
	r4.xy = asint(saturate(abs(r5.xy) * float2(4, 4) + asfloat(r4.xy)));
	r2.w = asint(max(asfloat(r4.y), asfloat(r4.x)));
	r1.x = asint(asfloat(r1.x) + asfloat(r2.w));
	r1.x = asint(min(asfloat(r1.x), 1));
	r4.xyz = asint(asfloat(r1.xxx) * gDirectionalColour.xyz);
	r5 = asfloat(r0.www) * asfloat(r4.xyz);
	r4.xyz = asint(asfloat(r2.yyy) * asfloat(r4.xyz));
	r0.w = asint(sqrt(asfloat(r2.z)));
	r1.x = asint(dot(gLightAmbientDir0.xyz, asfloat(r3.xyz)));
	r1.x = asint(saturate(asfloat(r1.x) + gLightAmbientDir0.w));
	r2.y = asint(dot(gLightAmbientDir1.xyz, asfloat(r3.xyz)));
	r2.y = asint(saturate(asfloat(r2.y) + gLightAmbientDir0.w));
	r3.xyz = asint(asfloat(r2.yyy) * gLightAmbient1.xyz);
	r3.xyz = asint(asfloat(r1.xxx) * gLightAmbient0.xyz + asfloat(r3.xyz));
	r2.yzw = asint(asfloat(r2.zzz) * asfloat(r3.xyz));
	r2.yzw = asint(asfloat(r4.xyz) * asfloat(r0.www) + asfloat(r2.yzw));
	r0.w = asint(dot(asfloat(r2.yzw), float3(0.333333343, 0.333333343, 0.333333343)));
	r0.w = asint(asfloat(r0.w) + 0.0149999997);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(r5.xyz * asfloat(r2.xxx) + asfloat(r0.xyz));
	o.xyz = asfloat(r1.yzw) * asfloat(r2.yzw) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
