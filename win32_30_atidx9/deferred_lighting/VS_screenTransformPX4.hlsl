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

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord9 : TEXCOORD9;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = float2(1, 256);
	r1 = r0.y * gLightColR;
	r2 = frac(r1);
	r1 = r1 + -r2;
	r2 = r0.x + gLightDirX;
	o.texcoord4 = r2 * 0.25 + r1;
	r1 = r0.y * gLightColG;
	r2 = frac(r1);
	r1 = r1 + -r2;
	r2 = r0.x + gLightDirY;
	o.texcoord5 = r2 * 0.25 + r1;
	r1 = r0.y * gLightColB;
	r2 = frac(r1);
	r1 = r1 + -r2;
	r0 = r0.x + gLightDirZ;
	o.texcoord6 = r0 * 0.25 + r1;
	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
	o.texcoord1 = gLightPosX;
	o.texcoord2 = gLightPosY;
	o.texcoord3 = gLightPosZ;
	o.texcoord7 = gLightFallOff;
	o.texcoord8 = gLightConeScale;
	o.texcoord9 = gLightConeOffset;

	return o;
}
