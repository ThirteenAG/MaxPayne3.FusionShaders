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

SamplerState gDeferredLightSampler : register(s0);
SamplerState StereoParmsTex : register(s9);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2DMS<float> gbufferTextureDepth : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	float4 r4;
	float3 r5;
	float3 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r2.xy = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xy;
	r0.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2.zw = StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy;
		r1.x = asint(asfloat(r1.x) + -(r2.w));
		r1.x = asint(asfloat(r1.x) * r2.z);
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r3.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r4.xyz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r3.xyz = asint(r4.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r3.xyz));
	r0.w = asint(r2.y * r2.y);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r2.yzw = asfloat(r3.xyz) + -(i.texcoord2.xyz);
	r4.xyz = -(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx;
	r4.xyz = -(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(r4.xyz);
	r4.x = dot(r4.xyz, r2.yzw);
	r4.y = dot(gDeferredLightTangent.xyz, r2.yzw);
	r1.x = asint(dot(-(gDeferredLightDirection.xyz), r2.yzw));
	r3.w = (gDeferredLightType == 2) ? -1 : 0;
	r4.z = abs(gDeferredLightConeOffset) + 60;
	r4.z = 120 / r4.z;
	r4.z = r4.z * gDeferredLightConeAngle;
	r4.z = r4.z * r4.z;
	r4.z = asfloat(r1.x) * r4.z;
	r4.z = -1 / r4.z;
	r4.zw = r4.zz * r4.xy;
	r2.y = dot(r2.yzw, r2.yzw);
	r2.y = sqrt(r2.y);
	r1.x = asint(asfloat(r1.x) / r2.y);
	r1.x = asint(-(asfloat(r1.x)) + 1);
	r1.x = asint(asfloat(r1.x) * r2.y);
	r1.x = asint(1 / asfloat(r1.x));
	r2.yz = asfloat(r1.xx) * r4.xy;
	r2.yz = (r3.ww != 0) ? r4.zw : r2.yz;
	r2.yz = r2.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
	r2.yzw = gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, r2.yz, 0).xyz;
	r4.xyz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r4.xyz = r4.xyz + gViewInverse[3].xyz;
	r4.xyz = asfloat(r3.xyz) + -(r4.xyz);
	r4.xyz = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r4.xyz, r4.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r4.xyz = asfloat(r1.xxx) * r4.xyz;
	r5 = -(asfloat(r3.xyz)) + i.texcoord2.xyz;
	r1.x = asint(dot(r5.xyz, r5.xyz));
	r5 = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = asint(dot(r5.xyz, r5.xyz));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r5 = asfloat(r3.www) * r5.xyz;
	r1.x = asint(saturate(-(asfloat(r1.x)) * i.texcoord1.y + 1));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * 4.00001001);
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) + -0.100000001);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(asfloat(r1.x) * 1.11111116);
	r6 = asfloat(r1.xxx) * i.texcoord4.xyz;
	r1.x = asint(dot(r5.xyz, i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r6 = asfloat(r1.xxx) * r6.xyz;
	r7 = asfloat(r3.y) * gShadowMatrix[1];
	r7 = asfloat(r3.x) * gShadowMatrix[0] + r7;
	r3 = asint(asfloat(r3.z) * gShadowMatrix[2] + r7);
	r3 = asint(asfloat(r3) + gShadowMatrix[3]);
	r3.xyz = asint(asfloat(r3.xyz) / asfloat(r3.www));
	r3.xy = asint(asfloat(r3.xy) + float2(1, 1));
	r7.x = asfloat(r3.x) * 0.5;
	r1.x = asint(asfloat(r3.z) + -(gShadowParam0123.x));
	r3.z = asint(gShadowParam0123.z * 0.5);
	r7.z = -(asfloat(r3.y)) * 0.5 + 1;
	r8.xyw = -(gShadowParam0123.zww) * float3(0.5, 0.5, 0.5) + r7.xzz;
	r9.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.xy, asfloat(r1.x));
	r8.z = asfloat(r3.x) * 0.5 + asfloat(r3.z);
	r9.y = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.zw, asfloat(r1.x));
	r3.x = asint(asfloat(r3.x) * 0.5 + -(asfloat(r3.z)));
	r3.yzw = asint(gShadowParam0123.wzw * float3(0.5, 0.5, 0.5) + r7.zxz);
	r9.z = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r3.xy), asfloat(r1.x));
	r9.w = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r3.zw), asfloat(r1.x));
	r1.x = asint(dot(r9, float4(0.25, 0.25, 0.25, 0.25)));
	r3.x = asint(-(gShadowParam0123.y) + 1);
	r1.x = asint(asfloat(r1.x) * asfloat(r3.x) + gShadowParam0123.y);
	r3.xyz = asint(asfloat(r1.xxx) * r6.xyz);
	r1.x = asint(dot(r4.xyz, asfloat(r0.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r4.xyz = asfloat(r0.xyz) * -(asfloat(r1.xxx)) + r4.xyz;
	r1.x = asint(saturate(dot(r5.xyz, r4.xyz)));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(saturate(dot(r5.xyz, asfloat(r0.xyz))));
	r0.y = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w));
	r0.yzw = asint(asfloat(r0.yyy) * asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r0.xxx) * asfloat(r3.xyz));
	r1.xyz = asint(asfloat(r1.yzw) * r2.yzw);
	r0.xyz = asint(r2.xxx * asfloat(r0.yzw));
	o.xyz = asfloat(r1.xyz) * asfloat(r3.xyz) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
