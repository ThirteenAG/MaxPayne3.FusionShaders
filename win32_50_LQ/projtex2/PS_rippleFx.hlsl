cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
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

cbuffer ProjectedParam : register(b7)
{
	float4 gLightSettings : packoffset(c0);
};

SamplerState gDecalSampler : register(s0);
SamplerState gDecalNormalSampler : register(s1);
Texture2D gDecalSampler_tex : register(t0);
Texture2D gDecalNormalSampler_tex : register(t1);
Texture2D<float> gbufferTextureDepth : register(t8);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xyz).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.x = asint(asfloat(r0.x) * i.texcoord.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.xy = asint(-(i.texcoord.xy) * asfloat(r0.xx) + gViewInverse[3].xy);
	r0.xy = asint(asfloat(r0.xy) + -(i.texcoord2.xy));
	r1.x = dot(i.texcoord1.xy, asfloat(r0.xy));
	r1.y = dot(i.texcoord1.zw, asfloat(r0.xy));
	r0.x = asint(i.texcoord2.w * 0.5);
	r0.xy = asint(r1.xy * asfloat(r0.xx) + float2(0.5, 0.5));
	r1.xyz = gDecalNormalSampler_tex.Sample(gDecalNormalSampler, asfloat(r0.xy)).xyz;
	r0 = asint(gDecalSampler_tex.Sample(gDecalSampler, asfloat(r0.xy)));
	r1.xyz = r1.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.w = 0;
	r1.xzw = r1.xxx * i.texcoord6.xyz + r1.wwz;
	r1.xyz = r1.yyy * i.texcoord7.xyz + r1.xzw;
	r1.x = saturate(dot(r1.xyz, -(gDirectionalLight.xyz)));
	r1.y = r1.x + 0.0500000007;
	r1.x = log2(r1.x);
	r1.x = r1.x * gLightSettings.y;
	r1.x = exp2(r1.x);
	r1.x = r1.x * gLightSettings.x;
	r1.y = min(r1.y, 1);
	r1.y = min(r1.y, gLightSettings.z);
	r0.xyz = asint(asfloat(r0.xyz) * r1.yyy);
	o.w = asfloat(r0.w) * i.texcoord6.w;
	r0.xyz = asint(asfloat(r0.xyz) * gLightSettings.www + r1.xxx);
	r0.xyz = asint(asfloat(r0.xyz) * gDirectionalColour.www);
	o.xyz = asfloat(r0.xyz) * globalScalars4.xxx;

	return o;
}
