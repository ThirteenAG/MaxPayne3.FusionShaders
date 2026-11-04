row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord3 = r0.xyz + gWorld[3].xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	o.texcoord1 = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord = float3(1, 1, 0) * i.texcoord.xyx;

	return o;
}
