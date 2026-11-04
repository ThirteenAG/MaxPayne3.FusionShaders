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
Texture2D gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);
Texture2D gShadowZSamplerCache_tex : register(t14);

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
	int4 r1;
	float4 r2;
	int4 r3;
	float3 r4;
	float3 r5;
	int4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float3 r10;
	float4 r11;
	float4 r12;
	float4 r13;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r2.xy = gbufferTexture2.Load(r0.xyw).xy;
	r0.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2.zw = StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy;
		r1.x = asint(asfloat(r1.x) + -(r2.w));
		r1.x = asint(asfloat(r1.x) * r2.z);
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r3.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r3.xyz = asint(r4.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r3.xyz));
	r0.w = asint(r2.y * r2.y);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r2.yzw = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r2.yzw = r2.yzw + gViewInverse[3].xyz;
	r2.yzw = -(r2.yzw) + asfloat(r3.xyz);
	r2.yzw = r2.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r2.yzw, r2.yzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r2.yzw = asfloat(r1.xxx) * r2.yzw;
	r4 = -(asfloat(r3.xyz)) + i.texcoord2.xyz;
	r1.x = asint(dot(r4.xyz, r4.xyz));
	r4 = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = asint(dot(r4.xyz, r4.xyz));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r4 = asfloat(r3.www) * r4.xyz;
	r1.x = asint(saturate(-(asfloat(r1.x)) * i.texcoord1.y + 1));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * 4.00001001);
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) + -0.100000001);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(asfloat(r1.x) * 1.11111116);
	r5 = asfloat(r1.xxx) * i.texcoord4.xyz;
	r1.x = asint(dot(r4.xyz, i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r5 = asfloat(r1.xxx) * r5.xyz;
	r3.xyz = asint(asfloat(r0.xyz) * float3(0.100000001, 0.100000001, 0.100000001) + asfloat(r3.xyz));
	r6.xyz = asint(asfloat(r3.yyy) * dShadowMatrix[1].xyz);
	r3.xyw = asint(asfloat(r3.xxx) * dShadowMatrix[0].xyz + asfloat(r6.xyz));
	r3.xyz = asint(asfloat(r3.zzz) * dShadowMatrix[2].xyz + asfloat(r3.xyw));
	r3.xyz = asint(asfloat(r3.xyz) + dShadowMatrix[3].xyz);
	r1.x = (0 < asfloat(r3.z)) ? -1 : 0;
	r6.xy = (r1.xx != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r3.w = asint(-(abs(asfloat(r3.z))));
	r1.x = asint(dot(asfloat(r3.xyw), asfloat(r3.xyw)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r3.z = asint(abs(asfloat(r3.z)) + asfloat(r1.x));
	r3.z = asint(1 / asfloat(r3.z));
	r3.xy = asint(asfloat(r3.zz) * asfloat(r3.xy));
	r1.x = asint(asfloat(r1.x) * -(dShadowParam0123.w));
	r7.xy = asfloat(r3.xy) * float2(0.5, -0.5);
	r8 = asfloat(r3.xyxy) * float4(0.5, -0.5, 0.5, -0.5) + float4(0.5, 0.5, 0.5, 0);
	r3.z = asint(1 / dShadowParam0123.y);
	r3.zw = asint(asfloat(r3.zz) * r8.xy);
	r9.xy = frac(asfloat(r3.zw));
	r3.z = asint(-(r9.y) + 1);
	r6.zw = asint(r8.xy + -(dShadowParam0123.yy));
	r6.zw = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r6.zw)).xy);
	r10.x = dot(asfloat(r6.zw), asfloat(r6.xy));
	r7.zw = asfloat(r3.yx) * float2(-0.5, 0.5) + float2(0.5, 0.5);
	r11.yz = float2(0.5, 0.5);
	r11.x = -(dShadowParam0123.y);
	r12 = r7.xzwy + r11.yxxy;
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r12.xy).xy);
	r10.y = dot(asfloat(r3.xy), asfloat(r6.xy));
	r13 = dShadowParam0123.y * float4(1, -1, -1, 1) + r8.xyxy;
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r13.xy).xy);
	r10.z = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r12.zw).xy);
	r12.x = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.xy).xy);
	r12.y = dot(asfloat(r3.xy), asfloat(r6.xy));
	r11.w = dShadowParam0123.y;
	r8 = r8.zwxy + r11.wzww;
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.xy).xy);
	r12.z = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r13.zw).xy);
	r13.x = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xy = asint(r7.xz + r11.zw);
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r3.xy)).xy);
	r13.y = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.zw).xy);
	r13.z = dot(asfloat(r3.xy), asfloat(r6.xy));
	r3.xyw = (r12.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r3.xyw = r3.xyw & int3(1065353216, 1065353216, 1065353216);
	r9.z = -(r9.x) + 1;
	r9.w = 1;
	r3.x = asint(dot(asfloat(r3.wxy), r9.xzw));
	r6.xyz = (r10.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r6.xyz = r6.xyz & int3(1065353216, 1065353216, 1065353216);
	r7.xyz = r9.xwx * float3(-1, 1, 1) + float3(1, 0, 0);
	r3.y = asint(dot(asfloat(r6.xyz), r7.xyz));
	r3.x = asint(asfloat(r3.y) * asfloat(r3.z) + asfloat(r3.x));
	r3.yzw = (r13.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r3.yzw = r3.yzw & int3(1065353216, 1065353216, 1065353216);
	r1.x = asint(dot(asfloat(r3.yzw), r7.xyz));
	r1.x = asint(asfloat(r1.x) * r9.y + asfloat(r3.x));
	r1.x = asint(asfloat(r1.x) * 0.333333343);
	r3.x = asint(-(dShadowParam0123.z) + 1);
	r1.x = asint(asfloat(r1.x) * asfloat(r3.x) + dShadowParam0123.z);
	r3.xyz = asint(asfloat(r1.xxx) * r5.xyz);
	r1.x = asint(dot(r2.yzw, asfloat(r0.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r2.yzw = asfloat(r0.xyz) * -(asfloat(r1.xxx)) + r2.yzw;
	r1.x = asint(saturate(dot(r4.xyz, r2.yzw)));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(saturate(dot(r4.xyz, asfloat(r0.xyz))));
	r0.y = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w));
	r0.yzw = asint(asfloat(r0.yyy) * asfloat(r3.xyz));
	r2.yzw = asfloat(r0.xxx) * asfloat(r3.xyz);
	r0.xyz = asint(asfloat(r0.yzw) * r2.xxx);
	o.xyz = asfloat(r1.yzw) * r2.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
