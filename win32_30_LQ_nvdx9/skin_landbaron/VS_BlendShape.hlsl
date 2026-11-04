row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 tangent : TANGENT;
	float4 position1 : POSITION1;
	float4 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xyz = i.position.xyz;
	r0.xyz = r0.xyz + i.position1.xyz;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r1.xyz = r0.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = r0.zzz * gWorld[2].xyz + r1.xyz;
	o.texcoord2.xyz = i.position.www * gWorld[3].xyz + r1.xyz;
	r1.xyz = i.normal.xyz;
	r1.xyz = r1.yzx + i.normal1.yzx;
	r2.xyz = r1.xxx * gWorld[1].xyz;
	r2.xyz = r1.zzz * gWorld[0].xyz + r2.xyz;
	o.texcoord.xyz = r1.yyy * gWorld[2].xyz + r2.xyz;
	r2 = i.tangent;
	r2 = r2 + i.tangent1;
	r3 = r2.yyy * gWorld[1].xyz;
	r3 = r2.xxx * gWorld[0].xyz + r3.xyz;
	o.texcoord4.xyz = r2.zzz * gWorld[2].xyz + r3.xyz;
	r3 = r1.xyz * r2.zxy;
	r1.xyz = r2.yzx * r1.yzx + -r3.xyz;
	r1.xyz = r2.www * r1.xyz;
	o.texcoord4.w = r2.w;
	r2.xyz = r1.yyy * gWorld[1].xyz;
	r1.xyw = r1.xxx * gWorld[0].xyz + r2.xyz;
	o.texcoord5 = r1.zzz * gWorld[2].xyz + r1.xyw;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = i.position.w * gWorldViewProj[3] + r0;
	r1.xyz = r0.xwy * 0.5;
	o.texcoord1.x = r1.y + r1.x;
	o.texcoord1.y = r0.w * 0.5 + -r1.z;
	o.position = r0;
	o.texcoord1.zw = r0.ww;
	o.texcoord.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3 = float4(0, 0, 0, 1);
	o.color = i.color;

	return o;
}
