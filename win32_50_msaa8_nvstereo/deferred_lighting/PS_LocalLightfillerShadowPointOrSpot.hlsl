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

SamplerState StereoParmsTex : register(s9);
SamplerState gShadowZSamplerCache : register(s14);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2DMS<float> gbufferTextureDepth : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
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
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	int4 r7;
	int4 r8;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2.xy = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(asfloat(r1.x) + -(asfloat(r2.y)));
		r1.x = asint(asfloat(r1.x) * asfloat(r2.x));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r2.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r3.xyz = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz);
		r2.xyz = asint(asfloat(r3.xyz) + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r3.xyz = asint(-(asfloat(r2.xyz)) + i.texcoord2.xyz);
	r0.w = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r3.xyz = asint(asfloat(r3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3.xyz = asint(asfloat(r1.xxx) * asfloat(r3.xyz));
	r0.w = asint(saturate(-(asfloat(r0.w)) * i.texcoord1.y + 1));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * 2.00001001);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -0.333333343);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(asfloat(r0.w) * 1.5);
	r1.x = asint(dot(asfloat(r3.xyz), i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r3.xyz)));
	r1.x = asint(asfloat(r1.x) + -0.333333343);
	r1.x = asint(saturate(asfloat(r1.x) * 1.5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.xyz = asint(asfloat(r0.xyz) * float3(0.150000006, 0.150000006, 0.150000006) + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.yyy) * dShadowMatrix[1].xyz);
	r2.xyz = asint(asfloat(r0.xxx) * dShadowMatrix[0].xyz + asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.zzz) * dShadowMatrix[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.xyz) + dShadowMatrix[3].xyz);
	r0.x = (0 < asfloat(r2.z)) ? -1 : 0;
	r2.w = asint(-(abs(asfloat(r2.z))));
	r0.y = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.z = asint(abs(asfloat(r2.z)) + asfloat(r0.y));
	r0.z = asint(1 / asfloat(r0.z));
	r2.xy = asint(asfloat(r0.zz) * asfloat(r2.xy));
	r0.y = asint(asfloat(r0.y) * -(dShadowParam0123.w));
	r2.xy = asint(asfloat(r2.xy) * float2(0.5, -0.5) + float2(0.5, 0.5));
	r3 = asint(asfloat(r2.xxyy) / dShadowParam0123.y);
	r3 = asint(frac(asfloat(r3)));
	r2.zw = (float2(0.5, 0.5) < asfloat(r3.yw)) ? -1 : 0;
	r3 = asint(asfloat(r3) + float4(-0.5, 0.5, -0.5, 0.5));
	r2.zw = (r2.zw != 0) ? r3.xz : r3.yw;
	r3.xy = asint(asfloat(r2.xy) + -(dShadowParam0123.yy));
	if (r0.x == 0) {
		r4 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r3.xy)));
		r4 = (asfloat(r4) >= asfloat(r0.y)) ? -1 : 0;
		r4 = r4.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r5.xy = r4.zw;
	} else {
		r3 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r3.xy)));
		r3 = (asfloat(r3) >= asfloat(r0.y)) ? -1 : 0;
		r4 = r3.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r5.xy = r4.zw;
	}
	r3.xy = asint(-(asfloat(r4.yx)) + asfloat(r5.xy));
	r3.xy = asint(asfloat(r2.ww) * asfloat(r3.xy) + asfloat(r4.yx));
	r0.z = asint(-(asfloat(r3.x)) + asfloat(r3.y));
	r0.z = asint(asfloat(r2.z) * asfloat(r0.z) + asfloat(r3.x));
	r3 = asint(dShadowParam0123.y * float4(-1, 1, 1, -1) + asfloat(r2.xyxy));
	if (r0.x == 0) {
		r6 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r3.xy)));
		r6 = (asfloat(r6) >= asfloat(r0.y)) ? -1 : 0;
		r6 = r6.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r7.xy = r6.zw;
	} else {
		r8 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r3.xy)));
		r8 = (asfloat(r8) >= asfloat(r0.y)) ? -1 : 0;
		r6 = r8.zwxy & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r7.xy = r6.zw;
	}
	r3.xy = asint(-(asfloat(r6.yx)) + asfloat(r7.xy));
	r3.xy = asint(asfloat(r2.ww) * asfloat(r3.xy) + asfloat(r6.yx));
	r1.x = asint(-(asfloat(r3.x)) + asfloat(r3.y));
	r1.x = asint(asfloat(r2.z) * asfloat(r1.x) + asfloat(r3.x));
	r0.z = asint(asfloat(r0.z) + asfloat(r1.x));
	if (r0.x == 0) {
		r8 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r3.zw)));
		r8 = (asfloat(r8) >= asfloat(r0.y)) ? -1 : 0;
		r8 = r8 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r5.zw = r8.xy;
		r4.zw = r8.zw;
	} else {
		r3 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r3.zw)));
		r3 = (asfloat(r3) >= asfloat(r0.y)) ? -1 : 0;
		r3 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r5.zw = r3.xy;
		r4.zw = r3.zw;
	}
	r3 = asint(-(asfloat(r4.wzxw)) + asfloat(r5.zwyz));
	r3 = asint(asfloat(r2.w) * asfloat(r3) + asfloat(r4.wzxw));
	r3.yw = asint(-(asfloat(r3.xz)) + asfloat(r3.yw));
	r3.xy = asint(asfloat(r2.zz) * asfloat(r3.yw) + asfloat(r3.xz));
	r0.z = asint(asfloat(r0.z) + asfloat(r3.x));
	r2.xy = asint(asfloat(r2.xy) + dShadowParam0123.yy);
	if (r0.x == 0) {
		r4 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r2.xy)));
		r4 = (asfloat(r4) >= asfloat(r0.y)) ? -1 : 0;
		r4 = r4 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r7.zw = r4.xy;
		r6.zw = r4.zw;
	} else {
		r4 = asint(ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r2.xy)));
		r4 = (asfloat(r4) >= asfloat(r0.y)) ? -1 : 0;
		r4 = r4 & int4(1065353216, 1065353216, 1065353216, 1065353216);
		r7.zw = r4.xy;
		r6.zw = r4.zw;
	}
	r4 = asint(-(asfloat(r6.wzxw)) + asfloat(r7.zwyz));
	r4 = asint(asfloat(r2.w) * asfloat(r4) + asfloat(r6.wzxw));
	r0.xy = asint(-(asfloat(r4.xz)) + asfloat(r4.yw));
	r0.xy = asint(asfloat(r2.zz) * asfloat(r0.xy) + asfloat(r4.xz));
	r0.x = asint(asfloat(r0.x) + asfloat(r0.z));
	r4 = asint(-(asfloat(r5.xyyz)) + asfloat(r6.yxxw));
	r4 = asint(asfloat(r2.w) * asfloat(r4) + asfloat(r5.xyyz));
	r2.xy = asint(-(asfloat(r4.xz)) + asfloat(r4.yw));
	r2.xy = asint(asfloat(r2.zz) * asfloat(r2.xy) + asfloat(r4.xz));
	r0.x = asint(asfloat(r0.x) + asfloat(r2.x));
	r3.xz = asint(-(asfloat(r5.zw)) + asfloat(r6.wz));
	r2.xw = asint(asfloat(r2.ww) * asfloat(r3.xz) + asfloat(r5.zw));
	r0.z = asint(-(asfloat(r2.x)) + asfloat(r2.w));
	r0.z = asint(asfloat(r2.z) * asfloat(r0.z) + asfloat(r2.x));
	r0.x = asint(asfloat(r0.z) + asfloat(r0.x));
	r0.x = asint(asfloat(r3.y) + asfloat(r0.x));
	r0.x = asint(asfloat(r2.y) + asfloat(r0.x));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * 0.111111112);
	r0.y = asint(-(dShadowParam0123.z) + 1);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y) + dShadowParam0123.z);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	o.xyz = asfloat(r0.xyz) * asfloat(r1.yzw);
	o.w = 1;

	return o;
}
