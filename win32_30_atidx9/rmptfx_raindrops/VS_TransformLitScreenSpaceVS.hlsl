float4 gDepthFxParams : register(c18);
float gSuperAlpha : register(c104);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
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
	float2 r2;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r0.x = saturate(gDepthFxParams.w + -gDepthFxParams.z);
	r0.y = -r0.x + 1;
	o.texcoord2.zw = r0.yy * gDepthFxParams.xy + r0.xx;
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
	r0 = gWorldView[1] * i.position.y;
	r0 = i.position.x * gWorldView[0] + r0;
	r0 = i.position.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	r0.x = -1 + i.normal.w;
	r0.x = (-abs(r0.x) >= abs(r0.x)) ? 1 : 0;
	o.texcoord3.z = r0.x * i.normal.z;
	r0.y = i.normal.z * 0.15915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	sincos(r0.y, r1.y, r1.x);
	r0.yzw = r1.yyx * i.normal.yxy;
	r1.x = i.normal.x * r1.x + -r0.y;
	r1.y = r0.w + r0.z;
	r0.y = 1 / globalScreenSize.y;
	r2.y = r0.y * globalScreenSize.x;
	r2.x = 1;
	r0.yz = r1.xy * r2.xy;
	r0.xy = r0.yz * r0.xx;
	r0.z = 0;
	r0.xyz = i.position.xyx * float3(1, 1, 0) + r0.xyz;
	o.position.xyz = r0.xyz;
	o.texcoord3.xy = r0.xy;
	o.position.w = 1;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord8 = i.normal;
	o.texcoord1 = i.texcoord;
	o.texcoord2.xy = i.texcoord1.xy;
	o.texcoord3.w = i.texcoord2.y;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
