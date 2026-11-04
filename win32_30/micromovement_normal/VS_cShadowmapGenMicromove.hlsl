float4 WindGlobalParams : register(c201);
float4 deSatContrastGamma : register(c46);
row_major float4x4 gShadowMatrix : register(c57);
row_major float4x4 gWorld : register(c0);
float4 globalScalars2 : register(c36);
float4 globalUmScalars : register(c48);
float4 umGlobalParams : register(c200);

struct VS_IN
{
	float4 position : POSITION;
	float4 color1 : COLOR1;
	float4 texcoord : TEXCOORD;
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
	r0.x = 6.2831855 * i.color1.y;
	r0.zw = umGlobalParams.zw;
	r0.yzw = r0.zzw * globalUmScalars.zzw;
	r0.xyz = globalScalars2.yyy * r0.yzw + r0.xxx;
	r0.xyz = r0.xyz * 0.15915494 + 0.25;
	r0.xyz = frac(r0.xyz);
	r0.xyz = r0.xyz * 6.2831855 + -3.1415927;
	r0.xyz = r0.xyz * r0.xyz;
	r1.xyz = r0.yyz * -2.523985E-07 + 2.47609E-05;
	r1.xyz = r0.yyz * r1.xyz + -0.0013888397;
	r1.xyz = r0.yyz * r1.xyz + 0.04166664;
	r1.xyz = r0.yyz * r1.xyz + -0.5;
	r0.xyz = r0.xyz * r1.xyz + 1;
	r0.w = globalUmScalars.x * i.color1.x;
	r1.xy = r0.ww * umGlobalParams.xx;
	r0.w = 1 + -i.color1.z;
	r1.w = r0.w * globalUmScalars.y;
	r0.w = r0.w * WindGlobalParams.x;
	r1.z = r1.w * umGlobalParams.y;
	r0.xyz = r0.xyz * r1.xyz + i.position.xyz;
	r1.x = r0.z * deSatContrastGamma.w;
	r0.xy = r1.xx * r0.ww + r0.xy;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1.xyz = r0.yyy * gShadowMatrix[1].xyz;
	r0.xyw = r0.xxx * gShadowMatrix[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gShadowMatrix[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gShadowMatrix[3].xyz;
	o.position.z = max(r0.z, 0);
	o.position.xyw = r0.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	o.texcoord = i.texcoord.xxy * float3(0, 1, 1) + float3(1, 0, 0);

	return o;
}
