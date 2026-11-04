float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);
float rippleScale : register(c202);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -r0.xyz + gViewInverse[3].xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r0.xyz;
	r0.xy = globalDayNightEffects.zw * i.color.xy;
	r0.x = r0.y + r0.x;
	r0.yz = float2(-1, 1);
	r0.x = r0.x * globalScalars.z + r0.y;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.z;
	o.color.xy = r0.xx * gAmbientOcclusionEffect.yy;
	r0.xy = rippleScale.xx * i.position.xy;
	o.texcoord = r0.xy * 0.00390625;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.color.zw = i.color.zw;
	o.texcoord6 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);

	return o;
}
