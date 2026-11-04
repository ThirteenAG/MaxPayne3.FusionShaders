float gCameraDistanceAtMaxDisplacement : register(c98);
float gMaxDisplacement : register(c96);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r0.xyz = r0.xyz + -gViewInverse[3].xyz;
	r1.xyz = gWorld[1].xyz * i.normal.yyy;
	r1.xyz = i.normal.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = i.normal.zzz * gWorld[2].xyz + r1.xyz;
	r0.x = dot(-r0.xyz, r1.xyz);
	r0.y = 1 / gCameraDistanceAtMaxDisplacement.x;
	r0.x = saturate(r0.y * r0.x);
	r0.x = r0.x * gMaxDisplacement.x;
	r1.xyz = i.normal.xyz;
	r0.xyz = r0.xxx * r1.xyz + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	r0.x = i.color.w * i.color.w;
	r0.x = r0.x * 20;
	o.color = r0.xxx * i.color.xyz;
	o.texcoord2 = i.texcoord.xy;

	return o;
}
