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
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	o.sv_position.xy = position.xy * float2(2, 2) + float2(-1, -1);
	o.sv_position.zw = float2(0, 1);
	o.texcoord = position.xy * float2(1, -1) + float2(0, 1);
	r0.xy = position.xy + float2(-0.5, -0.5);
	r0.xy = r0.xy * float2(2, 2) + gDeferredLightRadiusProjShearParams.zw;
	r0.xy = r0.xy * gDeferredProjParams.xy;
	r0.yzw = -(r0.yyy) * gViewInverse[1].xyz;
	r0.xyz = -(r0.xxx) * gViewInverse[0].xyz + r0.yzw;
	o.texcoord1.xyz = r0.xyz + gViewInverse[2].xyz;
	o.texcoord1.w = 1;

	return o;
}
