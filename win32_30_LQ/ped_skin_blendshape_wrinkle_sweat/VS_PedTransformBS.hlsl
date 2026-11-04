row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 normal : NORMAL;
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
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0.xyz = i.position.xyz;
	r0.xyz = r0.xyz + i.position1.xyz;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r1.xyz = r0.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = r0.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gWorld[3].xyz;
	o.texcoord3 = -r1.xyz + gViewInverse[3].xyz;
	o.texcoord2 = r1.xyz;
	r1.xyz = i.normal.xyz;
	r1.xyz = r1.xyz + i.normal1.xyz;
	r2 = r1.yyy * gWorld[1].xyz;
	r1.xyw = r1.xxx * gWorld[0].xyz + r2.xyz;
	r1.xyz = r1.zzz * gWorld[2].xyz + r1.xyw;
	r1.xyz = r1.xyz + 1E-05;
	r2 = normalize(r1.xyz);
	r1 = i.tangent;
	r1 = r1 + i.tangent1;
	r3 = r1.yyy * gWorld[1].xyz;
	r3 = r1.xxx * gWorld[0].xyz + r3.xyz;
	r1.xyz = r1.zzz * gWorld[2].xyz + r3.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r3 = normalize(r1.xyz);
	r1.xyz = r2.yzx * r3.zxy;
	r1.xyz = r3.yzx * r2.zxy + -r1.xyz;
	o.texcoord1.xyz = r2.xyz;
	o.texcoord4 = r3.xyz;
	o.texcoord5.xyz = r1.www * r1.xyz;
	o.texcoord5.w = r1.w;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord.zw = i.texcoord1.xy;
	o.texcoord7 = i.color;

	return o;
}
