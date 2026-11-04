cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
};

cbuffer TracerCommon : register(b1)
{
	float gHeatHazeScale : packoffset(c0);
	float gHeatHazeWidth : packoffset(c0.y);
	float gHeatHazeSize : packoffset(c0.z);
	float gLifeTimeScale : packoffset(c0.w);
	float gDistanceScale : packoffset(c1);
	float gTotalLifeTimeScale : packoffset(c1.y);
	float gDayNightScale : packoffset(c1.z);
	float4 vCustomData[4] : packoffset(c2);
};

struct VS_IN
{
	float3 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float texcoord3 : TEXCOORD3;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.x = vCustomData[0].x;
	r0.z = 1;
	r0.xyz = r0.xxz * i.position.xyz;
	r1 = -(r0.z) * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.y * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	o.sv_position = r1;
	o.texcoord1 = r1;
	r0.w = -(r0.z) * gWorldView[1].z;
	r0.x = r0.x * gWorldView[0].z + r0.w;
	r0.x = r0.y * gWorldView[2].z + r0.x;
	o.texcoord4 = -(r0.z) * gWorldViewProj[1] + gWorldViewProj[3];
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord3 = -(r0.x);
	o.texcoord = i.texcoord.xy;
	r0 = -(i.position.z) * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.y * gWorldViewProj[2] + r0;
	o.texcoord2 = r0 + gWorldViewProj[3];
	r0.x = -(vCustomData[1].w) * 1.04999995 + 2;
	r0.x = max(r0.x, 0.100000001);
	r0.x = r0.x * vCustomData[2].z;
	r0.x = r0.x * vCustomData[0].w;
	r0.y = i.position.z * 1.79999995;
	r0.y = min(r0.y, 5);
	r0.x = r0.x * 40 + -(r0.y);
	r0.x = max(r0.x, 0);
	r0.yzw = vCustomData[2].yyy * float3(1, 256, 65536);
	r0.yzw = frac(r0.yzw);
	r0.yzw = r0.yzw * float3(0.00999999978, 0.00999999978, 0.00999999978);
	r0.xyz = r0.xxx * r0.yzw;
	r0.w = globalDayNightEffects.w * globalDayNightEffects.w;
	r0.w = r0.w * 12 + 1;
	o.color.xyz = r0.www * r0.xyz;
	r0.x = -(vCustomData[0].z) * 4.25 + 1;
	o.color.w = saturate(-(vCustomData[0].y) * 3.5 + r0.x);

	return o;
}
