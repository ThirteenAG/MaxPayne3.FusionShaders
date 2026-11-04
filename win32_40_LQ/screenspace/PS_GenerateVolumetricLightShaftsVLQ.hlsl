cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
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
};

SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D<float> gbufferTextureDepth : register(t10);
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
	float3 r3;
	float3 r4;
	float4 r5;
	int3 r6;
	int3 r7;
	float4 r8;
	float3 r9;
	float3 r10;
	float4 r11;
	float3 r12;
	float4 dimensions0 = 0;
	gbufferTextureDepth.GetDimensions(0, dimensions0.x, dimensions0.y, dimensions0.w);
	r0 = asint(dimensions0);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz));
	r0.yzw = asint(float3(0, 0, 1));
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.x = asint(asfloat(r0.x) * i.texcoord1.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.xyz = asint(-(i.texcoord1.xyz) * asfloat(r0.xxx) + gViewInverse[3].xyz);
	r0.xyz = asint(-(asfloat(r0.xyz)) + gViewInverse[3].xyz);
	r1.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyz));
	r0.w = asint(dot(gViewInverse[2].xyz, asfloat(r1.xyz)));
	r2.xy = asint(float2(15, 2) / asfloat(r0.ww));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.y = asint(-(asfloat(r2.y)) + asfloat(r2.x));
	r0.x = asint(-(asfloat(r2.y)) + asfloat(r0.x));
	r0.x = asint(min(asfloat(r0.y), asfloat(r0.x)));
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	if (r0.y != 0) {
		r0.yz = asint(i.sv_position.xy * float2(0.333333343, 0.333333343));
		r2.xz = (asfloat(r0.yz) >= -(asfloat(r0.yz))) ? -1 : 0;
		r0.yz = asint(frac(abs(asfloat(r0.yz))));
		r0.yz = (r2.xz != 0) ? r0.yz : asint(-(asfloat(r0.yz)));
		r0.yz = asint(asfloat(r0.yz) * float2(3, 9));
		r0.y = asint(asfloat(r0.z) + asfloat(r0.y));
		r0.y = asint(asfloat(r0.y) * 0.111111112);
		r0.z = asint(max(asfloat(r0.x), 0));
		r2.xzw = asint(asfloat(r0.zzz) * asfloat(r1.xyz));
		r0.x = asint(asfloat(r2.y) + asfloat(r0.x));
		r0.xzw = asint(-(asfloat(r1.xyz)) * asfloat(r0.xxx) + gViewInverse[3].xyz);
		r1.xyz = asint(asfloat(r2.xzw) * float3(0.0769230798, 0.0769230798, 0.0769230798));
		r0.xyz = asint(asfloat(r1.xyz) * asfloat(r0.yyy) + asfloat(r0.xzw));
		r0.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
		r0.w = asint(sqrt(asfloat(r0.w)));
		r0.w = asint(asfloat(r0.w) * globalScalars2.x);
		r1.x = asint(asfloat(r0.w) * -1.44269502);
		r1.x = asint(exp2(asfloat(r1.x)));
		r3.x = dot(float2(1, 1), gShadowParam0123.xy);
		r3.y = dot(float2(1, 1), gShadowParam4567.xy);
		r3.z = dot(float2(1, 1), gCascadeZScales.xy);
		r4.x = dot(float2(1, 1), gShadowParam891113.xy);
		r4.y = dot(float2(1, 1), gShadowParam14151617.xy);
		r4.z = dot(float2(1, 1), gCascadeZOffsets.xy);
		r5.x = -(gCascadeXMinThresholds.w);
		r5.y = -(gCascadeXMaxThresholds.w);
		r6 = r0.xyz;
		r1.yz = int2(0, 0);
		while (true) {
			r1.w = (r1.z >= 12) ? -1 : 0;
			if (r1.w != 0) break;
			r7 = r6.xyz;
			r8.xyz = asfloat(r2.xzw) * float3(0.0769230798, 0.0769230798, 0.0769230798) + asfloat(r7.xyz);
			r9 = asfloat(r2.xzw) * float3(0.153846160, 0.153846160, 0.153846160) + asfloat(r7.xyz);
			r10 = asfloat(r2.xzw) * float3(0.230769232, 0.230769232, 0.230769232) + asfloat(r7.xyz);
			r11.xyz = asfloat(r6.yyy) * gShadowMatrix[1].xyz;
			r11.xyz = asfloat(r6.xxx) * gShadowMatrix[0].xyz + r11.xyz;
			r11.xyz = asfloat(r6.zzz) * gShadowMatrix[2].xyz + r11.xyz;
			r11.xyz = r11.xyz + gShadowMatrix[3].xyz;
			r5.zw = r11.xy + -(gShadowParam18192021.zw);
			r11.xyz = r11.zxy * r3.zxy + r4.zxy;
			r11.x = saturate(r11.x);
			r5.zw = saturate(abs(r5.zw) * float2(4, 4) + r5.xy);
			r1.w = asint(max(r5.w, r5.z));
			r2.y = asint(-(r11.x) + 1);
			r2.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r11.yz, asfloat(r2.y)));
			r1.w = asint(asfloat(r1.w) + asfloat(r2.y));
			r11.x = min(asfloat(r1.w), 1);
			r12 = r8.yyy * gShadowMatrix[1].xyz;
			r8.xyw = r8.xxx * gShadowMatrix[0].xyz + r12.xyz;
			r8.xyz = r8.zzz * gShadowMatrix[2].xyz + r8.xyw;
			r8.xyz = r8.xyz + gShadowMatrix[3].xyz;
			r5.zw = r8.xy + -(gShadowParam18192021.zw);
			r8.xyz = r8.zxy * r3.zxy + r4.zxy;
			r8.x = saturate(r8.x);
			r5.zw = saturate(abs(r5.zw) * float2(4, 4) + r5.xy);
			r1.w = asint(max(r5.w, r5.z));
			r2.y = asint(-(r8.x) + 1);
			r2.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.yz, asfloat(r2.y)));
			r1.w = asint(asfloat(r1.w) + asfloat(r2.y));
			r11.y = min(asfloat(r1.w), 1);
			r8.xyz = r9.yyy * gShadowMatrix[1].xyz;
			r8.xyz = r9.xxx * gShadowMatrix[0].xyz + r8.xyz;
			r8.xyz = r9.zzz * gShadowMatrix[2].xyz + r8.xyz;
			r8.xyz = r8.xyz + gShadowMatrix[3].xyz;
			r5.zw = r8.xy + -(gShadowParam18192021.zw);
			r8.xyz = r8.zxy * r3.zxy + r4.zxy;
			r8.x = saturate(r8.x);
			r5.zw = saturate(abs(r5.zw) * float2(4, 4) + r5.xy);
			r1.w = asint(max(r5.w, r5.z));
			r2.y = asint(-(r8.x) + 1);
			r2.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.yz, asfloat(r2.y)));
			r1.w = asint(asfloat(r1.w) + asfloat(r2.y));
			r11.z = min(asfloat(r1.w), 1);
			r8.xyz = r10.yyy * gShadowMatrix[1].xyz;
			r8.xyz = r10.xxx * gShadowMatrix[0].xyz + r8.xyz;
			r8.xyz = r10.zzz * gShadowMatrix[2].xyz + r8.xyz;
			r8.xyz = r8.xyz + gShadowMatrix[3].xyz;
			r5.zw = r8.xy + -(gShadowParam18192021.zw);
			r8.xyz = r8.zxy * r3.zxy + r4.zxy;
			r8.x = saturate(r8.x);
			r5.zw = saturate(abs(r5.zw) * float2(4, 4) + r5.xy);
			r1.w = asint(max(r5.w, r5.z));
			r2.y = asint(-(r8.x) + 1);
			r2.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, r8.yz, asfloat(r2.y)));
			r1.w = asint(asfloat(r1.w) + asfloat(r2.y));
			r11.w = min(asfloat(r1.w), 1);
			r8 = asfloat(r0.w) * r11;
			r1.w = asint(asfloat(r1.y) * asfloat(r1.x) + r8.x);
			r1.w = asint(asfloat(r1.w) * asfloat(r1.x) + r8.y);
			r1.w = asint(asfloat(r1.w) * asfloat(r1.x) + r8.z);
			r1.y = asint(asfloat(r1.w) * asfloat(r1.x) + r8.w);
			r6 = asint(asfloat(r2.xzw) * float3(0.307692319, 0.307692319, 0.307692319) + asfloat(r7.xyz));
			r1.z = r1.z + 4;
		}
	} else {
		r1.y = 0;
	}
	o = asfloat(r1.y);

	return o;
}
