cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer LocalShadowParam : register(b4)
{
	float4 dShadowParam0123 : packoffset(c0);
	row_major float4x4 dShadowMatrix : packoffset(c1);
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
SamplerState gShadowZSamplerCache : register(s14);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);
Texture2D ShadowZTextureCache : register(t14);

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
	float4 r1;
	float4 r2;
	float4 r3;
	int4 r4;
	float3 r5;
	float3 r6;
	float4 r7;
	int4 r8;
	int4 r9;
	int4 r10;
	int4 r11;
	int4 r12;
	int4 r13;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.yzw = gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz;
	r2.xy = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xy;
	r0.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.w = asint(r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3.xyz = -(i.texcoord.xyz) * asfloat(r0.www) + gViewInverse[3].xyz;
	r1.x = r2.y * r2.y;
	r1 = r1 * r1;
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.y = dot(asfloat(r0.xyz), asfloat(r0.xyz));
	r2.y = rsqrt(r2.y);
	r0.xyz = asint(asfloat(r0.xyz) * r2.yyy);
	r2.yzw = r3.xyz + -(i.texcoord2.xyz);
	r4.xyz = asint(-(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx);
	r4.xyz = asint(-(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(asfloat(r4.xyz)));
	r4.x = asint(dot(asfloat(r4.xyz), r2.yzw));
	r4.y = asint(dot(gDeferredLightTangent.xyz, r2.yzw));
	r3.w = dot(-(gDeferredLightDirection.xyz), r2.yzw);
	r4.z = (gDeferredLightType == 2) ? -1 : 0;
	r4.w = asint(abs(gDeferredLightConeOffset) + 60);
	r4.w = asint(120 / asfloat(r4.w));
	r4.w = asint(asfloat(r4.w) * gDeferredLightConeAngle);
	r4.w = asint(asfloat(r4.w) * asfloat(r4.w));
	r4.w = asint(r3.w * asfloat(r4.w));
	r4.w = asint(-1 / asfloat(r4.w));
	r5.xy = asfloat(r4.ww) * asfloat(r4.xy);
	r2.y = dot(r2.yzw, r2.yzw);
	r2.y = sqrt(r2.y);
	r2.z = r3.w / r2.y;
	r2.z = -(r2.z) + 1;
	r2.y = r2.z * r2.y;
	r2.y = 1 / r2.y;
	r2.yz = r2.yy * asfloat(r4.xy);
	r2.yz = (r4.zz != 0) ? r5.xy : r2.yz;
	r2.yz = r2.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
	r2.yzw = gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, r2.yz, 0).xyz;
	r4.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r4.xyz = asint(asfloat(r0.www) * asfloat(r4.xyz));
	r5 = -(r3.xyz) + i.texcoord2.xyz;
	r0.w = asint(dot(r5.xyz, r5.xyz));
	r5 = r5.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = dot(r5.xyz, r5.xyz);
	r3.w = rsqrt(r3.w);
	r5 = r3.www * r5.xyz;
	r0.w = asint(saturate(-(asfloat(r0.w)) * i.texcoord1.y + 1));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * 4.00001001);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -0.100000001);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(asfloat(r0.w) * 1.11111116);
	r6 = asfloat(r0.www) * i.texcoord4.xyz;
	r0.w = asint(dot(r5.xyz, i.texcoord3.xyz));
	r0.w = asint(saturate(asfloat(r0.w) * i.texcoord1.w + i.texcoord1.z));
	r6 = asfloat(r0.www) * r6.xyz;
	r3.xyz = asfloat(r0.xyz) * float3(0.100000001, 0.100000001, 0.100000001) + r3.xyz;
	r7.xyz = r3.yyy * dShadowMatrix[1].xyz;
	r3.xyw = r3.xxx * dShadowMatrix[0].xyz + r7.xyz;
	r3.xyz = r3.zzz * dShadowMatrix[2].xyz + r3.xyw;
	r3.xyz = r3.xyz + dShadowMatrix[3].xyz;
	r0.w = (0 < r3.z) ? -1 : 0;
	r3.w = -(abs(r3.z));
	r3.w = dot(r3.xyw, r3.xyw);
	r3.w = sqrt(r3.w);
	r3.z = abs(r3.z) + r3.w;
	r3.z = 1 / r3.z;
	r3.xy = r3.zz * r3.xy;
	r3.z = r3.w * -(dShadowParam0123.w);
	r3.xy = r3.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r7 = r3.xxyy / dShadowParam0123.y;
	r7 = frac(r7);
	r8.xy = (float2(0.5, 0.5) < r7.yw) ? -1 : 0;
	r7 = r7 + float4(-0.5, 0.5, -0.5, 0.5);
	r7.xy = (r8.xy != 0) ? r7.xz : r7.yw;
	r7.zw = r3.xy + -(dShadowParam0123.yy);
	if (r0.w == 0) {
		r8 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, r7.zw));
		r8 = (asfloat(r8) >= r3.z) ? -1 : 0;
		r8 = r8.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r9.xy = r8.zw;
	} else {
		r10 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, r7.zw));
		r10 = (asfloat(r10) >= r3.z) ? -1 : 0;
		r8 = r10.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r9.xy = r8.zw;
	}
	r7.zw = -(asfloat(r8.yx)) + asfloat(r9.xy);
	r7.zw = r7.yy * r7.zw + asfloat(r8.yx);
	r3.w = -(r7.z) + r7.w;
	r3.w = r7.x * r3.w + r7.z;
	r10 = asint(dShadowParam0123.y * float4(-1, 1, 1, -1) + r3.xyxy);
	if (r0.w == 0) {
		r11 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r10.xy)));
		r11 = (asfloat(r11) >= r3.z) ? -1 : 0;
		r11 = r11.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r12.xy = r11.zw;
	} else {
		r13 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r10.xy)));
		r13 = (asfloat(r13) >= r3.z) ? -1 : 0;
		r11 = r13.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r12.xy = r11.zw;
	}
	r7.zw = -(asfloat(r11.yx)) + asfloat(r12.xy);
	r7.zw = r7.yy * r7.zw + asfloat(r11.yx);
	r4.w = asint(-(r7.z) + r7.w);
	r4.w = asint(r7.x * asfloat(r4.w) + r7.z);
	r3.w = r3.w + asfloat(r4.w);
	if (r0.w == 0) {
		r13 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r10.zw)));
		r13 = (asfloat(r13) >= r3.z) ? -1 : 0;
		r13 = r13 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r9.zw = r13.xy;
		r8.zw = r13.zw;
	} else {
		r10 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r10.zw)));
		r10 = (asfloat(r10) >= r3.z) ? -1 : 0;
		r10 = r10 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r9.zw = r10.xy;
		r8.zw = r10.zw;
	}
	r10 = asint(-(asfloat(r8.wzxw)) + asfloat(r9.zwyz));
	r8 = asint(r7.y * asfloat(r10) + asfloat(r8.wzxw));
	r7.zw = -(asfloat(r8.xz)) + asfloat(r8.yw);
	r7.zw = r7.xx * r7.zw + asfloat(r8.xz);
	r3.w = r3.w + r7.z;
	r3.xy = r3.xy + dShadowParam0123.yy;
	if (r0.w == 0) {
		r8 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, r3.xy));
		r8 = (asfloat(r8) >= r3.z) ? -1 : 0;
		r8 = r8 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r12.zw = r8.xy;
		r11.zw = r8.zw;
	} else {
		r8 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, r3.xy));
		r8 = (asfloat(r8) >= r3.z) ? -1 : 0;
		r8 = r8 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r12.zw = r8.xy;
		r11.zw = r8.zw;
	}
	r8 = asint(-(asfloat(r11.wzxw)) + asfloat(r12.zwyz));
	r8 = asint(r7.y * asfloat(r8) + asfloat(r11.wzxw));
	r3.xy = -(asfloat(r8.xz)) + asfloat(r8.yw);
	r3.xy = r7.xx * r3.xy + asfloat(r8.xz);
	r0.w = asint(r3.x + r3.w);
	r8 = asint(-(asfloat(r9.xyyz)) + asfloat(r11.yxxw));
	r8 = asint(r7.y * asfloat(r8) + asfloat(r9.xyyz));
	r3.xz = -(asfloat(r8.xz)) + asfloat(r8.yw);
	r3.xz = r7.xx * r3.xz + asfloat(r8.xz);
	r0.w = asint(asfloat(r0.w) + r3.x);
	r3.xw = -(asfloat(r9.zw)) + asfloat(r11.wz);
	r3.xw = r7.yy * r3.xw + asfloat(r9.zw);
	r3.w = -(r3.x) + r3.w;
	r3.x = r7.x * r3.w + r3.x;
	r0.w = asint(asfloat(r0.w) + r3.x);
	r0.w = asint(r7.w + asfloat(r0.w));
	r0.w = asint(r3.z + asfloat(r0.w));
	r0.w = asint(r3.y + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * 0.111111112);
	r3.x = -(dShadowParam0123.z) + 1;
	r0.w = asint(asfloat(r0.w) * r3.x + dShadowParam0123.z);
	r3.xyz = asfloat(r0.www) * r6.xyz;
	r0.w = asint(dot(asfloat(r4.xyz), asfloat(r0.xyz)));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r4.xyz = asint(asfloat(r0.xyz) * -(asfloat(r0.www)) + asfloat(r4.xyz));
	r0.w = asint(saturate(dot(r5.xyz, asfloat(r4.xyz))));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r1.x = r1.x * 196 + 0.00000999999975;
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * r1.x);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(saturate(dot(r5.xyz, asfloat(r0.xyz))));
	r0.y = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w));
	r0.yzw = asint(asfloat(r0.yyy) * r3.xyz);
	r3.xyz = asfloat(r0.xxx) * r3.xyz;
	r1.xyz = r1.yzw * r2.yzw;
	r0.xyz = asint(r2.xxx * asfloat(r0.yzw));
	o.xyz = r1.xyz * r3.xyz + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
