float4 gDirectionalColour : register(c20);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float2 r2;
	r0.x = dot(gWorldView[3], gWorldView[3]);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * gDirectionalColour.x;
	r0.yzw = gWorld[1].xyz * i.normal.yyy;
	r0.yzw = i.normal.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.normal.zzz * gWorld[2].xyz + r0.yzw;
	r0.xyz = r0.yzw * r0.xxx + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r2 = r1.xy * float2(0.5, -0.5);
	r0.w = 1 / r1.w;
	o.position = r1;
	o.texcoord.xy = r2.xy * r0.ww + 0.5;
	r0.y = r0.y * gWorldView[1].z;
	r0.x = r0.x * gWorldView[0].z + r0.y;
	r0.x = r0.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord.z = -r0.x;

	return o;
}
