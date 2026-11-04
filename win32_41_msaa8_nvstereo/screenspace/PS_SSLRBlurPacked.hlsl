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

	float3 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xy = sv_position.xy * gooDeferredLightScreenSize.zw;
	r1 = gooDeferredLightScreenSize.zwzw * float4(-1, -0.5, 0.5, -1) + r0.xyxy;
	r2.xyz = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.xy).xyz;
	r1.xyz = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r1.zw).xyz;
	r1.xyz = r1.xyz + r2.xyz;
	r2 = gooDeferredLightScreenSize.zwzw * float4(-0.5, 1, 1, 0.5) + r0.xyxy;
	r0 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r0.xy).xyz;
	r3 = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.xy).xyz;
	r2.xyz = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r2.zw).xyz;
	r1.xyz = r1.xyz + r3.xyz;
	r1.xyz = r2.xyz + r1.xyz;
	r0 = r0.xyz * float3(0.5, 0.5, 0.5) + r1.xyz;
	o.xyz = r0.xyz * float3(0.222222224, 0.222222224, 0.222222224);
	o.w = 0;

	return o;
}
