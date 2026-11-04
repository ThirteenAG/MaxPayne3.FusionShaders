float4 gPiercingLightPower_Strength_NormalStrength_Thickness : register(c31);
float2 gRescaleUV1 : register(c94);
float2 gRescaleUV2 : register(c95);
float2 gRescaleUV3 : register(c96);
float4 gScatterG_GSquared_PhaseMult_Scale : register(c30);
float3 gSunColor : register(c25);
float3 gSunDirection : register(c24);
float2 gUVOffset[3] : register(c38);
float2 gUVOffset1 : register(c91);
float2 gUVOffset2 : register(c92);
float2 gUVOffset3 : register(c93);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 texcoord : TEXCOORD;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float3 texcoord8 : TEXCOORD8;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = i.position.w * gWorldViewProj[3] + r0;
	r1.xyz = r0.xwy * 0.5;
	o.texcoord6.x = r1.y + r1.x;
	o.texcoord6.y = r0.w * 0.5 + -r1.z;
	r1.xyz = gWorld[1].xyz * i.normal.yyy;
	r1.xyz = i.normal.xxx * gWorld[0].xyz + r1.xyz;
	o.texcoord1 = i.normal.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = float3(0, -1, 0) * i.normal.yzx;
	r1.xyz = i.normal.xyz * float3(-1, 0, 0) + -r1.xyz;
	r2 = r1.xxx * gWorld[2].xyz;
	o.texcoord2 = r1.yyy * gWorld[0].xyz + r2.xyz;
	r2 = r1.xyz * i.normal.yzx;
	r1.xyz = r1.zxy * i.normal.zxy + -r2.xyz;
	r1.xyz = r1.xyz * -i.tangent.www;
	r2 = r1.yyy * gWorld[1].xyz;
	r1.xyw = r1.xxx * gWorld[0].xyz + r2.xyz;
	o.texcoord3 = r1.zzz * gWorld[2].xyz + r1.xyw;
	r1.xy = gRescaleUV1.xy;
	r1.xy = i.texcoord.xy * r1.xy + gUVOffset1.xy;
	o.texcoord4 = r1.xy + gUVOffset[0].xy;
	r1.xy = gRescaleUV2.xy;
	r1.xy = i.texcoord.xy * r1.xy + gUVOffset2.xy;
	o.texcoord5.xy = r1.xy + gUVOffset[1].xy;
	r1.xy = gRescaleUV3.xy;
	r1.xy = i.texcoord.xy * r1.xy + gUVOffset3.xy;
	o.texcoord5.zw = r1.xy + gUVOffset[2].xy;
	r1.zw = float2(-1, 1E-05);
	r1.x = -r1.z + gScatterG_GSquared_PhaseMult_Scale.y;
	r2 = gWorld[1].xyz * i.position.yyy;
	r2 = i.position.xxx * gWorld[0].xyz + r2.xyz;
	r2 = i.position.zzz * gWorld[2].xyz + r2.xyz;
	r2 = i.position.www * gWorld[3].xyz + r2.xyz;
	r3 = r2.xyz + -gViewInverse[3].xyz;
	o.texcoord = r2.xyz;
	r2 = r3.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r1.y = dot(r3.xyz, -gSunDirection.xyz);
	r1.z = r1.y * gScatterG_GSquared_PhaseMult_Scale.x;
	r1.y = r1.y * r1.y + 1;
	r1.x = r1.z * -2 + r1.x;
	r1.x = abs(r1.x) + 1E-05;
	r2.x = pow(r1.x, 1.50001);
	r1.x = 1 / r2.x;
	r1.x = r1.x * r1.y;
	r1.x = r1.x * gScatterG_GSquared_PhaseMult_Scale.z;
	r1.x = r1.x * gScatterG_GSquared_PhaseMult_Scale.w;
	o.texcoord8 = r1.xxx * gSunColor.xyz;
	r1.x = saturate(dot(r3.xyz, gSunDirection.xyz));
	r1.x = r1.x + 1E-05;
	r1.x = log2(r1.x);
	r1.y = r1.w + gPiercingLightPower_Strength_NormalStrength_Thickness.x;
	r1.x = r1.x * r1.y;
	o.texcoord7.w = exp2(r1.x);
	r1.x = dot(-r3.xyz, gSunDirection.xyz);
	r1.xyz = r1.xxx * -gSunDirection.xyz + -r3.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	o.texcoord7.xyz = r1.www * r1.xyz;
	r0.z = min(r0.w, r0.z);
	o.position = r0;
	o.texcoord6.zw = r0.zw;

	return o;
}
