float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldView : register(c4);
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
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = gWorldView[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorldView[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldView[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldView[3].xyz;
	r0.w = r0.z + 512;
	r0.w = dot(r0.xyw, r0.xyw);
	r0.w = rsqrt(r0.w);
	r0.z = r0.z + 512;
	r0.z = r0.z * -r0.w + 1;
	r1.w = 1 / r0.w;
	r0.z = r0.z * r1.w;
	r0.z = 1 / r0.z;
	o.position.xy = r0.zz * r0.xy;
	r0.x = r1.w + 1;
	r0.x = 1 / r0.x;
	o.position.z = -r0.x + 1;
	r0.xy = globalDayNightEffects.zw * i.color.xy;
	r0.x = r0.y + r0.x;
	r0.zw = float2(1, -1);
	r0.x = r0.x * globalScalars.z + r0.w;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.z;
	o.texcoord3.w = r0.x * gAmbientOcclusionEffect.y;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r2 = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord1 = r0.xyz;
	o.texcoord4 = -r2.xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = gWorld[1].xyz * i.tangent.yyy;
	r0.xyz = i.tangent.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.tangent.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.yzx * r2.zxy;
	r0.xyz = r2.yzx * r1.zxy + -r0.xyz;
	o.texcoord2 = r1;
	o.texcoord5 = r2.xyz;
	o.texcoord6 = r0.xyz * i.tangent.www;
	o.position.w = 1;
	o.texcoord = i.texcoord;
	o.texcoord3.xyz = 1;

	return o;
}
