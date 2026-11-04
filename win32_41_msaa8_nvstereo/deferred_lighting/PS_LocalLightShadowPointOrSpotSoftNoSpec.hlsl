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
Texture2D gShadowZSamplerCache_tex : register(t14);

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
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	float4 r8;
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
		r3.xyz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r2.xyz = asint(r3.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r3.xyz = -(asfloat(r2.xyz)) + i.texcoord2.xyz;
	r0.w = asint(dot(r3.xyz, r3.xyz));
	r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r3.xyz, r3.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3.xyz = asfloat(r1.xxx) * r3.xyz;
	r0.w = asint(saturate(-(asfloat(r0.w)) * i.texcoord1.y + 1));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * 2.00001001);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -0.333333343);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(asfloat(r0.w) * 1.5);
	r1.x = asint(dot(r3.xyz, i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r1.x = asint(dot(asfloat(r0.xyz), r3.xyz));
	r1.x = asint(asfloat(r1.x) + -0.333333343);
	r1.x = asint(saturate(asfloat(r1.x) * 1.5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.xyz = asint(asfloat(r0.xyz) * float3(0.150000006, 0.150000006, 0.150000006) + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.yyy) * dShadowMatrix[1].xyz);
	r2.xyz = asint(asfloat(r0.xxx) * dShadowMatrix[0].xyz + asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.zzz) * dShadowMatrix[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.xyz) + dShadowMatrix[3].xyz);
	r0.x = (0 < asfloat(r2.z)) ? -1 : 0;
	r0.xy = (r0.xx != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r2.w = asint(-(abs(asfloat(r2.z))));
	r0.z = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.x = asint(abs(asfloat(r2.z)) + asfloat(r0.z));
	r1.x = asint(1 / asfloat(r1.x));
	r2.xy = asint(asfloat(r1.xx) * asfloat(r2.xy));
	r0.z = asint(asfloat(r0.z) * -(dShadowParam0123.w));
	r3.xy = asfloat(r2.xy) * float2(0.5, -0.5);
	r4 = asfloat(r2.xyxy) * float4(0.5, -0.5, 0.5, -0.5) + float4(0.5, 0.5, 0.5, 0);
	r1.x = asint(1 / dShadowParam0123.y);
	r2.zw = asint(asfloat(r1.xx) * r4.xy);
	r5.xy = frac(asfloat(r2.zw));
	r1.x = asint(-(r5.y) + 1);
	r2.zw = asint(r4.xy + -(dShadowParam0123.yy));
	r2.zw = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r2.zw)).xy);
	r6.x = dot(asfloat(r2.zw), asfloat(r0.xy));
	r3.zw = asfloat(r2.yx) * float2(-0.5, 0.5) + float2(0.5, 0.5);
	r2.yz = int2(1056964608, 1056964608);
	r2.x = asint(-(dShadowParam0123.y));
	r7 = asfloat(r2.yxxy) + r3.xzwy;
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r7.xy).xy);
	r6.y = dot(asfloat(r2.xy), asfloat(r0.xy));
	r8 = dShadowParam0123.y * float4(1, -1, -1, 1) + r4.xyxy;
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.xy).xy);
	r6.z = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r7.zw).xy);
	r7.x = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r4.xy).xy);
	r7.y = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.w = asint(dShadowParam0123.y);
	r4 = asfloat(r2.wzww) + r4.zwxy;
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r4.xy).xy);
	r7.z = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.zw).xy);
	r8.x = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xy = asint(asfloat(r2.zw) + r3.xz);
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r2.xy)).xy);
	r8.y = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r4.zw).xy);
	r8.z = dot(asfloat(r2.xy), asfloat(r0.xy));
	r2.xyz = (r7.xyz >= asfloat(r0.zzz)) ? -1 : 0;
	r2.xyz = r2.xyz & int3(1065353216, 1065353216, 1065353216);
	r5.z = -(r5.x) + 1;
	r5.w = 1;
	r0.x = asint(dot(asfloat(r2.zxy), r5.xzw));
	r2.xyz = (r6.xyz >= asfloat(r0.zzz)) ? -1 : 0;
	r2.xyz = r2.xyz & int3(1065353216, 1065353216, 1065353216);
	r3.xyz = r5.xwx * float3(-1, 1, 1) + float3(1, 0, 0);
	r0.y = asint(dot(asfloat(r2.xyz), r3.xyz));
	r0.x = asint(asfloat(r0.y) * asfloat(r1.x) + asfloat(r0.x));
	r2.xyz = (r8.xyz >= asfloat(r0.zzz)) ? -1 : 0;
	r2.xyz = r2.xyz & int3(1065353216, 1065353216, 1065353216);
	r0.y = asint(dot(asfloat(r2.xyz), r3.xyz));
	r0.x = asint(asfloat(r0.y) * r5.y + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * 0.333333343);
	r0.y = asint(-(dShadowParam0123.z) + 1);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y) + dShadowParam0123.z);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	o.xyz = asfloat(r0.xyz) * asfloat(r1.yzw);
	o.w = 1;

	return o;
}
