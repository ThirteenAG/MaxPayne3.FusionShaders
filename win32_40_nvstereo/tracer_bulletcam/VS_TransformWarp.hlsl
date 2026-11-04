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
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float3 r2;
	r0.x = asint(i.position.z + -0.009765625);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(min(asfloat(r0.x), 0.0302734375));
	r0.x = asint(asfloat(r0.x) * vCustomData[0].w);
	r0.y = 1107566856;
	r0.z = asint(asfloat(r0.x) * asfloat(r0.y) + 0.00499999989);
	r0.w = asint(asfloat(r0.x) * asfloat(r0.y) + 0.00499999989);
	r1 = -(asfloat(r0.z)) * gWorldViewProj[1];
	r2.xy = i.position.xy;
	r2.z = vCustomData[0].x;
	r0.xy = asint(r2.zz * r2.xy);
	r1 = asfloat(r0.x) * gWorldViewProj[0] + r1;
	r1 = asfloat(r0.y) * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	o.sv_position = r1;
	o.texcoord1 = r1;
	r1.x = -(asfloat(r0.z)) * gWorldView[1].z;
	r1.x = asfloat(r0.x) * gWorldView[0].z + r1.x;
	r1.x = asfloat(r0.y) * gWorldView[2].z + r1.x;
	r0.xyw = asint(asfloat(r0.xyw) + -(i.position.xyz));
	r0.x = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(-(asfloat(r0.x)) + vCustomData[0].w);
	r0.x = asint(saturate(asfloat(r0.x) / vCustomData[2].w));
	r0.y = asint(r1.x + gWorldView[3].z);
	o.texcoord3 = asfloat(asint(-(asfloat(r0.y))));
	o.texcoord = i.texcoord.xy;
	r1 = -(i.position.z) * gWorldViewProj[1];
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.y * gWorldViewProj[2] + r1;
	o.texcoord2 = r1 + gWorldViewProj[3];
	o.texcoord4 = float4(0, 0, 0, 0);
	o.texcoord5 = float4(0, 0, 0, 0);
	o.texcoord6 = float3(0, 0, 0);
	r0.y = (0 < vCustomData[2].w) ? -1 : 0;
	o.texcoord7.w = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord7.xyz = float3(0, 0, 0);
	r0.x = asint(asfloat(r0.z) * 1.79999995);
	r0.x = asint(min(asfloat(r0.x), 5));
	r0.y = asint(-(vCustomData[1].w) * 1.04999995 + 2);
	r0.y = asint(max(asfloat(r0.y), 0.100000001));
	r0.y = asint(asfloat(r0.y) * vCustomData[0].w);
	r0.x = asint(asfloat(r0.y) * 18.2399998 + -(asfloat(r0.x)));
	r0.x = asint(max(asfloat(r0.x), 0));
	r1.xyz = vCustomData[2].yyy * float3(1, 256, 65536);
	r1.xyz = frac(r1.xyz);
	r1.xyz = r1.xyz * float3(0.00999999978, 0.00999999978, 0.00999999978);
	r0.xyw = asint(asfloat(r0.xxx) * r1.xyz);
	r1.x = globalDayNightEffects.w * globalDayNightEffects.w;
	r1.x = r1.x * 7.59999990 + 5;
	o.color.xyz = asfloat(r0.xyw) * r1.xxx;
	r0.x = asint(-(vCustomData[0].z) * 0.649999976 + 1);
	r0.x = asint(-(asfloat(r0.z)) * 0.119999997 + asfloat(r0.x));
	o.color.w = saturate(-(vCustomData[0].y) * 1.5 + asfloat(r0.x));

	return o;
}
