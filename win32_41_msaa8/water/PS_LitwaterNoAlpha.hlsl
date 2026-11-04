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

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
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

cbuffer WaterSim : register(b1)
{
	float4 waterRenderSimParam : packoffset(c0);
};

cbuffer WaterAttributes : register(b4)
{
	float4 waterColour : packoffset(c0);
	float waterIntensity : packoffset(c1);
	float waterReflectionScale : packoffset(c1.y);
};

SamplerState SurfaceTextureSampler : register(s1);
SamplerState ReflectTextureSampler : register(s2);
SamplerState WaterRainRippleNormalSampler : register(s14);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D SurfaceTextureSampler_tex : register(t1);
Texture2D ReflectTextureSampler_tex : register(t2);
Texture2D WaterRainRippleNormalSampler_tex : register(t14);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	float3 r4;
	int3 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float3 r10;
	r0.xy = i.texcoord.xy / i.texcoord.zz;
	r0.xy = r0.xy * float2(-0.5, -0.5) + float2(0.5, 0.5);
	r1 = asint(i.texcoord2.xyxy * float4(0.00200000009, 0.00200000009, 0.00999999978, 0.00999999978));
	r0.zw = SurfaceTextureSampler_tex.Sample(SurfaceTextureSampler, asfloat(r1.xy)).zw;
	r0.zw = r0.zw + float2(-0.5, -0.5);
	r2.xy = asint(r0.zw * float2(0.0511999987, 0.0511999987));
	r3.xyz = asint(i.texcoord2.xyz + -(i.texcoord3.xyz));
	r0.z = dot(asfloat(r3.xyz), asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = dot(asfloat(r3.xyz), asfloat(r3.xyz));
	r0.w = rsqrt(r0.w);
	r4 = r0.www * asfloat(r3.xyz);
	r0.z = -(r0.z) * 0.000399999990 + 1;
	r0.z = max(r0.z, 0);
	r5.z = asint(r0.z * i.texcoord2.z);
	r1.x = asint(r0.z / i.texcoord1.z);
	r1.y = asint(-(r0.z) + 1);
	r2.z = 1065353216;
	r2.xyz = asint(asfloat(r1.yyy) * asfloat(r2.xyz));
	r2.xyz = asint(i.texcoord1.xyz * asfloat(r1.xxx) + asfloat(r2.xyz));
	r1.xy = asint(SurfaceTextureSampler_tex.Sample(SurfaceTextureSampler, asfloat(r1.zw)).zw);
	r1.xy = asint(asfloat(r1.xy) + float2(-0.5, -0.5));
	r6 = i.texcoord2.xyxy * float4(0.0454545468, 0.0454545468, 0.300000012, 0.300000012);
	r1.zw = asint(SurfaceTextureSampler_tex.Sample(SurfaceTextureSampler, r6.xy).zw);
	r7 = asfloat(r1.zwzw) + float4(-0.5, -0.5, -0.5, -0.5);
	r7 = r0.z * r7;
	r8 = asfloat(r1.xyxy) * float4(0.256000012, 0.256000012, 1.02400005, 1.02400005) + asfloat(r2.xyxy);
	r7 = r7.zwxy * float4(0.465454549, 0.465454549, 0.116363637, 0.116363637) + r8.zwxy;
	r8.xy = r7.zw;
	r8.z = 1;
	r8.xyz = -(asfloat(r2.xyz)) + r8.xyz;
	r8.xyz = waterRenderSimParam.yyy * r8.xyz + asfloat(r2.xyz);
	r8.xyz = r8.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r8.xyz, r8.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r8.xyz = asfloat(r1.zzz) * r8.xyz;
	r9.xyz = -(i.texcoord2.xyz) + gViewInverse[3].xyz;
	r1.z = asint(dot(r9.xyz, r9.xyz));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) + 1);
	r6.xyz = WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, r6.zw).xyz;
	r9.z = r6.z + r6.z;
	r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
	r1.z = asint(2 / asfloat(r1.z));
	r1.z = asint(min(asfloat(r1.z), 1));
	r9.xy = asfloat(r1.zz) * r6.xy;
	r6.xyz = r9.xyz + float3(0.00000999999975, 0.00000999999975, -0.999989986);
	r1.z = asint(dot(r6.xyz, r6.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r6.xyz = asfloat(r1.zzz) * r6.xyz;
	r1.zw = asint(r8.yz * r8.yx);
	r9.xyz = r8.zyy * r8.zxx + -(asfloat(r1.zww));
	r10 = r6.xxx * r8.xzy;
	r6.xzw = r8.xyz * r6.zzz + r10.xyz;
	r6.xyz = r9.xyz * r6.yyy + r6.xzw;
	r6.xyz = r6.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r6.xyz, r6.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r6.xyz = r6.xyz * asfloat(r1.zzz) + -(r8.xyz);
	r6.xyz = waterRenderSimParam.www * r6.xyz + r8.xyz;
	r6.xyz = r6.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r6.xyz, r6.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r6.xyz = asfloat(r1.zzz) * r6.xyz;
	r8.xyz = r4.xyz * float3(1, 1, 0) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r8.xyz, r8.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r8.xy = asfloat(r1.zz) * r8.xy;
	r1.z = asint(i.texcoord.z * 0.0299999993);
	r1.z = asint(0.5 / asfloat(r1.z));
	r1.z = asint(min(asfloat(r1.z), 2));
	r8.zw = float2(1, -1);
	r9 = r6.xyyx * r8.yyxz;
	r8.xy = r9.zw * r8.wx + r9.xy;
	r8.xy = r8.xy * -(asfloat(r1.zz)) + r0.xy;
	r0.x = i.texcoord3.w + 1;
	r0.y = r0.z * 0.0500000007;
	r0.x = r0.x * 0.5 + r0.y;
	r0.x = r0.x + 0.00499999989;
	r8.z = max(r0.x, r8.y);
	r0.xyz = ReflectTextureSampler_tex.SampleLevel(ReflectTextureSampler, r8.xz, 0).xyz;
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * waterReflectionScale;
	r7.z = 1;
	r7.xyz = -(asfloat(r2.xyz)) + r7.xyz;
	r7.xyz = waterRenderSimParam.yyy * r7.xyz + asfloat(r2.xyz);
	r7.xyz = r7.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(dot(r7.xyz, r7.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r7.xyz = asfloat(r1.zzz) * r7.xyz;
	r1.z = asint(dot(r4.xyz, r7.xyz));
	r1.z = asint(asfloat(r1.z) + asfloat(r1.z));
	r8.xyz = r7.xyz * -(asfloat(r1.zzz)) + r4.xyz;
	r1.z = (i.texcoord3.z < waterRenderSimParam.z) ? -1 : 0;
	r1.xy = asint(asfloat(r1.xy) * float2(0.128000006, 0.128000006));
	r1.xy = asint(asfloat(r2.xy) * float2(0.5, 0.5) + asfloat(r1.xy));
	r2.xy = asint(asfloat(r1.xy) + float2(0.00000999999975, 0.00000999999975));
	r2.z = 1045221228;
	r1.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r1.xyw = asint(asfloat(r1.xxx) * asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r3.xyz) * r0.www + asfloat(r1.xyw));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = dot(asfloat(r2.xyz), asfloat(r2.xyz));
	r0.w = rsqrt(r0.w);
	r2.xyz = asint(r0.www * asfloat(r2.xyz));
	r1.xyw = (r1.zzz != 0) ? r1.xyw : asint(r7.xyz);
	r2.xyz = (r1.zzz != 0) ? r2.xyz : asint(r8.xyz);
	r5.xy = asint(i.texcoord2.xy);
	r3.xyz = asint(asfloat(r1.xyw) * float3(0.5, 0.5, 0.5) + asfloat(r5.xyz));
	r0.w = dot(asfloat(r1.xyw), -(gDirectionalLight.xyz));
	r1.x = asint(saturate(r0.w + -0.25));
	r1.x = asint(asfloat(r1.x) * 1.33333337);
	r1.y = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r2.xyz))));
	r1.y = asint(asfloat(r1.y) + 0.00000999999975);
	r1.z = (r1.z != 0) ? 1120403457 : 1140850688;
	r1.y = asint(log2(asfloat(r1.y)));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.z));
	r1.y = asint(exp2(asfloat(r1.y)));
	r0.w = saturate(r0.w * 2 + -0.5);
	r0.w = r0.w * asfloat(r1.y);
	r1.yzw = asint(asfloat(r3.yyy) * gShadowMatrix[1].xyz);
	r1.yzw = asint(asfloat(r3.xxx) * gShadowMatrix[0].xyz + asfloat(r1.yzw));
	r1.yzw = asint(asfloat(r3.zzz) * gShadowMatrix[2].xyz + asfloat(r1.yzw));
	r1.yzw = asint(asfloat(r1.yzw) + gShadowMatrix[3].xyz);
	r2.xy = asint(asfloat(r1.yz) + -(gShadowParam18192021.zw));
	r2.zw = (asfloat(r2.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r2.zw = r2.zw & int2(1065353216, 1065353216);
	r3.xy = (gCascadeXMinThresholds.xy >= asfloat(r2.xx)) ? -1 : 0;
	r3.zw = (asfloat(r2.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r3 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r5.xy = (gCascadeYMinThresholds.xy >= asfloat(r2.yy)) ? -1 : 0;
	r5.xy = r5.xy & int2(1065353216, 1065353216);
	r2.zw = asint(asfloat(r2.zw) + asfloat(r3.xy));
	r2.zw = asint(asfloat(r3.zw) + asfloat(r2.zw));
	r2.zw = asint(asfloat(r5.xy) + asfloat(r2.zw));
	r3.yz = asint(min(asfloat(r2.zw), float2(1, 1)));
	r3.x = 1065353216;
	r5.x = asint(dot(asfloat(r3.xyz), gShadowParam0123.xyz));
	r5.y = asint(dot(asfloat(r3.xyz), gShadowParam4567.xyz));
	r5.z = asint(dot(asfloat(r3.xyz), gCascadeZScales.xyz));
	r7.x = dot(asfloat(r3.xyz), gShadowParam891113.xyz);
	r7.y = dot(asfloat(r3.xyz), gShadowParam14151617.xyz);
	r7.z = dot(asfloat(r3.xyz), gCascadeZOffsets.xyz);
	r1.yzw = asint(asfloat(r1.wyz) * asfloat(r5.zxy) + r7.zxy);
	r1.y = asint(saturate(asfloat(r1.y)));
	r3.x = asint(-(gCascadeXMinThresholds.w));
	r3.y = asint(-(gCascadeXMaxThresholds.w));
	r2.xy = asint(saturate(abs(asfloat(r2.xy)) * float2(4, 4) + asfloat(r3.xy)));
	r2.x = asint(max(asfloat(r2.y), asfloat(r2.x)));
	r1.y = asint(-(asfloat(r1.y)) + 0.999999523);
	r2.yz = int2(0, -1);
	while (true) {
		r2.w = (r2.z >= 2) ? -1 : 0;
		if (r2.w != 0) break;
		r2.w = asint((float)r2.z);
		r3.x = asint(asfloat(r2.w) * gShadowParam18192021.x);
		r2.w = r2.y;
		r3.z = -1;
		while (true) {
			r3.w = (r3.z >= 2) ? -1 : 0;
			if (r3.w != 0) break;
			r3.w = asint((float)r3.z);
			r3.y = asint(asfloat(r3.w) * gShadowParam18192021.y);
			r3.yw = asint(asfloat(r1.zw) + asfloat(r3.xy));
			r3.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r3.yw), asfloat(r1.y)));
			r2.w = asint(asfloat(r2.w) + asfloat(r3.y));
			r3.z = r3.z + 1;
		}
		r2.y = r2.w;
		r2.z = r2.z + 1;
	}
	r1.y = asint(asfloat(r2.y) * 0.111111112 + asfloat(r2.x));
	r1.y = asint(asfloat(r1.y) * 1.25);
	r1.y = asint(min(asfloat(r1.y), 1));
	r1.z = asint(asfloat(r1.y) * -2 + 3);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.z));
	r1.yzw = asint(asfloat(r1.yyy) * gDirectionalColour.xyz);
	r2.xyz = asint(r0.www * asfloat(r1.yzw));
	r1.xyz = asint(asfloat(r1.xxx) * asfloat(r1.yzw));
	r1.xyz = asint(asfloat(r1.xyz) * gToneMapScalers.zzz);
	r3.xyz = asint(asfloat(r1.xyz) * waterColour.xyz);
	r2.xyz = asint(asfloat(r2.xyz) * gDirectionalLight.www);
	r2.xyz = asint(asfloat(r2.xyz) * gToneMapScalers.zzz);
	r2.xyz = asint(asfloat(r2.xyz) * float3(10, 10, 10));
	r0.xyz = r0.xyz * float3(16, 16, 16) + asfloat(r2.xyz);
	r0.w = dot(r4.xyz, r6.xyz);
	r0.w = saturate(-(r0.w));
	r0.w = -(r0.w) + 1.00001001;
	r1.w = asint(r0.w * r0.w);
	r1.w = asint(asfloat(r1.w) * asfloat(r1.w));
	r0.w = r0.w * asfloat(r1.w);
	r0.w = r0.w * 0.949999988 + 0.0500000007;
	r0.xyz = -(waterColour.xyz) * asfloat(r1.xyz) + r0.xyz;
	r0.xyz = r0.www * r0.xyz + asfloat(r3.xyz);
	o.xyz = r0.xyz * globalScalars.yyy;
	o.w = 0;

	return o;
}
