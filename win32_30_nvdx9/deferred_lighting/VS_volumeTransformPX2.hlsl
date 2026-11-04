float4 gDeferredProjParams : register(c216);
float4 gLightColB : register(c32);
float4 gLightColG : register(c31);
float4 gLightColR : register(c30);
float4 gLightConeOffset : register(c29);
float4 gLightConeScale : register(c28);
float4 gLightDirX : register(c24);
float4 gLightDirY : register(c25);
float4 gLightDirZ : register(c26);
float4 gLightFallOff : register(c27);
float4 gLightPosX : register(c21);
float4 gLightPosY : register(c22);
float4 gLightPosZ : register(c23);
row_major float4x4 gViewInverse : register(c12);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0.xy = -0.5 + position.xy;
	r0.xy = r0.xy + r0.xy;
	r0.xy = r0.xy * gDeferredProjParams.xy;
	r0.yzw = -r0.yyy * gViewInverse[1].xyz;
	r0.xyz = -r0.xxx * gViewInverse[0].xyz + r0.yzw;
	o.texcoord.xyz = r0.xyz + gViewInverse[2].xyz;
	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
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
