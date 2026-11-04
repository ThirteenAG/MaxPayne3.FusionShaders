float4 gAmbientOcclusionEffect : register(c63);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);

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
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -r0.xyz + gViewInverse[3].xyz;
	r1 = gWorld[1].xyz * i.normal.yyy;
	r1 = i.normal.xxx * gWorld[0].xyz + r1.xyz;
	r1 = i.normal.zzz * gWorld[2].xyz + r1.xyz;
	r1 = r1.xyz + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r1.xyz;
	r1.xy = globalDayNightEffects.zw * i.color.xy;
	r0.w = r1.y + r1.x;
	r1.yz = float2(-1, 1);
	r0.w = r0.w * globalScalars.z + r1.y;
	r0.w = gAmbientOcclusionEffect.x * r0.w + r1.z;
	o.color.xy = r0.ww * gAmbientOcclusionEffect.yy;
	r1 = r0.xyz + -gViewInverse[3].xyz;
	o.texcoord6.xyz = r0.xyz;
	r0.x = r1.z * globalFogParams.x;
	r0.y = dot(r1.xyz, r1.xyz);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = r0.y * globalFogParams.z;
	r0.z = r0.x * -1.442695;
	r0.z = exp2(r0.z);
	r0.z = -r0.z + 1;
	r0.w = 1 / r0.x;
	r0.x = (0.0001 < abs(r0.x)) ? 1 : 0;
	r0.z = r0.w * r0.z;
	r0.z = r0.y * r0.z + -r0.y;
	r0.x = r0.x * r0.z + r0.y;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	o.texcoord9.x = -r0.x + 1;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	r1.x = saturate(-r0.w * gDepthFxParams.z + gDepthFxParams.w);
	r1.y = -r1.x + 1;
	r1.x = r1.y * gDepthFxParams.y + r1.x;
	o.texcoord9.y = r1.x + -1;
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.color.zw = i.color.zw;
	o.texcoord = i.texcoord.xy;
	o.texcoord6.w = 1;
	o.texcoord9.zw = 0;

	return o;
}
