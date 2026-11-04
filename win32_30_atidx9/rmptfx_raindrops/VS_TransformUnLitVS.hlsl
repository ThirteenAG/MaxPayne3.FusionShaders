float4 gAspectRatio : register(c17);
float4 gDepthFxParams : register(c18);
float gSuperAlpha : register(c104);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);

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
	float4 r1;
	float4 r2;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = i.normal.z * 0.15915494 + 0.5;
	r1.x = frac(r1.x);
	r1.x = r1.x * 6.2831855 + -3.1415927;
	sincos(r1.x, r2.y, r2.x);
	r1.xyz = r2.yyx * i.normal.yxy;
	r2.x = i.normal.x * r2.x + -r1.x;
	r2.y = r1.z + r1.y;
	r2.zw = 0;
	r0 = r2 * gAspectRatio + r0;
	r1.x = saturate(-r0.w * gDepthFxParams.z + gDepthFxParams.w);
	r1.y = -r1.x + 1;
	o.texcoord2.zw = r1.yy * gDepthFxParams.xy + r1.xx;
	r1.xyz = -gViewInverse[3].xyz + i.position.xyz;
	r1.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = r1.w * -1.442695;
	r1.y = exp2(r1.y);
	r1.y = min(r1.y, 65504);
	r1.y = -r1.y + 1;
	r1.z = 1 / r1.w;
	r1.w = (0.0001 < abs(r1.w)) ? 1 : 0;
	r1.y = r1.z * r1.y;
	r1.y = r1.x * r1.y + -r1.x;
	r1.x = r1.w * r1.y + r1.x;
	r1.x = r1.x * -globalFogParams.y;
	r1.x = r1.x * 1.442695;
	r1.x = exp2(r1.x);
	r1.x = min(r1.x, 65504);
	o.texcoord4.w = -r1.x + 1;
	r1 = gWorldView[1] * i.position.y;
	r1 = i.position.x * gWorldView[0] + r1;
	r1 = i.position.z * gWorldView[2] + r1;
	o.texcoord7 = r1 + gWorldView[3];
	o.position = r0;
	o.texcoord3.xyz = r0.xyw;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord8 = i.normal;
	o.texcoord1 = i.texcoord;
	o.texcoord2.xy = i.texcoord1.xy;
	o.texcoord3.w = i.texcoord2.y;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
