float HybridAdd : register(c88);
float4 gAspectRatio : register(c17);
float gSuperAlpha : register(c99);
float4 gTexCoordScaleOffset0 : register(c105);
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
	r0.x = i.normal.z * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	sincos(r0.x, r1.y, r1.x);
	r0.xyz = r1.yyx * i.normal.yxy;
	r1.x = i.normal.x * r1.x + -r0.x;
	r1.y = r0.z + r0.y;
	r1.zw = 0;
	r0.xyz = gViewInverse[3].xyz + -i.position.xyz;
	r0.xyz = r0.xyz * 0.048 + i.position.xyz;
	r2 = r0.y * gWorldViewProj[1];
	r2 = r0.x * gWorldViewProj[0] + r2;
	r2 = r0.z * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	o.position = r1 * gAspectRatio + r2;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	r1.xyz = r0.xyz + -gViewInverse[3].xyz;
	r0.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = r0.w * -1.442695;
	r1.y = exp2(r1.y);
	r1.y = min(r1.y, 65504);
	r1.y = -r1.y + 1;
	r1.z = 1 / r0.w;
	r0.w = (0.0001 < abs(r0.w)) ? 1 : 0;
	r1.y = r1.z * r1.y;
	r1.y = r1.x * r1.y + -r1.x;
	r0.w = r0.w * r1.y + r1.x;
	r0.w = r0.w * -globalFogParams.y;
	r0.w = r0.w * 1.442695;
	r0.w = exp2(r0.w);
	r0.w = min(r0.w, 65504);
	o.texcoord4.w = -r0.w + 1;
	r1.z = 0.5;
	r0.w = (r1.z < HybridAdd.x) ? 1 : 0;
	o.texcoord3.z = r0.w * -i.texcoord3.x + 1;
	r1 = r0.y * gWorldView[1];
	r1 = r0.x * gWorldView[0] + r1;
	r0 = r0.z * gWorldView[2] + r1;
	o.texcoord7 = r0 + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord3.xy = float2(1, 0) * i.texcoord2.zz;
	o.texcoord3.w = i.texcoord3.y;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
