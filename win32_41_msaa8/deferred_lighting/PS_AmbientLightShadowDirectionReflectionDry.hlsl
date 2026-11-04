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

SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2DMS<float4> deferredLightTexture0P : register(t3);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
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
	float4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	int3 r7;
	float3 r8;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.yzw = gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz;
	r2.xyz = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xyz;
	r3.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(deferredLightTexture0P.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(16, 16, 16));
	r0.w = asint(r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord1.w);
	r0.w = asint(1 / asfloat(r0.w));
	r4.xyz = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + gViewInverse[3].xyz);
	r1.x = r2.y * r2.y;
	r1 = r1 * r1;
	r3.xyz = asint(asfloat(r3.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.y = dot(asfloat(r3.xyz), asfloat(r3.xyz));
	r2.y = rsqrt(r2.y);
	r3.xyz = asint(r2.yyy * asfloat(r3.xyz));
	r5.xyz = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r5.xyz = asint(asfloat(r0.www) * asfloat(r5.xyz));
	r0.w = asint(dot(asfloat(r5.xyz), asfloat(r3.xyz)));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r5.xyz = asint(asfloat(r3.xyz) * -(asfloat(r0.www)) + asfloat(r5.xyz));
	r0.w = asint(dot(asfloat(r3.xyz), -(gDirectionalLight.xyz)));
	r2.y = saturate(asfloat(r0.w) + -0.25);
	r2.y = r2.y * 1.33333337;
	r2.w = saturate(dot(-(gDirectionalLight.xyz), asfloat(r5.xyz)));
	r2.w = r2.w + 0.00000999999975;
	r1.x = r1.x * 196 + 0.00000999999975;
	r2.w = log2(r2.w);
	r1.x = r1.x * r2.w;
	r1.x = exp2(r1.x);
	r0.w = asint(saturate(asfloat(r0.w) * 2 + -0.5));
	r0.w = asint(asfloat(r0.w) * r1.x);
	r5.xyz = asint(asfloat(r4.yyy) * gShadowMatrix[1].xyz);
	r4.xyw = asint(asfloat(r4.xxx) * gShadowMatrix[0].xyz + asfloat(r5.xyz));
	r4.xyz = asint(asfloat(r4.zzz) * gShadowMatrix[2].xyz + asfloat(r4.xyw));
	r4.xyz = asint(asfloat(r4.xyz) + gShadowMatrix[3].xyz);
	r5.xy = asint(asfloat(r4.xy) + -(gShadowParam18192021.zw));
	r5.zw = (asfloat(r5.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r5.zw = r5.zw & int2(1065353216, 1065353216);
	r6.xy = (gCascadeXMinThresholds.xy >= asfloat(r5.xx)) ? -1 : 0;
	r6.zw = (asfloat(r5.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r6 = r6 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r7.xy = (gCascadeYMinThresholds.xy >= asfloat(r5.yy)) ? -1 : 0;
	r7.xy = r7.xy & int2(1065353216, 1065353216);
	r5.zw = asint(asfloat(r5.zw) + asfloat(r6.xy));
	r5.zw = asint(asfloat(r6.zw) + asfloat(r5.zw));
	r5.zw = asint(asfloat(r7.xy) + asfloat(r5.zw));
	r6.yz = asint(min(asfloat(r5.zw), float2(1, 1)));
	r6.x = 1065353216;
	r7.x = asint(dot(asfloat(r6.xyz), gShadowParam0123.xyz));
	r7.y = asint(dot(asfloat(r6.xyz), gShadowParam4567.xyz));
	r7.z = asint(dot(asfloat(r6.xyz), gCascadeZScales.xyz));
	r8.x = dot(asfloat(r6.xyz), gShadowParam891113.xyz);
	r8.y = dot(asfloat(r6.xyz), gShadowParam14151617.xyz);
	r8.z = dot(asfloat(r6.xyz), gCascadeZOffsets.xyz);
	r4.xyz = asint(asfloat(r4.zxy) * asfloat(r7.zxy) + r8.zxy);
	r4.x = asint(saturate(asfloat(r4.x)));
	r6.x = asint(-(gCascadeXMinThresholds.w));
	r6.y = asint(-(gCascadeXMaxThresholds.w));
	r5.xy = asint(saturate(abs(asfloat(r5.xy)) * float2(4, 4) + asfloat(r6.xy)));
	r1.x = max(asfloat(r5.y), asfloat(r5.x));
	r2.w = -(asfloat(r4.x)) + 0.999999523;
	r3.w = 0;
	r4.x = -1;
	while (true) {
		r4.w = (r4.x >= 2) ? -1 : 0;
		if (r4.w != 0) break;
		r4.w = asint((float)r4.x);
		r5.x = asint(asfloat(r4.w) * gShadowParam18192021.x);
		r4.w = r3.w;
		r5.z = -1;
		while (true) {
			r5.w = (r5.z >= 2) ? -1 : 0;
			if (r5.w != 0) break;
			r5.w = asint((float)r5.z);
			r5.y = asint(asfloat(r5.w) * gShadowParam18192021.y);
			r5.yw = asint(asfloat(r4.yz) + asfloat(r5.xy));
			r5.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r5.yw), r2.w));
			r4.w = asint(asfloat(r4.w) + asfloat(r5.y));
			r5.z = r5.z + 1;
		}
		r3.w = r4.w;
		r4.x = r4.x + 1;
	}
	r1.x = asfloat(r3.w) * 0.111111112 + r1.x;
	r1.x = r1.x * 1.25;
	r1.x = min(r1.x, 1);
	r2.w = r1.x * -2 + 3;
	r1.x = r1.x * r1.x;
	r1.x = r1.x * r2.w;
	r4.xyz = asint(r1.xxx * gDirectionalColour.xyz);
	r5.xyz = asint(asfloat(r0.www) * asfloat(r4.xyz));
	r4.xyz = asint(r2.yyy * asfloat(r4.xyz));
	r0.w = asint(sqrt(r2.z));
	r1.x = dot(gLightAmbientDir0.xyz, asfloat(r3.xyz));
	r1.x = saturate(r1.x + gLightAmbientDir0.w);
	r2.y = dot(gLightAmbientDir1.xyz, asfloat(r3.xyz));
	r2.y = saturate(r2.y + gLightAmbientDir0.w);
	r3.xyz = asint(r2.yyy * gLightAmbient1.xyz);
	r3.xyz = asint(r1.xxx * gLightAmbient0.xyz + asfloat(r3.xyz));
	r2.yzw = r2.zzz * asfloat(r3.xyz);
	r2.yzw = asfloat(r4.xyz) * asfloat(r0.www) + r2.yzw;
	r0.w = asint(dot(r2.yzw, float3(0.333333343, 0.333333343, 0.333333343)));
	r0.w = asint(asfloat(r0.w) + 0.0149999997);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r5.xyz) * r2.xxx + asfloat(r0.xyz));
	o.xyz = r1.yzw * r2.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
