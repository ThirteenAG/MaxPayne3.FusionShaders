float4 NearFarPlane : register(c128);
float4 gAspectRatio : register(c17);
float gBiasToCamera : register(c201);
float4 gDepthFxParams : register(c18);
float gScaleFade : register(c211);
float4 gTexCoordScaleOffset0 : register(c215);
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
	float4 r3;
	float4 r4;
	r0.x = (1E-06 >= i.color.w) ? 1 : 0;
	r0.y = 1 / gScaleFade.x;
	r1.x = 0.1;
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
	r0.xy = r0.xx * i.normal.xy;
	r0.z = i.normal.z * 0.15915494 + 0.5;
	r0.z = frac(r0.z);
	r0.z = r0.z * 6.2831855 + -3.1415927;
	sincos(r0.z, r3.y, r3.x);
	r3.yzw = r0.yxy * r3.yyx;
	r4.x = r0.x * r3.x + -r3.y;
	r4.y = r3.w + r3.z;
	o.texcoord8.xy = r0.xy;
	r4.zw = 0;
	r0 = r4 * gAspectRatio + r2;
	o.texcoord3.y = r2.w;
	r1.w = saturate(-r0.w * gDepthFxParams.z + gDepthFxParams.w);
	o.position = r0;
	r0.x = -r1.w + 1;
	o.texcoord2.zw = r0.xx * gDepthFxParams.xy + r1.ww;
	r0.xyz = r1.xyz + -gViewInverse[3].xyz;
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
	r0 = r1.y * gWorldView[1];
	r0 = r1.x * gWorldView[0] + r0;
	r0 = r1.z * gWorldView[2] + r0;
	o.texcoord7 = r0 + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord8.zw = i.normal.zw;
	o.texcoord2.xy = i.texcoord1.xy;
	o.texcoord3.xzw = float3(1, 0, 0) * i.texcoord2.zzz;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
