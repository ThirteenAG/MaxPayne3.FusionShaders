float4 gAspectRatio : register(c17);
float gSuperAlpha : register(c103);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars4 : register(c51);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float4 r2;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r0.xyz = -gViewInverse[3].xyz + i.position.xyz;
	r0.w = r0.z * globalFogParams.x;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * globalFogParams.z;
	r0.y = r0.w * -1.442695;
	r0.y = exp2(r0.y);
	r0.y = -r0.y + 1;
	r0.z = 1 / r0.w;
	r0.w = (0.0001 < abs(r0.w)) ? 1 : 0;
	r0.y = r0.z * r0.y;
	r0.y = r0.x * r0.y + -r0.x;
	r0.x = r0.w * r0.y + r0.x;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	o.texcoord4.w = -r0.x + 1;
	o.texcoord8.w = globalScalars4.x * i.normal.w;
	r0 = gWorldView[1] * i.position.y;
	r0 = i.position.x * gWorldView[0] + r0;
	r0 = i.position.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = i.normal.z * 0.15915494 + 0.5;
	r1.x = frac(r1.x);
	r1.x = r1.x * 6.2831855 + -3.1415927;
	sincos(r1.x, r2.y, r2.x);
	r1 = r2.yyx * i.normal.yxy;
	r2.x = i.normal.x * r2.x + -r1.x;
	r2.y = r1.z + r1.y;
	r2.zw = 0;
	r0 = r2 * gAspectRatio + r0;
	o.position = r0;
	o.texcoord3.xyz = r0.xyw;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord8.xyz = i.normal.xyz;
	o.texcoord1 = i.texcoord;
	o.texcoord2 = i.texcoord1;
	o.texcoord3.w = i.texcoord2.y;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
