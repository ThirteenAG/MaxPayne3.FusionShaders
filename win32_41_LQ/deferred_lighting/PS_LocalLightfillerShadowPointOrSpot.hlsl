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
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
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
	float4 r3;
	float3 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = asint(asfloat(r1.x) * i.texcoord.w);
	r1.x = asint(1 / asfloat(r1.x));
	r1.xyz = asint(-(i.texcoord.xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	r2.xyz = gbufferTexture1.Load(r0.xyz).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r2.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asfloat(r0.www) * r2.xyz;
	r3.xyz = r2.xyz * float3(0.150000006, 0.150000006, 0.150000006) + asfloat(r1.xyz);
	r1.xyz = asint(-(asfloat(r1.xyz)) + i.texcoord2.xyz);
	r4 = r3.yyy * dShadowMatrix[1].xyz;
	r3.xyw = r3.xxx * dShadowMatrix[0].xyz + r4.xyz;
	r3.xyz = r3.zzz * dShadowMatrix[2].xyz + r3.xyw;
	r3.xyz = r3.xyz + dShadowMatrix[3].xyz;
	r3.w = -(abs(r3.z));
	r0.w = asint(dot(r3.xyw, r3.xyw));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.w = asint(abs(r3.z) + asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * -(dShadowParam0123.w));
	r1.w = asint(1 / asfloat(r1.w));
	r3.xy = asfloat(r1.ww) * r3.xy;
	r1.w = (0 < r3.z) ? -1 : 0;
	r3.zw = (r1.ww != 0) ? float2(0, 1) : float2(1, 0);
	r3.xy = r3.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r3.xy = gShadowZSamplerCache_tex.Sample(gShadowZSamplerCache, r3.xy).xy;
	r1.w = asint(dot(r3.xy, r3.zw));
	r0.w = (asfloat(r1.w) >= asfloat(r0.w)) ? -1 : 0;
	r1.w = asint(-(dShadowParam0123.z) + 1);
	r1.w = asint(asfloat(r1.w) * 0.333333343);
	r0.w = (r0.w != 0) ? 0 : r1.w;
	r0.w = asint(asfloat(r0.w) + dShadowParam0123.z);
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(saturate(-(asfloat(r1.w)) * i.texcoord1.y + 1));
	r1.w = asint(asfloat(r1.w) + 0.00000999999975);
	r1.w = asint(log2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) * 2.00001001);
	r1.w = asint(exp2(asfloat(r1.w)));
	r1 = asint(asfloat(r1) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, -0.333333343));
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(asfloat(r1.w) * 1.5);
	r2.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r2.w = rsqrt(r2.w);
	r1.xyz = asint(asfloat(r1.xyz) * r2.www);
	r2.w = dot(asfloat(r1.xyz), i.texcoord3.xyz);
	r1.x = asint(dot(r2.xyz, asfloat(r1.xyz)));
	r1.x = asint(asfloat(r1.x) + -0.333333343);
	r1.x = asint(saturate(asfloat(r1.x) * 1.5));
	r1.y = asint(saturate(r2.w * i.texcoord1.w + i.texcoord1.z));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.w));
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r1.xyz = asint(asfloat(r0.www) * i.texcoord4.xyz);
	o.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	o.w = 1;

	return o;
}
