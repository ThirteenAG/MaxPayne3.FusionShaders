float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
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
	r0.w = r0.z * globalFogParams.x;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * globalFogParams.z;
	r0.y = r0.w * -1.442695;
	r0.y = exp2(r0.y);
	r0.y = -r0.y + 1;
	r0.z = 1 / r0.w;
	r0.w = (0.0001 < abs(r0.w)) ? 1 : 0;
	r0.y = r0.z * r0.y;
	r0.y = r0.x * r0.y + -r0.x;
	r0.x = r0.w * r0.y + r0.x;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	r0.x = min(r0.x, 1);
	r1 = gWorldViewProj[1] * i.position.y;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r0.y = saturate(-r1.w * gDepthFxParams.z + gDepthFxParams.w);
	o.position = r1;
	r0.z = -r0.y + 1;
	r0.y = r0.z * gDepthFxParams.y + r0.y;
	r1.xyz = globalScalars.yyy * i.color.xyz;
	r0.z = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.yz = r0.yz + float2(-0.99999, 1E-05);
	r0.z = abs(r0.z) + 1E-05;
	r1.w = pow(r0.z, r0.y);
	r0.yzw = r1.xyz * r1.www + -globalFogColorN.xyz;
	r0.xyz = r0.xxx * r0.yzw + globalFogColorN.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = -r0.www + r0.xyz;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.texcoord = r1.xxx * r0.xyz + r0.www;

	return o;
}
