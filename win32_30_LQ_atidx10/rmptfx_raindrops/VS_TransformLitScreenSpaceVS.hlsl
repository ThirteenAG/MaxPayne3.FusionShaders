float gAmbientAmount : register(c102);
float4 gAmbientOcclusionEffect : register(c63);
float4 gAspectRatio : register(c17);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
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
	float4 r1;
	float3 r2;
	r0.x = i.normal.z * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	sincos(r0.x, r1.y, r1.x);
	r0.xyz = r1.yyx * i.normal.yxy;
	r1.x = i.normal.x * r1.x + -r0.x;
	r1.y = r0.z + r0.y;
	r0.x = 1 / globalScreenSize.y;
	r0.y = r0.x * globalScreenSize.x;
	r1.z = 0;
	r0.xz = 1;
	r2 = r1.xyz * r0.xyz + -i.position.xyz;
	r0.xyz = r0.xyz * r1.xyz;
	r0.w = -1 + i.normal.w;
	r0.w = (-abs(r0.w) >= abs(r0.w)) ? 1 : 0;
	r1.xyz = r0.www * r2.xyz + i.position.xyz;
	r2.x = 1 / gAspectRatio.x;
	r2.y = 1 / gAspectRatio.y;
	r2.z = 1;
	r1.xyz = r1.xyz * r2.xyz + 1E-05;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = r1.x * r1.y;
	r1.x = saturate(r1.x * -0.5 + 0.5);
	r2 = gLightAmbient0.xyz;
	r1.yzw = -r2.xyz + gLightAmbient1.xyz;
	r1.xyz = r1.xxx * r1.yzw + gLightAmbient0.xyz;
	r1.xyz = r1.xyz * gAmbientOcclusionEffect.yyy;
	r1.xyz = r1.xyz * gAmbientAmount.xxx;
	r1.w = 1 / gAmbientOcclusionEffect.y;
	r1.xyz = r1.www * r1.xyz;
	r1.xyz = r1.xyz * i.color.xyz;
	r1.xyz = max(r1.xyz, 0);
	o.texcoord.xyz = r1.xyz + i.color.xyz;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r1.xyz = -gViewInverse[3].xyz + i.position.xyz;
	r1.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = r1.w * -1.442695;
	r1.y = exp2(r1.y);
	r1.y = -r1.y + 1;
	r1.z = 1 / r1.w;
	r1.w = (0.0001 < abs(r1.w)) ? 1 : 0;
	r1.y = r1.z * r1.y;
	r1.y = r1.x * r1.y + -r1.x;
	r1.x = r1.w * r1.y + r1.x;
	r1.x = r1.x * -globalFogParams.y;
	r1.x = r1.x * 1.442695;
	r1.x = exp2(r1.x);
	o.texcoord4.w = -r1.x + 1;
	o.texcoord8.w = globalScalars4.x * i.normal.w;
	r1 = gWorldView[1] * i.position.y;
	r1 = i.position.x * gWorldView[0] + r1;
	r1 = i.position.z * gWorldView[2] + r1;
	o.texcoord7 = r1 + gWorldView[3];
	o.texcoord3.z = r0.w * i.normal.z;
	r0.xyz = r0.xyz * r0.www;
	r0.xyz = i.position.xyx * float3(1, 1, 0) + r0.xyz;
	o.position.xyz = r0.xyz;
	o.texcoord3.xy = r0.xy;
	o.position.w = 1;
	o.texcoord8.xyz = i.normal.xyz;
	o.texcoord1 = i.texcoord;
	o.texcoord2 = i.texcoord1;
	o.texcoord3.w = i.texcoord2.y;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
