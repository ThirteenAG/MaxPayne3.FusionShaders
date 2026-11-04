cbuffer _Globals : register(b1)
{
	float g_fSSAOBilateralCoef : packoffset(c122);
	float4 dReflectionParams : packoffset(c123);
	float4 SunRaysParams : packoffset(c124);
	float2 poisson12[12] : packoffset(c125);
	float g_fSSAOKernelScale : packoffset(c137);
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

SamplerState deferredLightDownsampleDepthSampler : register(s12);
Texture2D deferredLightDownsampleDepthSampler_tex : register(t12);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float3 r11;
	r0 = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, i.texcoord.xy);
	r0.y = 1.00010002 / r0.x;
	r0.z = saturate(r0.y * g_fSSAOKernelScale);
	r0.z = r0.z * 37 + 3;
	r1 = asint(float4(1, 1, 1, 1) / globalScreenSize.xyxy);
	r2.xy = asint(asfloat(r1.zw) + asfloat(r1.zw));
	r0.zw = r0.zz * asfloat(r2.xy);
	r2 = asint(globalScreenSize.xyxy * float4(4.5, 14.9069996, 0.5, 0.5));
	r2.x = asint(dot(i.texcoord.xy, asfloat(r2.xy)));
	float angle0 = asfloat(r2.x);
	r2.x = asint(sin(angle0));
	r3.x = cos(angle0);
	r2.y = asint(r3.x);
	r3.xy = r0.zw * asfloat(r2.xy);
	r3.z = -(r3.x);
	r0.zw = r3.yz + i.texcoord.xy;
	r0.zw = r0.zw * asfloat(r2.zw);
	r0.zw = floor(r0.zw);
	r0.zw = r0.zw + float2(0.5, 0.5);
	r0.zw = r0.zw / asfloat(r2.zw);
	r4 = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r0.zw);
	r0.zw = r0.zw + float2(-0.5, -0.5);
	r5.xy = r0.zw * gDeferredProjParams.xy;
	r0.zw = r3.xy * float2(-0.25, -0.25) + i.texcoord.xy;
	r3 = r3.xyyx * float4(0.75, 0.75, -0.5, 0.5) + i.texcoord.xyxy;
	r3 = asfloat(r2.zwzw) * r3;
	r3 = floor(r3);
	r3 = r3 + float4(0.5, 0.5, 0.5, 0.5);
	r3 = r3 / asfloat(r2.zwzw);
	r0.zw = r0.zw * asfloat(r2.zw);
	r0.zw = floor(r0.zw);
	r0.zw = r0.zw + float2(0.5, 0.5);
	r0.zw = r0.zw / asfloat(r2.zw);
	r2 = asint(deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r0.zw));
	r0.zw = r0.zw + float2(-0.5, -0.5);
	r6.xy = r0.zw * gDeferredProjParams.xy;
	r4.w = asfloat(r2.x);
	r2 = asint(deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r3.xy));
	r4.y = asfloat(r2.x);
	r2 = asint(deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r3.zw));
	r3 = r3 + float4(-0.5, -0.5, -0.5, -0.5);
	r3 = r3.zwxy * gDeferredProjParams.xyxy;
	r4.z = asfloat(r2.x);
	r2 = asint(r0.y * r4);
	r5.z = 0.5;
	r0.yz = i.texcoord.xy + float2(-0.5, -0.5);
	r4.xy = r0.yz * gDeferredProjParams.xy;
	r4.z = 0.5;
	r0.yzw = r5.xyz * asfloat(r2.xxx) + -(r4.xyz);
	r2.x = asint(dot(r0.yzw, r0.yzw));
	r4.w = rsqrt(asfloat(r2.x));
	r5.x = sqrt(asfloat(r2.x));
	r0.yzw = r0.yzw * r4.www;
	r7.y = 0.5;
	r8 = asfloat(r1.zwzw) * float4(-2, 0, 2, 0) + i.texcoord.xyxy;
	r1 = asint(asfloat(r1) * float4(0, -2, 0, 2) + i.texcoord.xyxy);
	r9 = r8 + float4(-0.5, -0.5, -0.5, -0.5);
	r9 = r9.wxzy * gDeferredProjParams.yxxy;
	r7.xz = r9.wy;
	r10 = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r8.xy);
	r8 = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, r8.zw);
	r8.yzw = r0.xxx * r4.zxy;
	r7.xyz = -(r7.xyz) * r10.xxx + r8.wyz;
	r9.y = 0.5;
	r9.xyz = r9.xyz * r8.xxx + -(r8.wyz);
	r2.x = (abs(r7.y) < abs(r9.y)) ? -1 : 0;
	r7.xyz = (r2.xxx != 0) ? r7.xyz : r9.xyz;
	r9 = deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, asfloat(r1.xy));
	r10 = asfloat(r1) + float4(-0.5, -0.5, -0.5, -0.5);
	r1 = asint(deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, asfloat(r1.zw)));
	r10 = r10.xzwy * gDeferredProjParams.xxyy;
	r11.yz = r10.xw;
	r11.x = 0.5;
	r1.yzw = asint(-(r11.xyz) * r9.xxx + r8.yzw);
	r10.x = 0.5;
	r8.xyz = r10.xyz * asfloat(r1.xxx) + -(r8.yzw);
	r1.x = (abs(asfloat(r1.y)) < abs(r8.x)) ? -1 : 0;
	r1.xyz = (r1.xxx != 0) ? r1.yzw : asint(r8.xyz);
	r8.xyz = r7.xyz * asfloat(r1.xyz);
	r1.xyz = asint(asfloat(r1.zxy) * r7.yzx + -(r8.xyz));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r7.x = dot(r0.yzw, asfloat(r1.xyz));
	r6.z = 0.5;
	r0.yzw = r6.xyz * asfloat(r2.www) + -(r4.xyz);
	r1.w = asint(dot(r0.yzw, r0.yzw));
	r2.x = asint(rsqrt(asfloat(r1.w)));
	r5.w = sqrt(asfloat(r1.w));
	r0.yzw = r0.yzw * asfloat(r2.xxx);
	r7.w = dot(r0.yzw, asfloat(r1.xyz));
	r6.xy = r3.zw;
	r6.z = 0.5;
	r0.yzw = r6.xyz * asfloat(r2.yyy) + -(r4.xyz);
	r1.w = asint(dot(r0.yzw, r0.yzw));
	r2.x = asint(rsqrt(asfloat(r1.w)));
	r5.y = sqrt(asfloat(r1.w));
	r0.yzw = r0.yzw * asfloat(r2.xxx);
	r7.y = dot(r0.yzw, asfloat(r1.xyz));
	r3.z = 0.5;
	r0.yzw = r3.xyz * asfloat(r2.zzz) + -(r4.xyz);
	r1.w = asint(dot(r0.yzw, r0.yzw));
	r2.x = asint(rsqrt(asfloat(r1.w)));
	r5.z = sqrt(asfloat(r1.w));
	r3 = r0.x * r5;
	r3 = r3 + r3;
	r0.xyz = r0.yzw * asfloat(r2.xxx);
	r7.z = dot(r0.xyz, asfloat(r1.xyz));
	r0 = -(r7) + float4(1, 1, 1, 1);
	r0 = saturate(max(r0, r3));
	r0.x = dot(r0, float4(0.25, 0.25, 0.25, 0.25));
	r0.x = log2(r0.x);
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	o = exp2(r0.x);

	return o;
}
