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
SamplerState StereoParmsTex : register(s9);
Texture2D gDecalSampler_tex : register(t0);
Texture2D gDecalNormalSampler_tex : register(t1);
Texture2D StereoParmsTex_tex : register(t9);
Texture2DMS<float> gbufferTextureDepth : register(t11);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.y = (i.texcoord.w == 1) ? -1 : 0;
	if (r0.y != 0) {
		r0.y = asint(1 / asfloat(r0.x));
		r0.zw = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r0.y = asint(-(asfloat(r0.w)) + asfloat(r0.y));
		r0.y = asint(asfloat(r0.y) * asfloat(r0.z));
		r0.y = asint(asfloat(r0.y) * gDeferredProjParams.x);
		r0.yz = asint(-(gViewInverse[0].xy) * asfloat(r0.yy) + gViewInverse[3].xy);
	} else {
		r1.xy = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xy;
		r0.yz = asint(r1.xy + gViewInverse[3].xy);
	}
	r0.x = asint(asfloat(r0.x) * i.texcoord.w);
	r0.x = asint(1 / asfloat(r0.x));
	r0.xy = asint(-(i.texcoord.xy) * asfloat(r0.xx) + asfloat(r0.yz));
	r0.xy = asint(asfloat(r0.xy) + -(i.texcoord2.xy));
	r1.x = dot(i.texcoord1.xy, asfloat(r0.xy));
	r1.y = dot(i.texcoord1.zw, asfloat(r0.xy));
	r0.x = asint(i.texcoord2.w * 0.5);
	r0.xy = asint(r1.xy * asfloat(r0.xx) + float2(0.5, 0.5));
	r1 = gDecalSampler_tex.Sample(gDecalSampler, asfloat(r0.xy));
	r0.xyz = asint(gDecalNormalSampler_tex.Sample(gDecalNormalSampler, asfloat(r0.xy)).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = 0;
	r0.xzw = asint(asfloat(r0.xxx) * i.texcoord6.xyz + asfloat(r0.wwz));
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord7.xyz + asfloat(r0.xzw));
	r0.x = asint(saturate(dot(asfloat(r0.xyz), -(gDirectionalLight.xyz))));
	r0.y = asint(log2(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.y) * gLightSettings.y);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.x = asint(asfloat(r0.x) + 0.0500000007);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(min(asfloat(r0.x), gLightSettings.z));
	r0.xzw = asint(r1.xyz * asfloat(r0.xxx));
	r0.y = asint(asfloat(r0.y) * gLightSettings.x);
	r0.xyz = asint(asfloat(r0.xzw) * gLightSettings.www + asfloat(r0.yyy));
	r0.xyz = asint(asfloat(r0.xyz) * gDirectionalColour.www);
	o.w = r1.w * i.texcoord6.w;
	o.xyz = asfloat(r0.xyz) * globalScalars4.xxx;

	return o;
}
