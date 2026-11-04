row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float3 moonPosition : register(c161);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = moonPosition.xyz;
	r0.xyz = -r0.xyz + gViewInverse[3].xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = r1.yzx * float3(1, 0, 0);
	r0.xyz = r1.zxy * float3(0, 1, 0) + -r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.zxy * r2.yzx;
	r0.xyz = r1.yzx * r2.zxy + -r0.xyz;
	r1.xyz = r1.xyz * i.position.yyy;
	r1.xyz = i.position.xxx * r2.xyz + r1.xyz;
	r0.xyz = i.position.zzz * r0.xyz + r1.xyz;
	r0.xyz = r0.xyz + moonPosition.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.position = i.position.w * gWorldViewProj[3] + r1;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r0.xyw;
	o.texcoord1 = i.position.www * gWorld[3].xyz + r0.xyz;
	o.texcoord = i.texcoord.xy;

	return o;
}
