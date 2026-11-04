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

SamplerState gDeferredLightSampler1 : register(s1);
SamplerState gDeferredLightSampler2 : register(s2);
Texture2D gDeferredLightSampler1_tex : register(t1);
Texture2D gDeferredLightSampler2_tex : register(t2);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	r0.x = globalScreenSize.y / globalScreenSize.x;
	r1.xyw = -(i.texcoord.xyy);
	r0.yz = r1.xy + float2(0.5, 0.5);
	r1.z = r0.x * r0.y;
	r0.x = dot(r0.yz, r0.yz);
	r0.x = sqrt(r0.x);
	r0.yz = r1.zw + float2(0.00000999999975, 0.500010014);
	r0.w = dot(r0.yz, r0.yz);
	r0.w = rsqrt(r0.w);
	r0.yz = r0.ww * r0.yz;
	r0.yz = r0.xx * r0.yz;
	r0.x = -(r0.x) * 1.41442716 + 0.708000004;
	r0.yz = r0.yz * float2(0.0909090936, 0.0909090936);
	r1 = i.sv_position.xyxy * float4(4, 4, 0.333333343, 0.333333343);
	r2.xy = (r1.zw >= -(r1.zw)) ? -1 : 0;
	r1.zw = frac(abs(r1.zw));
	r1.zw = (r2.xy != 0) ? r1.zw : -(r1.zw);
	r0.w = r1.z * 3 + 1;
	r0.w = r1.w * 9 + r0.w;
	r2 = asint(r0.w * float4(0.111111112, 0.111111112, 0.111111112, 0.111111112) + float4(0.5, 1.5, 2.5, 3.5));
	r1.zw = float2(1, 1) / globalScreenSize.xy;
	r1.xy = r1.zw * r1.xy;
	r3 = r0.yzyz * asfloat(r2.xxyy) + r1.xyxy;
	r2 = asint(r0.yzyz * asfloat(r2.zzww) + r1.xyxy);
	r1.z = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r3.xy).x;
	r1.w = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r3.zw).x;
	r3.x = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.xy).x;
	r3.xy = r3.xx * float2(1.5, 0.200000003);
	r1.z = r1.z * 1.45000005 + r3.x;
	r1.z = r1.w * 1.35000002 + r1.z;
	r1.w = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, asfloat(r2.xy)).x;
	r2.x = asint(gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, asfloat(r2.zw)).x);
	r1.z = r1.w * 1.25 + r1.z;
	r1.z = asfloat(r2.x) * 1.14999998 + r1.z;
	r2 = asint(r0.w * float4(0.111111112, 0.111111112, 0.111111112, 0.111111112) + float4(4.5, 5.5, 6.5, 7.5));
	r0.w = r0.w * 0.111111112 + 8.5;
	r3.xz = r0.yz * r0.ww + r1.xy;
	r0.w = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r3.xz).x;
	r4 = r0.yzyz * asfloat(r2.xxyy) + r1.xyxy;
	r2 = asint(r0.yzyz * asfloat(r2.zzww) + r1.xyxy);
	r0.y = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r4.xy).x;
	r0.z = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r4.zw).x;
	r0.y = r0.y * 1.04999995 + r1.z;
	r0.y = r0.z * 0.949999988 + r0.y;
	r0.z = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, asfloat(r2.xy)).x;
	r1.x = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, asfloat(r2.zw)).x;
	r0.y = r0.z * 0.850000024 + r0.y;
	r0.y = r1.x * 0.75 + r0.y;
	r0.y = r0.w * 0.649999976 + r0.y;
	r0.y = r0.y * 0.105263159;
	r0.y = max(r0.y, r3.y);
	r0.z = gDeferredLightSampler2_tex.Sample(gDeferredLightSampler2, i.texcoord.xy).x;
	r0.x = max(r0.z, r0.x);
	o = r0.y * r0.x;

	return o;
}
