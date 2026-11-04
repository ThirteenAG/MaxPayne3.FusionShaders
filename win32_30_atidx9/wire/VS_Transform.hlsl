float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float3 globalAnimUV0 : register(c196);
float3 globalAnimUV1 : register(c197);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);
float4 globalScreenSize : register(c41);

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
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r0.xyz;
	r0.xyz = i.texcoord.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord.x = dot(globalAnimUV0.xyz, r0.xyz);
	o.texcoord.y = dot(globalAnimUV1.xyz, r0.xyz);
	r0.x = 0.07;
	r0.xyz = r0.xxx * gViewInverse[0].xyz;
	r1.x = dot(r0.xyz, gWorld[0].xyz);
	r1.y = dot(r0.xyz, gWorld[1].xyz);
	r1.z = dot(r0.xyz, gWorld[2].xyz);
	r0.xyz = r1.xyz + i.position.xyz;
	r0.yw = r0.yy * gWorldViewProj[1].xw;
	r0.xy = r0.xx * gWorldViewProj[0].xw + r0.yw;
	r0.xy = r0.zz * gWorldViewProj[2].xw + r0.xy;
	r0.xy = r0.xy + gWorldViewProj[3].xw;
	r0.y = 1 / r0.y;
	r1 = gWorldViewProj[1] * i.position.y;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r0.z = 1 / r1.w;
	r0.z = r0.z * r1.x;
	r0.x = r0.x * r0.y + -r0.z;
	r0.x = r0.x * globalScreenSize.y;
	o.texcoord7.z = saturate(r0.x * 0.5);
	r0.xy = globalDayNightEffects.zw * i.color.xy;
	r0.x = r0.y + r0.x;
	r0.y = 1;
	r0.x = r0.x * globalScalars.z + -r0.y;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.y;
	o.color.xy = r0.xx * gAmbientOcclusionEffect.yy;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r2 = r0.xyz + -gViewInverse[3].xyz;
	o.texcoord6.xyz = r0.xyz;
	r0.x = dot(r2.xyz, r2.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r2 = i.position.xyz;
	r0.yzw = r2.xyz + i.normal.xyz;
	r2.xy = r0.zz * gWorldViewProj[1].xy;
	r0.yz = r0.yy * gWorldViewProj[0].xy + r2.xy;
	r0.yz = r0.ww * gWorldViewProj[2].xy + r0.yz;
	r0.yz = r0.yz + gWorldViewProj[3].xy;
	r0.yz = -r0.yz + r1.xy;
	r0.yz = r0.yz * -0.002;
	r0.xy = r0.yz * r0.xx + r1.xy;
	r0.zw = r1.zw;
	o.texcoord7.xyw = r1.xyw;
	o.position = r0;
	o.texcoord8 = r0;
	o.texcoord1.w = r0.w;
	o.color.zw = i.color.zw;
	o.texcoord6.w = 1;

	return o;
}
