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
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
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
	float3 r3;
	float4 r4;
	float3 r5;
	r0.x = asint(-(dShadowParam0123.z) + 1);
	r0.x = asint(asfloat(r0.x) * 0.333333343);
	r1.xy = (int2)i.sv_position.xy;
	r1.zw = int2(0, 0);
	r0.y = asint(gbufferTextureDepth.Load(r1.xyw).x);
	r0.y = asint(asfloat(r0.y) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.y = asint(asfloat(r0.y) * i.texcoord.w);
	r0.y = asint(1 / asfloat(r0.y));
	r2.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.yyy) + gViewInverse[3].xyz);
	r0.yzw = asint(-(i.texcoord.xyz) * asfloat(r0.yyy) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3 = gbufferTexture1.Load(r1.xyz).xyz;
	r3 = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.z = asint(dot(r3.xyz, r3.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r3 = asfloat(r1.zzz) * r3.xyz;
	r4.xyz = r3.xyz * float3(0.100000001, 0.100000001, 0.100000001) + asfloat(r2.xyz);
	r5 = r4.yyy * dShadowMatrix[1].xyz;
	r4.xyw = r4.xxx * dShadowMatrix[0].xyz + r5.xyz;
	r4.xyz = r4.zzz * dShadowMatrix[2].xyz + r4.xyw;
	r4.xyz = r4.xyz + dShadowMatrix[3].xyz;
	r4.w = -(abs(r4.z));
	r1.z = asint(dot(r4.xyw, r4.xyw));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r2.w = asint(abs(r4.z) + asfloat(r1.z));
	r1.z = asint(asfloat(r1.z) * -(dShadowParam0123.w));
	r2.w = asint(1 / asfloat(r2.w));
	r4.xy = asfloat(r2.ww) * r4.xy;
	r2.w = (0 < r4.z) ? -1 : 0;
	r4.zw = (r2.ww != 0) ? float2(0, 1) : float2(1, 0);
	r4.xy = r4.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r4.xy = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r4.xy).xy;
	r2.w = asint(dot(r4.xy, r4.zw));
	r1.z = (asfloat(r2.w) >= asfloat(r1.z)) ? -1 : 0;
	r0.x = (r1.z != 0) ? 0 : r0.x;
	r0.x = asint(asfloat(r0.x) + dShadowParam0123.z);
	r4.xyz = -(asfloat(r2.xyz)) + i.texcoord2.xyz;
	r2.xyz = asint(asfloat(r2.xyz) + -(i.texcoord2.xyz));
	r1.z = asint(dot(r4.xyz, r4.xyz));
	r4.xyz = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.z = asint(saturate(-(asfloat(r1.z)) * i.texcoord1.y + 1));
	r1.z = asint(asfloat(r1.z) + 0.00000999999975);
	r1.z = asint(log2(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) * 4.00001001);
	r1.z = asint(exp2(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) + -0.100000001);
	r1.z = asint(max(asfloat(r1.z), 0));
	r1.z = asint(asfloat(r1.z) * 1.11111116);
	r5 = asfloat(r1.zzz) * i.texcoord4.xyz;
	r1.z = asint(dot(r4.xyz, r4.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r4.xyz = asfloat(r1.zzz) * r4.xyz;
	r1.z = asint(dot(r4.xyz, i.texcoord3.xyz));
	r1.z = asint(saturate(asfloat(r1.z) * i.texcoord1.w + i.texcoord1.z));
	r5 = asfloat(r1.zzz) * r5.xyz;
	r5 = asfloat(r0.xxx) * r5.xyz;
	r0.x = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw));
	r0.w = asint(dot(asfloat(r0.xyz), r3.xyz));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r0.xyz = asint(r3.xyz * -(asfloat(r0.www)) + asfloat(r0.xyz));
	r0.w = asint(saturate(dot(r4.xyz, r3.xyz)));
	r0.x = asint(saturate(dot(r4.xyz, asfloat(r0.xyz))));
	r0.x = asint(asfloat(r0.x) + 0.00000999999975);
	r0.x = asint(log2(asfloat(r0.x)));
	r0.yz = asint(gbufferTexture2.Load(r1.xyw).xy);
	r1.xyz = asint(gbufferTexture0.Load(r1.xyw).xyz);
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.xyz));
	r0.z = asint(asfloat(r0.z) * asfloat(r0.z));
	r0.z = asint(asfloat(r0.z) * asfloat(r0.z));
	r0.z = asint(asfloat(r0.z) * 196 + 0.00000999999975);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.z));
	r0.x = asint(exp2(asfloat(r0.x)));
	r0.z = asint(saturate(asfloat(r0.w) * 2 + -0.5));
	r3 = asfloat(r0.www) * r5.xyz;
	r0.x = asint(asfloat(r0.z) * asfloat(r0.x));
	r0.xzw = asint(asfloat(r0.xxx) * r5.xyz);
	r0.xyz = asint(asfloat(r0.yyy) * asfloat(r0.xzw));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.w = asint(dot(-(gDeferredLightDirection.xyz), asfloat(r2.xyz)));
	r2.w = asint(asfloat(r1.w) / asfloat(r0.w));
	r2.w = asint(-(asfloat(r2.w)) + 1);
	r0.w = asint(asfloat(r0.w) * asfloat(r2.w));
	r0.w = asint(1 / asfloat(r0.w));
	r4.xyz = -(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx;
	r4.xyz = -(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(r4.xyz);
	r4.x = dot(r4.xyz, asfloat(r2.xyz));
	r4.y = dot(gDeferredLightTangent.xyz, asfloat(r2.xyz));
	r2.xy = asint(asfloat(r0.ww) * r4.xy);
	r0.w = asint(abs(gDeferredLightConeOffset) + 60);
	r0.w = asint(120 / asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gDeferredLightConeAngle);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.w = asint(asfloat(r1.w) * asfloat(r0.w));
	r0.w = asint(-1 / asfloat(r0.w));
	r2.zw = asint(asfloat(r0.ww) * r4.xy);
	r0.w = (gDeferredLightType == 2) ? -1 : 0;
	r2.xy = (r0.ww != 0) ? r2.zw : r2.xy;
	r2.xy = asint(asfloat(r2.xy) * float2(0.5, 0.5) + float2(0.5, 0.5));
	r2.xyz = asint(gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, asfloat(r2.xy), 0).xyz);
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xyz));
	o.xyz = asfloat(r1.xyz) * r3.xyz + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
