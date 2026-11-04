cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
};

cbuffer DeferredLight : register(b1)
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

Texture2DMS<float> gbufferTextureDepth : register(t10);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float2 r1;
	r0.xy = asint(i.sv_position.xy + i.sv_position.xy);
	r0.zw = asint(float2(1, 1) / globalScreenSize.xy);
	r1 = asfloat(r0.zw) * float2(-0.5, 0.5);
	r0.xy = asint(asfloat(r0.xy) * asfloat(r0.zw) + r1.xy);
	float3 dimensions0;
	gbufferTextureDepth.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.zw = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * asfloat(r0.zw));
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTextureDepth.Load(r0.xy, 0).x);
	r0.x = asint(asfloat(r0.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	o = float4(1, 1, 1, 1) / asfloat(r0.x);

	return o;
}
