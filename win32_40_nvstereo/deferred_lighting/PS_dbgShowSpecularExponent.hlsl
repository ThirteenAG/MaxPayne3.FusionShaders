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
};

SamplerState gDeferredLightSampler : register(s0);
Texture2D gDeferredLightSampler_tex : register(t0);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	float4 r0;
	r0.xy = sv_position.xy * gooDeferredLightScreenSize.zw;
	r0 = gDeferredLightSampler_tex.Sample(gDeferredLightSampler, r0.xy);
	o.xyz = r0.yyy;
	o.w = 1;

	return o;
}
