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
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xyw).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.yzw = -(i.texcoord.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2.xyz = -(i.texcoord.xyz) * r1.xxx + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3 = r1.z * gShadowMatrix[1];
	r3 = r1.y * gShadowMatrix[0] + r3;
	r3 = r1.w * gShadowMatrix[2] + r3;
	r3 = r3 + gShadowMatrix[3];
	r3.xyz = r3.xyz / r3.www;
	r3.xy = r3.xy + float2(1, 1);
	r1.x = r3.z + -(gShadowParam0123.x);
	r2.w = gShadowParam0123.z * 0.5;
	r4.z = r3.x * 0.5 + r2.w;
	r5.x = r3.x * 0.5 + -(r2.w);
	r3.x = r3.x * 0.5;
	r3.z = -(r3.y) * 0.5 + 1;
	r4.xyw = -(gShadowParam0123.zww) * float3(0.5, 0.5, 0.5) + r3.xzz;
	r5.yzw = gShadowParam0123.wzw * float3(0.5, 0.5, 0.5) + r3.zxz;
	r3.y = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r4.zw, r1.x);
	r3.x = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r4.xy, r1.x);
	r3.z = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r5.xy, r1.x);
	r3.w = ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r5.zw, r1.x);
	r1.x = dot(r3, float4(0.25, 0.25, 0.25, 0.25));
	r2.w = -(gShadowParam0123.y) + 1;
	r1.x = r1.x * r2.w + gShadowParam0123.y;
	r3.xyz = -(r1.yzw) + i.texcoord2.xyz;
	r1.yzw = r1.yzw + -(i.texcoord2.xyz);
	r2.w = dot(r3.xyz, r3.xyz);
	r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = saturate(-(r2.w) * i.texcoord1.y + 1);
	r2.w = r2.w + 0.00000999999975;
	r2.w = log2(r2.w);
	r2.w = r2.w * 4.00001001;
	r2.w = exp2(r2.w);
	r2.w = r2.w + -0.100000001;
	r2.w = max(r2.w, 0);
	r2.w = r2.w * 1.11111116;
	r4.xyz = r2.www * i.texcoord4.xyz;
	r2.w = dot(r3.xyz, r3.xyz);
	r2.w = rsqrt(r2.w);
	r3.xyz = r2.www * r3.xyz;
	r2.w = dot(r3.xyz, i.texcoord3.xyz);
	r2.w = saturate(r2.w * i.texcoord1.w + i.texcoord1.z);
	r4.xyz = r2.www * r4.xyz;
	r4.xyz = r1.xxx * r4.xyz;
	r1.x = dot(r2.xyz, r2.xyz);
	r1.x = rsqrt(r1.x);
	r2.xyz = r1.xxx * r2.xyz;
	r5.xyz = gbufferTexture1.Load(r0.xyz).xyz;
	r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.z = asint(dot(r5.xyz, r5.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r5.xyz = asfloat(r0.zzz) * r5.xyz;
	r0.z = asint(dot(r2.xyz, r5.xyz));
	r0.z = asint(asfloat(r0.z) + asfloat(r0.z));
	r2.xyz = r5.xyz * -(asfloat(r0.zzz)) + r2.xyz;
	r0.z = asint(saturate(dot(r3.xyz, r5.xyz)));
	r1.x = saturate(dot(r3.xyz, r2.xyz));
	r1.x = r1.x + 0.00000999999975;
	r1.x = log2(r1.x);
	r2.xy = gbufferTexture2.Load(r0.xyw).xy;
	r0.xyw = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r2.y = r2.y * r2.y;
	r2.y = r2.y * r2.y;
	r2.y = r2.y * 196 + 0.00000999999975;
	r1.x = r1.x * r2.y;
	r1.x = exp2(r1.x);
	r2.y = saturate(asfloat(r0.z) * 2 + -0.5);
	r3.xyz = asfloat(r0.zzz) * r4.xyz;
	r0.z = asint(r1.x * r2.y);
	r2.yzw = asfloat(r0.zzz) * r4.xyz;
	r2.xyz = r2.xxx * r2.yzw;
	r0.z = asint(dot(r1.yzw, r1.yzw));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.x = dot(-(gDeferredLightDirection.xyz), r1.yzw);
	r2.w = r1.x / asfloat(r0.z);
	r2.w = -(r2.w) + 1;
	r0.z = asint(asfloat(r0.z) * r2.w);
	r0.z = asint(1 / asfloat(r0.z));
	r4.xyz = -(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx;
	r4.xyz = -(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(r4.xyz);
	r4.x = dot(r4.xyz, r1.yzw);
	r4.y = dot(gDeferredLightTangent.xyz, r1.yzw);
	r1.yz = asfloat(r0.zz) * r4.xy;
	r0.z = asint(abs(gDeferredLightConeOffset) + 60);
	r0.z = asint(120 / asfloat(r0.z));
	r0.z = asint(asfloat(r0.z) * gDeferredLightConeAngle);
	r0 = asint(asfloat(r0) * asfloat(r0));
	r0.z = asint(r1.x * asfloat(r0.z));
	r0.z = asint(-1 / asfloat(r0.z));
	r1.xw = asfloat(r0.zz) * r4.xy;
	r0.z = (gDeferredLightType == 2) ? -1 : 0;
	r1.xy = (r0.zz != 0) ? r1.xw : r1.yz;
	r1.xy = r1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
	r1.xyz = gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, r1.xy, 0).xyz;
	r0.xyz = asint(asfloat(r0.xyw) * r1.xyz);
	o.xyz = asfloat(r0.xyz) * r3.xyz + r2.xyz;
	o.w = 1;

	return o;
}
