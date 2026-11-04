row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float3 globalAnimUV0 : register(c196);
float3 globalAnimUV1 : register(c197);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float3 r2;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord6.xyz = r0.xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1 = normalize(r0.xyz);
	r0.xyz = gWorld[1].xyz * i.tangent.yyy;
	r0.xyz = i.tangent.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.tangent.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.yzx * r2.zxy;
	r0.xyz = r2.yzx * r1.zxy + -r0.xyz;
	o.texcoord1.xyz = r1.xyz;
	o.texcoord4 = r2.xyz;
	o.texcoord5 = r0.xyz * i.tangent.www;
	r0.xyz = i.texcoord.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord.x = dot(globalAnimUV0.xyz, r0.xyz);
	o.texcoord.y = dot(globalAnimUV1.xyz, r0.xyz);
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.color = i.color;
	o.texcoord6.w = 1;

	return o;
}
