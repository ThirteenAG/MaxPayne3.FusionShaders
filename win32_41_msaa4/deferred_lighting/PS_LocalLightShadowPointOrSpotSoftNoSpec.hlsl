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

SamplerState gShadowZSamplerCache : register(s14);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
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
	float4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	float4 r5;
	int4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.xyz = -(i.texcoord.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2.xyz = gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r2.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asfloat(r0.www) * r2.xyz;
	r3.xyz = asint(r2.xyz * float3(0.150000006, 0.150000006, 0.150000006) + r1.xyz);
	r1.xyz = -(r1.xyz) + i.texcoord2.xyz;
	r4.xyz = asint(asfloat(r3.yyy) * dShadowMatrix[1].xyz);
	r3.xyw = asint(asfloat(r3.xxx) * dShadowMatrix[0].xyz + asfloat(r4.xyz));
	r3.xyz = asint(asfloat(r3.zzz) * dShadowMatrix[2].xyz + asfloat(r3.xyw));
	r3.xyz = asint(asfloat(r3.xyz) + dShadowMatrix[3].xyz);
	r3.w = asint(-(abs(asfloat(r3.z))));
	r0.w = asint(dot(asfloat(r3.xyw), asfloat(r3.xyw)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.w = asfloat(r0.w) * -(dShadowParam0123.w);
	r0.w = asint(abs(asfloat(r3.z)) + asfloat(r0.w));
	r0.w = asint(1 / asfloat(r0.w));
	r3.xy = asint(asfloat(r0.ww) * asfloat(r3.xy));
	r0.w = (0 < asfloat(r3.z)) ? -1 : 0;
	r3.zw = (r0.ww != 0) ? int2(0, 1065353216) : int2(1065353216, 0);
	r4.xy = asint(asfloat(r3.xy) * float2(0.5, -0.5));
	r4.zw = asint(asfloat(r3.yx) * float2(-0.5, 0.5) + float2(0.5, 0.5));
	r5 = asfloat(r3.xyxy) * float4(0.5, -0.5, 0.5, -0.5) + float4(0.5, 0.5, 0.5, 0);
	r6.x = asint(-(dShadowParam0123.y));
	r6.yz = int2(1056964608, 1056964608);
	r7 = asfloat(r4.xzwy) + asfloat(r6.yxxy);
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r7.zw).xy);
	r4.yw = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r7.xy).xy);
	r7.y = dot(asfloat(r4.yw), asfloat(r3.zw));
	r8.x = dot(asfloat(r3.xy), asfloat(r3.zw));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r5.xy).xy);
	r8.y = dot(asfloat(r3.xy), asfloat(r3.zw));
	r6.w = asint(dShadowParam0123.y);
	r9 = r5.zwxy + asfloat(r6.wzww);
	r3.xy = asint(asfloat(r4.xz) + asfloat(r6.zw));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r3.xy)).xy);
	r4.y = asint(dot(asfloat(r3.xy), asfloat(r3.zw)));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r9.xy).xy);
	r5.zw = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r9.zw).xy;
	r4.z = asint(dot(r5.zw, asfloat(r3.zw)));
	r8.z = dot(asfloat(r3.xy), asfloat(r3.zw));
	r6.xyz = (r8.xyz >= r1.www) ? -1 : 0;
	r6.xyz = r6.xyz & int3(1065353216, 1065353216, 1065353216);
	r0.w = asint(1 / dShadowParam0123.y);
	r3.xy = asint(asfloat(r0.ww) * r5.xy);
	r8.xy = frac(asfloat(r3.xy));
	r8.z = -(r8.x) + 1;
	r8.w = 1;
	r0.w = asint(dot(asfloat(r6.zxy), r8.xzw));
	r6.xyz = asint(r8.xwx * float3(-1, 1, 1) + float3(1, 0, 0));
	r3.xy = asint(r5.xy + -(dShadowParam0123.yy));
	r5 = dShadowParam0123.y * float4(1, -1, -1, 1) + r5.xyxy;
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, asfloat(r3.xy)).xy);
	r7.x = dot(asfloat(r3.xy), asfloat(r3.zw));
	r3.xy = asint(gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r5.xy).xy);
	r5.xy = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r5.zw).xy;
	r4.x = asint(dot(r5.xy, asfloat(r3.zw)));
	r7.z = dot(asfloat(r3.xy), asfloat(r3.zw));
	r3.xyz = (r7.xyz >= r1.www) ? -1 : 0;
	r4.xyz = (asfloat(r4.xyz) >= r1.www) ? -1 : 0;
	r4.xyz = r4.xyz & int3(1065353216, 1065353216, 1065353216);
	r1.w = dot(asfloat(r4.xyz), asfloat(r6.xyz));
	r3.xyz = r3.xyz & int3(1065353216, 1065353216, 1065353216);
	r2.w = dot(asfloat(r3.xyz), asfloat(r6.xyz));
	r3.x = asint(-(r8.y) + 1);
	r0.w = asint(r2.w * asfloat(r3.x) + asfloat(r0.w));
	r0.w = asint(r1.w * r8.y + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * 0.333333343);
	r1.w = -(dShadowParam0123.z) + 1;
	r0.w = asint(asfloat(r0.w) * r1.w + dShadowParam0123.z);
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = saturate(-(r1.w) * i.texcoord1.y + 1);
	r1.w = r1.w + 0.00000999999975;
	r1.w = log2(r1.w);
	r1.w = r1.w * 2.00001001;
	r1.w = exp2(r1.w);
	r1 = r1 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, -0.333333343);
	r1.w = max(r1.w, 0);
	r1.w = r1.w * 1.5;
	r2.w = dot(r1.xyz, r1.xyz);
	r2.w = rsqrt(r2.w);
	r1.xyz = r1.xyz * r2.www;
	r2.w = dot(r1.xyz, i.texcoord3.xyz);
	r1.x = dot(r2.xyz, r1.xyz);
	r1.x = r1.x + -0.333333343;
	r1.x = saturate(r1.x * 1.5);
	r1.y = saturate(r2.w * i.texcoord1.w + i.texcoord1.z);
	r1.y = r1.y * r1.w;
	r1.x = r1.x * r1.y;
	r0.w = asint(asfloat(r0.w) * r1.x);
	r1.xyz = asfloat(r0.www) * i.texcoord4.xyz;
	o.xyz = asfloat(r0.xyz) * r1.xyz;
	o.w = 1;

	return o;
}
