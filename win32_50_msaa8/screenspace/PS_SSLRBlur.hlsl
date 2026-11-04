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
};

SamplerState gDeferredLightSampler1 : register(s1);
Texture2D gDeferredLightSampler1_tex : register(t1);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = sv_position.xy * gooDeferredLightScreenSize.zw;
	r1 = gooDeferredLightScreenSize.zwzw * float4(-1, -0.5, 0.5, -1) + r0.xyxy;
	r2 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.xy);
	r1 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.zw);
	r1 = r1 + r2;
	r2 = gooDeferredLightScreenSize.zwzw * float4(-0.5, 1, 1, 0.5) + r0.xyxy;
	r0 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r0.xy);
	r3 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.xy);
	r2 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.zw);
	r1 = r1 + r3;
	r1 = r2 + r1;
	r0 = r0 * float4(0.5, 0.5, 0.5, 0.5) + r1;
	o = r0 * float4(0.222222224, 0.222222224, 0.222222224, 0.222222224);

	return o;
}
