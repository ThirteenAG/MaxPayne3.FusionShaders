float HybridAdd : register(c89);
float4 NearFarPlane : register(c128);
float4 gAspectRatio : register(c17);
float gBiasToCamera : register(c98);
float gScaleFade : register(c108);
float gSuperAlpha : register(c106);
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
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = i.normal.z * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	sincos(r0.x, r1.y, r1.x);
	r0.x = (1E-06 >= i.color.w) ? 1 : 0;
	r0.y = 1 / gScaleFade.x;
	r2.xw = float2(0.1, 0.5);
	r0.z = r2.x * gBiasToCamera.x;
	r2.xyz = lerp(i.position.xyz, gViewInverse[3].xyz, r0.zzz);
	r3 = r2.y * gWorldViewProj[1];
	r3 = r2.x * gWorldViewProj[0] + r3;
	r3 = r2.z * gWorldViewProj[2] + r3;
	r3 = r3 + gWorldViewProj[3];
	r0.z = r3.w + -NearFarPlane.x;
	r0.y = saturate(r0.y * r0.z);
	r0.x = r0.x * -r0.y + r0.y;
	r4 = r0.x * i.normal.xyxy;
	r0.x = r0.x * i.color.w;
	o.texcoord.w = saturate(r0.x * gSuperAlpha.x);
	r0.xyz = r1.yyx * r4.yzw;
	r1.x = r4.x * r1.x + -r0.x;
	r1.y = r0.z + r0.y;
	r1.zw = 0;
	o.position = r1 * gAspectRatio + r3;
	r0.xyz = r2.xyz + -gViewInverse[3].xyz;
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
	r0.x = (r2.w < HybridAdd.x) ? 1 : 0;
	o.texcoord3.z = r0.x * -i.texcoord3.x + 1;
	r0.x = globalScalars4.x * i.texcoord3.y;
	o.texcoord.xyz = r0.xxx * i.color.xyz;
	r0 = r2.y * gWorldView[1];
	r0 = r2.x * gWorldView[0] + r0;
	r0 = r2.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	o.texcoord1 = i.texcoord;
	o.texcoord3.xy = float2(1, 0) * i.texcoord2.zz;
	o.texcoord3.w = i.texcoord3.y;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
