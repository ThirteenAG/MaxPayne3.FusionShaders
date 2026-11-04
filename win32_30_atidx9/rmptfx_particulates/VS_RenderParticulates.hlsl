float4 gAspectRatio : register(c17);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float2 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.x = gWorldView[1].z * i.position.y;
	r0.x = i.position.x * gWorldView[0].z + r0.x;
	r0.x = i.position.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord.yz = -r0.xx;
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
	r1.xy = r2.xy * gAspectRatio.xy;
	r1.z = 1 / r0.w;
	r1.zw = r0.xy * r1.zz;
	o.position = r0;
	o.texcoord2 = r1.zw * float2(0.5, -0.5) + 0.5;
	r0.xy = (-r1.xy < r1.xy) ? 1 : 0;
	r0.zw = (r1.xy < -r1.xy) ? 1 : 0;
	o.texcoord3 = -r0.zw + r0.xy;
	o.texcoord.x = i.color.w;
	o.texcoord.w = i.texcoord2.z;
	o.texcoord1 = i.texcoord;

	return o;
}
