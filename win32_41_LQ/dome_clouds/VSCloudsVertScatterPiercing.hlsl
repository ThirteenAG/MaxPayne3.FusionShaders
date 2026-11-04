cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer Dome : register(b1)
{
	float3 SkyColor : packoffset(c0);
	float3 EastColor : packoffset(c1);
	float3 WestColor : packoffset(c2);
	float3 gSunDirection : packoffset(c3);
	float3 gSunColor : packoffset(c4);
	float3 gCloudColor : packoffset(c5);
	float3 gAmbientColor : packoffset(c6);
	float3 gBounceColor : packoffset(c7);
	float2 gDensityShiftScale : packoffset(c8);
	float4 gScatterG_GSquared_PhaseMult_Scale : packoffset(c9);
	float4 gPiercingLightPower_Strength_NormalStrength_Thickness : packoffset(c10);
	float3 gScaleDiffuseFillAmbient : packoffset(c11);
	float2 gWrapLighting : packoffset(c12);
	float gHDRExposure : packoffset(c12.z);
	float4 gNearFarQMult : packoffset(c13);
	float3 gAnimCombine : packoffset(c14);
	float3 gAnimSculpt : packoffset(c15);
	float3 gAnimBlendWeights : packoffset(c16);
	float2 gUVOffset[3] : packoffset(c17);
	float3 gReflScales : packoffset(c20);
	float2 gUVOffset1 : packoffset(c21);
	float2 gUVOffset2 : packoffset(c21.z);
	float2 gUVOffset3 : packoffset(c22);
	float2 gRescaleUV1 : packoffset(c22.z);
	float2 gRescaleUV2 : packoffset(c23);
	float2 gRescaleUV3 : packoffset(c23.z);
};

struct VS_IN
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float2 texcoord : TEXCOORD;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
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
	float3 r1;
	float4 r2;
	float3 r3;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = i.position.w * gWorldViewProj[3] + r0;
	r0.z = min(r0.w, r0.z);
	o.sv_position = r0;
	o.texcoord6.zw = r0.zw;
	r1 = i.position.yyy * gWorld[1].xyz;
	r1 = i.position.xxx * gWorld[0].xyz + r1.xyz;
	r1 = i.position.zzz * gWorld[2].xyz + r1.xyz;
	r1 = i.position.www * gWorld[3].xyz + r1.xyz;
	o.texcoord = r1.xyz;
	r1 = r1.xyz + -(gViewInverse[3].xyz);
	r1 = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.xyz = i.normal.yyy * gWorld[1].xyz;
	r2.xyz = i.normal.xxx * gWorld[0].xyz + r2.xyz;
	o.texcoord1 = i.normal.zzz * gWorld[2].xyz + r2.xyz;
	r2.xyz = i.normal.yzx * float3(0, -1, 0);
	r2.xyz = i.normal.xyz * float3(-1, 0, 0) + -(r2.xyz);
	r3 = r2.xxx * gWorld[2].xyz;
	o.texcoord2 = r2.yyy * gWorld[0].xyz + r3.xyz;
	r3 = r2.xyz * i.normal.yzx;
	r2.xyz = r2.zxy * i.normal.zxy + -(r3.xyz);
	r2.xyz = r2.xyz * -(i.tangent.www);
	r3 = r2.yyy * gWorld[1].xyz;
	r2.xyw = r2.xxx * gWorld[0].xyz + r3.xyz;
	o.texcoord3 = r2.zzz * gWorld[2].xyz + r2.xyw;
	r2.xy = i.texcoord.xy * gRescaleUV1.xy + gUVOffset1.xy;
	o.texcoord4 = r2.xy + gUVOffset[0].xy;
	r2.xy = i.texcoord.xy * gRescaleUV2.xy + gUVOffset2.xy;
	o.texcoord5.xy = r2.xy + gUVOffset[1].xy;
	r2.xy = i.texcoord.xy * gRescaleUV3.xy + gUVOffset3.xy;
	o.texcoord5.zw = r2.xy + gUVOffset[2].xy;
	r0.xyz = r0.xwy * float3(0.5, 0.5, 0.5);
	o.texcoord6.y = r0.w * 0.5 + -(r0.z);
	o.texcoord6.x = r0.y + r0.x;
	r0.x = dot(r1.xyz, r1.xyz);
	r0.x = rsqrt(r0.x);
	r0.xyz = r0.xxx * r1.xyz;
	r0.w = dot(-(r0.xyz), gSunDirection.xyz);
	r1 = -(r0.www) * gSunDirection.xyz + -(r0.xyz);
	r1 = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord7.xyz = r0.www * r1.xyz;
	r0.w = saturate(dot(r0.xyz, gSunDirection.xyz));
	r0.x = dot(r0.xyz, -(gSunDirection.xyz));
	r0.y = r0.w + 0.00000999999975;
	r0.y = log2(r0.y);
	r0.z = gPiercingLightPower_Strength_NormalStrength_Thickness.x + 0.00000999999975;
	r0.y = r0.y * r0.z;
	o.texcoord7.w = exp2(r0.y);
	r0.y = dot(r0.xx, gScatterG_GSquared_PhaseMult_Scale.xx);
	r0.x = r0.x * r0.x + 1;
	r0.z = gScatterG_GSquared_PhaseMult_Scale.y + 1;
	r0.y = -(r0.y) + r0.z;
	r0.y = abs(r0.y) + 0.00000999999975;
	r0.y = log2(r0.y);
	r0.y = r0.y * 1.50001001;
	r0.y = exp2(r0.y);
	r0.x = r0.x / r0.y;
	r0.x = r0.x * gScatterG_GSquared_PhaseMult_Scale.z;
	r0.x = r0.x * gScatterG_GSquared_PhaseMult_Scale.w;
	o.texcoord8 = r0.xxx * gSunColor.xyz;

	return o;
}
