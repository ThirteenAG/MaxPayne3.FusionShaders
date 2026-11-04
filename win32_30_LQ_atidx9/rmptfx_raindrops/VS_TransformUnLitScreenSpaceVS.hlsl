float gSuperAlpha : register(c103);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars4 : register(c51);
float4 globalScreenSize : register(c41);

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
	float2 r1;
	r0.x = i.normal.z * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	sincos(r0.x, r1.y, r1.x);
	r0.xyz = r1.yyx * i.normal.yxy;
	r1.x = i.normal.x * r1.x + -r0.x;
	r1.y = r0.z + r0.y;
	r0.x = 1 / globalScreenSize.y;
	r0.y = r0.x * globalScreenSize.x;
	r0.x = 1;
	r0.xy = r0.xy * r1.xy;
	r0.z = -1 + i.normal.w;
	r0.z = (-abs(r0.z) >= abs(r0.z)) ? 1 : 0;
	r0.xy = r0.xy * r0.zz;
	r0.z = 0;
	o.position.xyz = i.position.xyx * float3(1, 1, 0) + r0.xyz;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r0.xyz = -gViewInverse[3].xyz + i.position.xyz;
	r0.w = r0.z * globalFogParams.x;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * globalFogParams.z;
	r0.y = r0.w * -1.442695;
	r0.y = exp2(r0.y);
	r0.y = min(r0.y, 65504);
	r0.y = -r0.y + 1;
	r0.z = 1 / r0.w;
	r0.w = (0.0001 < abs(r0.w)) ? 1 : 0;
	r0.y = r0.z * r0.y;
	r0.y = r0.x * r0.y + -r0.x;
	r0.x = r0.w * r0.y + r0.x;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	r0.x = min(r0.x, 65504);
	o.texcoord4.w = -r0.x + 1;
	o.texcoord8.w = globalScalars4.x * i.normal.w;
	r0 = gWorldView[1] * i.position.y;
	r0 = i.position.x * gWorldView[0] + r0;
	r0 = i.position.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	o.position.w = 1;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord8.xyz = i.normal.xyz;
	o.texcoord1 = i.texcoord;
	o.texcoord2 = i.texcoord1;
	o.texcoord3 = float4(1, 0, 0, 0) * i.texcoord2.z;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
