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
	int4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	int4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 r12;
	float4 r13;
	float4 r14;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r2 = asint(gbufferTexture0.Load(r0.xyw));
	r3 = gbufferTexture2.Load(r0.xyw);
	r0 = asint(gbufferTexture1.Load(r0.xyz));
	r1.yzw = asint(asfloat(r2.xyz) * asfloat(r2.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2 = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)));
		r1.x = asint(asfloat(r1.x) + -(asfloat(r2.y)));
		r1.x = asint(asfloat(r1.x) * asfloat(r2.x));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r2.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0);
		r2.xyz = asint(r4.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r0.w = asint(r3.y * r3.y);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0);
	r3.yzw = r4.xyz + gViewInverse[3].xyz;
	r3.yzw = asfloat(r2.xyz) + -(r3.yzw);
	r3.yzw = r3.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r3.yzw, r3.yzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3.yzw = asfloat(r1.xxx) * r3.yzw;
	r4.xyz = -(asfloat(r2.xyz)) + i.texcoord2.xyz;
	r5 = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r5.xyz, r5.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r5 = asfloat(r1.xxx) * r5.xyz;
	r1.x = asint(dot(r4.xyz, r4.xyz));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(saturate(-(asfloat(r1.x)) * gDeferredLightRadiusProjShearParams.y + 1));
	r4.xyz = asfloat(r1.xxx) * i.texcoord4.xyz;
	r1.x = asint(dot(r5.xyz, i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r4.xyz = asfloat(r1.xxx) * r4.xyz;
	r2.xyz = asint(asfloat(r0.xyz) * float3(0.100000001, 0.100000001, 0.100000001) + asfloat(r2.xyz));
	r6.xyz = asint(asfloat(r2.yyy) * dShadowMatrix[1].xyz);
	r2.xyw = asint(asfloat(r2.xxx) * dShadowMatrix[0].xyz + asfloat(r6.xyz));
	r2.xyz = asint(asfloat(r2.zzz) * dShadowMatrix[2].xyz + asfloat(r2.xyw));
	r2.xyz = asint(asfloat(r2.xyz) + dShadowMatrix[3].xyz);
	r1.x = (0 < asfloat(r2.z)) ? -1 : 0;
	r6.xy = (r1.xx != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r2.w = asint(-(abs(asfloat(r2.z))));
	r1.x = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r2.z = asint(abs(asfloat(r2.z)) + asfloat(r1.x));
	r2.z = asint(1 / asfloat(r2.z));
	r2.xy = asint(asfloat(r2.zz) * asfloat(r2.xy));
	r1.x = asint(asfloat(r1.x) * -(dShadowParam0123.w));
	r7.xy = asfloat(r2.xy) * float2(0.5, -0.5);
	r8 = asfloat(r2.xyxy) * float4(0.5, -0.5, 0.5, -0.5) + float4(0.5, 0.5, 0.5, 0);
	r2.z = asint(1 / dShadowParam0123.y);
	r2.zw = asint(asfloat(r2.zz) * r8.xy);
	r9.xy = frac(asfloat(r2.zw));
	r2.z = asint(-(r9.y) + 1);
	r6.zw = asint(r8.xy + -(dShadowParam0123.yy));
	r10 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r6.zw));
	r10.x = dot(r10.xy, asfloat(r6.xy));
	r7.zw = asfloat(r2.yx) * float2(-0.5, 0.5) + float2(0.5, 0.5);
	r11.yz = float2(0.5, 0.5);
	r11.x = -(dShadowParam0123.y);
	r12 = r7.xzwy + r11.yxxy;
	r13 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r12.xy);
	r10.y = dot(r13.xy, asfloat(r6.xy));
	r13 = dShadowParam0123.y * float4(1, -1, -1, 1) + r8.xyxy;
	r14 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r13.xy);
	r10.z = dot(r14.xy, asfloat(r6.xy));
	r12 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r12.zw);
	r12.x = dot(r12.xy, asfloat(r6.xy));
	r14 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.xy);
	r12.y = dot(r14.xy, asfloat(r6.xy));
	r11.w = dShadowParam0123.y;
	r8 = r8.zwxy + r11.wzww;
	r14 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.xy);
	r12.z = dot(r14.xy, asfloat(r6.xy));
	r13 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r13.zw);
	r13.x = dot(r13.xy, asfloat(r6.xy));
	r2.xy = asint(r7.xz + r11.zw);
	r7 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r2.xy));
	r13.y = dot(r7.xy, asfloat(r6.xy));
	r7 = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r8.zw);
	r13.z = dot(r7.xy, asfloat(r6.xy));
	r2.xyw = (r12.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r2.xyw = r2.xyw & int3(1065353216, 1065353216, 1065353216);
	r9.z = -(r9.x) + 1;
	r9.w = 1;
	r2.x = asint(dot(asfloat(r2.wxy), r9.xzw));
	r6.xyz = (r10.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r6.xyz = r6.xyz & int3(1065353216, 1065353216, 1065353216);
	r7.xyz = r9.xwx * float3(-1, 1, 1) + float3(1, 0, 0);
	r2.y = asint(dot(asfloat(r6.xyz), r7.xyz));
	r2.x = asint(asfloat(r2.y) * asfloat(r2.z) + asfloat(r2.x));
	r2.yzw = (r13.xyz >= asfloat(r1.xxx)) ? -1 : 0;
	r2.yzw = r2.yzw & int3(1065353216, 1065353216, 1065353216);
	r1.x = asint(dot(asfloat(r2.yzw), r7.xyz));
	r1.x = asint(asfloat(r1.x) * r9.y + asfloat(r2.x));
	r1.x = asint(asfloat(r1.x) * 0.333333343);
	r2.x = asint(-(dShadowParam0123.z) + 1);
	r1.x = asint(asfloat(r1.x) * asfloat(r2.x) + dShadowParam0123.z);
	r2.xyz = asint(asfloat(r1.xxx) * r4.xyz);
	r1.x = asint(dot(r3.yzw, asfloat(r0.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r3.yzw = asfloat(r0.xyz) * -(asfloat(r1.xxx)) + r3.yzw;
	r1.x = asint(saturate(dot(r5.xyz, r3.yzw)));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(dot(r5.xyz, asfloat(r0.xyz)));
	r0.y = asint(asfloat(r0.x) + 0.5);
	r0.y = asint(saturate(asfloat(r0.y) * 0.25));
	r0.x = asint(saturate(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.x) + asfloat(r0.y));
	r3.yzw = asfloat(r0.yyy) * asfloat(r2.xyz);
	r0.x = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * r3.xxx);
	o.xyz = asfloat(r1.yzw) * r3.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
