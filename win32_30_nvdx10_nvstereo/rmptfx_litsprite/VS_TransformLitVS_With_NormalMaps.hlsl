float HybridAdd : register(c197);
float4 NearFarPlane : register(c128);
float4 gAspectRatio : register(c17);
float gBiasToCamera : register(c201);
float gScaleFade : register(c211);
float4 gTexCoordScaleOffset0 : register(c215);
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
	float2 r4;
	r0.x = (1E-06 >= i.color.w) ? 1 : 0;
	r0.y = 1 / gScaleFade.x;
	r1.xw = float2(0.1, 0.5);
	r0.z = r1.x * gBiasToCamera.x;
	r1.xyz = lerp(i.position.xyz, gViewInverse[3].xyz, r0.zzz);
	r2 = r1.y * gWorldViewProj[1];
	r2 = r1.x * gWorldViewProj[0] + r2;
	r2 = r1.z * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	r0.z = r2.w + -NearFarPlane.x;
	r0.y = saturate(r0.y * r0.z);
	r0.x = r0.x * -r0.y + r0.y;
	o.texcoord.w = r0.x * i.color.w;
	r0 = r0.x * i.normal.xyxy;
	r3.x = i.normal.z * 0.15915494 + 0.5;
	r3.x = frac(r3.x);
	r3.x = r3.x * 6.2831855 + -3.1415927;
	sincos(r3.x, r4.y, r4.x);
	r0.yzw = r0.yzw * r4.yyx;
	r3.x = r0.x * r4.x + -r0.y;
	r3.y = r0.w + r0.z;
	r3.zw = 0;
	o.position = r3 * gAspectRatio + r2;
	r0.xyz = r1.xyz + -gViewInverse[3].xyz;
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
	r0.x = (r1.w < HybridAdd.x) ? 1 : 0;
	o.texcoord3.z = r0.x * -i.texcoord3.x + 1;
	r0.x = globalScalars4.x * i.texcoord3.y;
	o.texcoord.xyz = r0.xxx * i.color.xyz;
	r0 = r1.y * gWorldView[1];
	r0 = r1.x * gWorldView[0] + r0;
	r0 = r1.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
	o.texcoord3.xy = float2(1, 0) * i.texcoord2.zz;
	o.texcoord3.w = i.texcoord3.y;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
