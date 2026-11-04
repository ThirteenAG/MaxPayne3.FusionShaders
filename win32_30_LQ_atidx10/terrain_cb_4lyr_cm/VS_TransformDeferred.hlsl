float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);

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
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float3 r2;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
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
	o.texcoord2 = r1.xyz;
	o.texcoord4 = r2.xyz;
	o.texcoord5 = r0.xyz * i.tangent.www;
	r0.xy = globalDayNightEffects.zw * i.color.xy;
	r0.x = r0.y + r0.x;
	r0.yz = float2(-1, 1);
	r0.x = r0.x * globalScalars.z + r0.y;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.z;
	o.texcoord3.w = r0.x * gAmbientOcclusionEffect.y;
	o.texcoord = i.texcoord;
	o.texcoord3.xyz = 1;

	return o;
}
