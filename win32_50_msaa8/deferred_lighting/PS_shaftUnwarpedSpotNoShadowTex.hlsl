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
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2DMS<float> gbufferTextureDepth : register(t10);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
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
	int4 r5;
	float4 r6;
	float2 r7;
	r0.xy = asint(i.sv_position.xy * gooDeferredLightScreenSize.xy);
	r0.xy = asint(asfloat(r0.xy) * gooDeferredLightScreenSize.zw);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.x = asint(asfloat(r0.x) * i.texcoord5.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.yzw = asint(asfloat(r0.xxx) * i.texcoord5.xyz);
	r1.xyz = asint(-(i.texcoord5.xyz) * asfloat(r0.xxx) + gViewInverse[3].xyz);
	r2.xyz = asint(i.texcoord3.xyz + -(gViewInverse[3].xyz));
	r0.x = asint(dot(-(asfloat(r0.yzw)), -(asfloat(r0.yzw))));
	r0.y = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.x = (asfloat(r0.y) >= asfloat(r0.x)) ? -1 : 0;
	r0.x = r0.x & 1065353216;
	r0.yzw = asint(asfloat(r1.xyz) + -(i.texcoord3.xyz));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw) + i.texcoord3.xyz);
	r1.xyz = asint(-(asfloat(r0.xyz)) + gViewInverse[3].xyz);
	r2.x = asint(dot(gShadowParam4567.xyz, asfloat(r1.xyz)));
	r2.y = asint(dot(gShadowParam891113.xyz, asfloat(r1.xyz)));
	r2.z = asint(dot(gShadowParam14151617.xyz, asfloat(r1.xyz)));
	r2.w = asint(dot(gShadowParam18192021.xyz, asfloat(r1.xyz)));
	r0.w = asint(dot(gShadowParam4567.xyz, asfloat(r0.xyz)));
	r1.w = asint(dot(gShadowParam891113.xyz, asfloat(r0.xyz)));
	r3.x = asint(dot(gShadowParam14151617.xyz, asfloat(r0.xyz)));
	r3.y = asint(dot(gShadowParam18192021.xyz, asfloat(r0.xyz)));
	r4.x = asint(-(asfloat(r0.w)) + gShadowParam4567.w);
	r4.y = asint(-(asfloat(r1.w)) + gShadowParam891113.w);
	r4.z = asint(-(asfloat(r3.x)) + gShadowParam14151617.w);
	r4.w = asint(-(asfloat(r3.y)) + gShadowParam18192021.w);
	r2 = asint(asfloat(r4) / asfloat(r2));
	r3 = (float4(0, 0, 0, 0) >= asfloat(r2)) ? -1 : 0;
	r3 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r2 = asint(saturate(asfloat(r2)));
	r2 = asint(asfloat(r3) + asfloat(r2));
	r2.xy = asint(min(asfloat(r2.zw), asfloat(r2.xy)));
	r0.w = asint(min(asfloat(r2.y), asfloat(r2.x)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r2.xy = asint(i.sv_position.xy * float2(0.333333343, 0.333333343));
	r2.xy = asint(frac(asfloat(r2.xy)));
	r0.w = asint(asfloat(r2.x) * 0.333333343 + asfloat(r2.y));
	r0.w = asint(asfloat(r0.w) * 0.899999976 + 0.0500000007);
	r2.xyz = asint(asfloat(r1.xyz) * float3(0.111111112, 0.111111112, 0.111111112));
	r0.xyz = asint(asfloat(r2.xyz) * asfloat(r0.www) + asfloat(r0.xyz));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + 0.5);
	r0.w = asint(asfloat(r0.w) * 0.0250000004);
	r2.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyw);
	r2.xyz = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyw + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyw + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + gShadowMatrix[3].xyw);
	r1.w = asint(asfloat(r2.z) + 0.000000100000001);
	r2.xy = asint(asfloat(r2.xy) / asfloat(r1.ww));
	r3.xy = asint(asfloat(r2.xy) * float2(0.5, -0.5));
	r2.xy = asint(asfloat(r2.xy) * float2(0.5, -0.5) + float2(0.5, 0.5));
	r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r1.w = (0.509999990 >= asfloat(r1.w)) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.w = (asfloat(r2.z) >= 0) ? -1 : 0;
	r2.w = r2.w & 1065353216;
	r1.w = asint(asfloat(r1.w) * asfloat(r2.w));
	r2.w = asint(i.texcoord1.w * i.texcoord1.w);
	r3 = int4(0, 0, 0, 0);
	r4.xyz = r0.xyz;
	r5.xy = r2.xy;
	r4.w = r2.z;
	r5.z = 0;
	while (true) {
		r5.w = (r5.z >= 8) ? -1 : 0;
		if (r5.w != 0) break;
		r4.xyz = asint(asfloat(r1.xyz) * float3(0.444444448, 0.444444448, 0.444444448) + asfloat(r4.xyz));
		r6.xyz = asfloat(r4.yyy) * gShadowMatrix[1].xyw;
		r6.xyz = asfloat(r4.xxx) * gShadowMatrix[0].xyw + r6.xyz;
		r6.xyz = asfloat(r4.zzz) * gShadowMatrix[2].xyw + r6.xyz;
		r6.xyz = r6.xyz + gShadowMatrix[3].xyw;
		r6.xy = r6.xy / r6.zz;
		r6.xy = r6.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
		r7 = -(asfloat(r5.xy)) + r6.xy;
		r7 = r7.xy * float2(0.375, 0.375) + asfloat(r5.xy);
		r5.w = asint(gDeferredLightSampler_tex.Sample(gDeferredLightSampler, r7.xy).x);
		r5.w = asint(asfloat(r5.w) + asfloat(r5.w));
		r6.w = -(asfloat(r4.w)) + i.texcoord1.w;
		r6.w = r6.w + -1;
		r6.w = max(r6.w, 0);
		r6.w = r6.w * r6.w;
		r6.w = r6.w / asfloat(r2.w);
		r6.w = min(r6.w, 1);
		r6.w = asfloat(r0.w) * r6.w;
		r3 = asint(r6.w * asfloat(r5.w) + asfloat(r3));
		r5.z = r5.z + 4;
		r5.xy = asint(r6.xy);
		r4.w = asint(r6.z);
	}
	r0.x = asint(dot(asfloat(r3), float4(1, 1, 1, 1)));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x));
	r0.xyz = asint(asfloat(r0.xxx) * i.texcoord2.xyz);
	o.xyz = asfloat(r0.xyz) * g_fVolumetricLightRayIntensityMult;
	o.w = 0;

	return o;
}
