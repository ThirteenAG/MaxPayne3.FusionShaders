cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
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
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	o.sv_position.xy = position.xy * float2(2, 2) + float2(-1, -1);
	o.sv_position.zw = float2(0, 1);
	r0.xy = position.xy + float2(-0.5, -0.5);
	r0.xy = r0.xy + r0.xy;
	r0.xy = r0.xy * gDeferredProjParams.xy;
	r0.yzw = -(r0.yyy) * gViewInverse[1].xyz;
	r0.xyz = -(r0.xxx) * gViewInverse[0].xyz + r0.yzw;
	o.texcoord.xyz = r0.xyz + gViewInverse[2].xyz;
	o.texcoord.w = 1;
	o.texcoord1.x = gLightPosX.x;
	o.texcoord1.y = gLightPosY.x;
	o.texcoord1.z = gLightPosZ.x;
	o.texcoord1.w = gLightFallOff.x;
	o.texcoord2.x = gLightColR.x;
	o.texcoord2.y = gLightColG.x;
	o.texcoord2.z = gLightColB.x;
	o.texcoord2.w = gLightConeScale.x;
	o.texcoord3.x = gLightDirX.x;
	o.texcoord3.y = gLightDirY.x;
	o.texcoord3.z = gLightDirZ.x;
	o.texcoord3.w = gLightConeOffset.x;
	o.texcoord4.x = gLightPosX.y;
	o.texcoord4.y = gLightPosY.y;
	o.texcoord4.z = gLightPosZ.y;
	o.texcoord4.w = gLightFallOff.y;
	o.texcoord5.x = gLightColR.y;
	o.texcoord5.y = gLightColG.y;
	o.texcoord5.z = gLightColB.y;
	o.texcoord5.w = gLightConeScale.y;
	o.texcoord6.x = gLightDirX.y;
	o.texcoord6.y = gLightDirY.y;
	o.texcoord6.z = gLightDirZ.y;
	o.texcoord6.w = gLightConeOffset.y;

	return o;
}
