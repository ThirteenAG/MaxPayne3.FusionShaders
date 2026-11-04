float4 gAspectRatio : register(c17);
float gBiasToCamera : register(c33);
float4 gTexCoordScaleOffset : register(c35);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

struct VS_OUT
{
	float4 color : COLOR;
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float4 r2;
	o.texcoord = i.texcoord * gTexCoordScaleOffset.xyxy + gTexCoordScaleOffset.zwzw;
	r0.x = 0.1;
	r0.x = r0.x * gBiasToCamera.x;
	r1 = lerp(i.position.xyz, gViewInverse[3].xyz, r0.xxx);
	r0 = r1.y * gWorldViewProj[1];
	r0 = r1.x * gWorldViewProj[0] + r0;
	r0 = r1.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = i.normal.z * 0.15915494 + 0.5;
	r1.x = frac(r1.x);
	r1.x = r1.x * 6.2831855 + -3.1415927;
	sincos(r1.x, r2.y, r2.x);
	r1 = r2.yyx * i.normal.yxy;
	r2.x = i.normal.x * r2.x + -r1.x;
	r2.y = r1.z + r1.y;
	r2.zw = 0;
	o.position = r2 * gAspectRatio + r0;
	o.color = i.color;
	o.texcoord1 = i.texcoord1;
	o.texcoord2 = float4(1, 0, 0, 0) * i.texcoord2.z;
	o.texcoord3 = i.texcoord3;
	o.texcoord4 = i.texcoord4;

	return o;
}
