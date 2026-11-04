float2 envEffScale : register(c204);
float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

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
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float3 r2;
	float3 r3;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1 = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord7 = r0.xyz;
	r0.xyz = gWorld[1].xyz * i.tangent.yyy;
	r0.xyz = i.tangent.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.tangent.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	o.texcoord6.x = dot(r2.xyz, r1.xyz);
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r3 = normalize(r0.xyz);
	r0.xyz = r2.zxy * r3.yzx;
	r0.xyz = r2.yzx * r3.zxy + -r0.xyz;
	o.texcoord4 = r2.xyz;
	r0.xyz = r0.xyz * i.tangent.www;
	o.texcoord6.y = dot(r0.xyz, r1.xyz);
	o.texcoord5.xyz = r0.xyz;
	o.texcoord6.z = dot(r3.xyz, r1.xyz);
	o.texcoord1.xyz = r3.xyz;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r0.w = -1;
	r0.x = i.color.x * globalScalars.z + r0.w;
	r0.x = gAmbientOcclusionEffect.y * r0.x + -r0.w;
	r0.y = 1 / gAmbientOcclusionEffect.y;
	r0.x = r0.y * r0.x;
	o.texcoord2.x = min(r0.x, 1);
	r0.x = saturate(i.color.x);
	r0.y = r0.x + -0.5;
	r0.y = max(r0.y, 0);
	r0.y = r0.y + r0.y;
	r0.x = r0.x * 2 + r0.y;
	r0.x = min(r0.x, 1);
	o.texcoord3 = r0.x * envEffScale.x;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = float4(1, 1, 0, 0) * i.texcoord.xyxx;
	o.texcoord2.zw = i.color.zw;
	o.texcoord5.w = i.tangent.w;

	return o;
}
