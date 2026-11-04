cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float4 r2;
	float3 r3;
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
	r2.x = -(asfloat(r0.z)) * gWorldView[1].z;
	r2.x = asfloat(r0.x) * gWorldView[0].z + r2.x;
	r2.x = asfloat(r0.y) * gWorldView[2].z + r2.x;
	r2.x = r2.x + gWorldView[3].z;
	o.texcoord3 = -(r2.x);
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = r1;
	o.texcoord2 = r1;
	r1 = -(asfloat(r0.z)) * gWorld[1];
	r1 = asfloat(r0.x) * gWorld[0] + r1;
	r1 = asfloat(r0.y) * gWorld[2] + r1;
	r0.xyw = asint(asfloat(r0.xyw) + -(i.position.xyz));
	r0.x = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(-(asfloat(r0.x)) + vCustomData[0].w);
	r0.x = asint(saturate(asfloat(r0.x) / vCustomData[2].w));
	r1 = r1 + gWorld[3];
	o.texcoord4 = r1;
	r1.xyz = -(r1.xyz) + gViewInverse[3].xyz;
	o.texcoord5.xyz = gWorld[3].xyz;
	o.texcoord5.w = vCustomData[0].x * 0.009765625;
	r2.xyz = gWorld[1].xyz * -(vCustomData[0].www);
	r0.y = asint(dot(r2.xyz, r2.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r2.xyz = asfloat(r0.yyy) * r2.xyz;
	o.texcoord6 = r2.xyz;
	r0.y = asint(dot(r1.xyz, r1.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r1.xyz = asfloat(r0.yyy) * r1.xyz;
	r3 = r1.xyz * r2.yzx;
	r1.xyz = r2.xyz * r1.yzx + -(r3.xyz);
	r0.y = asint(dot(r1.xyz, r1.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r1.xyz = asfloat(r0.yyy) * r1.xyz;
	r3 = r2.yzx * r1.xyz;
	r1.xyz = r1.zxy * r2.zxy + -(r3.xyz);
	r0.y = asint(dot(r1.xyz, r1.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	o.texcoord7.xyz = asfloat(r0.yyy) * r1.xyz;
	r0.y = (0 < vCustomData[2].w) ? -1 : 0;
	o.texcoord7.w = (r0.y != 0) ? asfloat(r0.x) : 1;
	r0.x = asint(-(vCustomData[1].w) * 1.04999995 + 2);
	r0.x = asint(max(asfloat(r0.x), 0.100000001));
	r0.x = asint(asfloat(r0.x) * vCustomData[0].w);
	r0.y = asint(asfloat(r0.z) * 2.20000005);
	r0.y = asint(min(asfloat(r0.y), 5));
	r0.x = asint(asfloat(r0.x) * 9.11999989 + -(asfloat(r0.y)));
	r0.x = asint(max(asfloat(r0.x), 0));
	r1.xyz = vCustomData[2].yyy * float3(1, 256, 65536);
	r1.xyz = frac(r1.xyz);
	r1.xyz = r1.xyz * float3(0.100000001, 0.100000001, 0.100000001);
	r1.xyz = asfloat(r0.xxx) * r1.xyz;
	r0.x = asint(saturate(-(vCustomData[0].w) * 0.00300000003 + asfloat(r0.z)));
	r0.x = asint(asfloat(r0.x) * 0.25 + 0.75);
	r0.x = asint(saturate(-(vCustomData[0].z) * gTotalLifeTimeScale + asfloat(r0.x)));
	r2.xyz = vCustomData[1].yyy * float3(0.00400000019, 0.00200000009, 0);
	r2 = asfloat(r0.x) * r2.xyzz;
	r0.x = asint(-(vCustomData[0].z) * gLifeTimeScale + 1);
	r0.x = asint(-(asfloat(r0.z)) * gDistanceScale + asfloat(r0.x));
	r1.w = saturate(-(vCustomData[0].y) * 2.5 + asfloat(r0.x));
	r0 = asint(r2 * asfloat(r0.z) + r1);
	o.color.w = asfloat(r0.w);
	r0.w = asint(globalDayNightEffects.w * globalDayNightEffects.w);
	r0.w = asint(asfloat(r0.w) * 7.59999990 + gDayNightScale);
	o.color.xyz = asfloat(r0.www) * asfloat(r0.xyz);

	return o;
}
