cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float4 gDeferredLightShaftParams : packoffset(c9);
	float4 gDeferredLightVolumeParams : packoffset(c10);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = position.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.w = gDeferredLightRadiusProjShearParams.x * gDeferredVolumeRadiusScale;
	r0.w = r0.w * 0.662000000;
	r0.xyz = r0.xyz * r0.www + gDeferredLightPosition.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	o.sv_position = r1;
	o.texcoord.w = r1.w;
	o.texcoord.xyz = gViewInverse[3].xyz + -(gDeferredLightPosition.xyz);
	o.texcoord1 = r0.xyz + -(gViewInverse[3].xyz);
	o.texcoord3 = r0.xyz;
	r0.x = gDeferredLightColourAndIntensity.w * gDeferredLightVolumeParams.x;
	r0.x = r0.x * 0.25;
	o.texcoord2 = r0.xxx * gDeferredLightColourAndIntensity.xyz;

	return o;
}
