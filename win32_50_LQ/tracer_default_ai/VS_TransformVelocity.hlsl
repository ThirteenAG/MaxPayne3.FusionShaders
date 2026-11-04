cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	r0.x = asint(vCustomData[1].z * 10);
	r0.x = asint(i.position.z * 1000 + asfloat(r0.x));
	r0.x = asint(sin(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + 0.5);
	r0.y = asint(vCustomData[0].z + vCustomData[0].y);
	r0.y = asint(asfloat(r0.y) + -0.140000001);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.z = asint(i.position.z + -0.009765625);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(min(asfloat(r0.z), 0.0302734375));
	r0.z = asint(asfloat(r0.z) * vCustomData[0].w);
	r0.w = 1107566856;
	r0.z = asint(asfloat(r0.z) * asfloat(r0.w) + 0.0250000004);
	r1.z = min(asfloat(r0.z), abs(vCustomData[3].y));
	r0.z = asint(asfloat(r0.y) * r1.z);
	r0.yw = asint(asfloat(r0.yy) * float2(3, 3) + vCustomData[0].xx);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.z));
	r2 = -(r1.z) * gWorldViewProj[1];
	r3.xy = i.position.xy;
	r0.yz = asint(asfloat(r0.yw) * r3.xy);
	o.texcoord5.w = asfloat(r0.w) * 0.009765625;
	r0.w = asint(abs(r1.z) / abs(vCustomData[3].y));
	r1.xy = vCustomData[3].xz * asfloat(r0.ww) + asfloat(r0.yz);
	r2 = r1.x * gWorldViewProj[0] + r2;
	r2 = r1.y * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	r2.y = asfloat(r0.x) * 0.00300000003 + r2.y;
	o.sv_position = r2;
	r0.x = asint(-(r1.z) * gWorldView[1].z);
	r0.x = asint(r1.x * gWorldView[0].z + asfloat(r0.x));
	r0.x = asint(r1.y * gWorldView[2].z + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) + gWorldView[3].z);
	o.texcoord3 = asfloat(asint(-(asfloat(r0.x))));
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = r2;
	o.texcoord2 = r2;
	r0 = asint(-(r1.z) * gWorld[1]);
	r0 = asint(r1.x * gWorld[0] + asfloat(r0));
	r0 = asint(r1.y * gWorld[2] + asfloat(r0));
	r1.xyw = r1.xyz + -(i.position.xyz);
	r1.x = dot(r1.xyw, r1.xyw);
	r1.x = sqrt(r1.x);
	r1.x = -(r1.x) + vCustomData[0].w;
	r1.x = saturate(r1.x / vCustomData[2].w);
	r0 = asint(asfloat(r0) + gWorld[3]);
	o.texcoord4 = asfloat(r0);
	r0.xyz = asint(-(asfloat(r0.xyz)) + gViewInverse[3].xyz);
	o.texcoord5.xyz = gWorld[3].xyz;
	r2.xyz = gWorld[1].xyz * -(vCustomData[0].www);
	r0.w = asint(vCustomData[0].w / abs(vCustomData[3].y));
	r1.yw = asfloat(r0.ww) * vCustomData[3].xz;
	r2.xyz = r1.yyy * gWorld[0].xyz + r2.xyz;
	r2.xyz = r1.www * gWorld[2].xyz + r2.xyz;
	r0.w = asint(dot(r2.xyz, r2.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asfloat(r0.www) * r2.xyz;
	o.texcoord6 = r2.xyz;
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r3 = asfloat(r0.xyz) * r2.yzx;
	r0.xyz = asint(r2.xyz * asfloat(r0.yzx) + -(r3.xyz));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r3 = r2.yzx * asfloat(r0.xyz);
	r0.xyz = asint(asfloat(r0.zxy) * r2.zxy + -(r3.xyz));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	o.texcoord7.xyz = asfloat(r0.www) * asfloat(r0.xyz);
	r0.x = (0 < vCustomData[2].w) ? -1 : 0;
	o.texcoord7.w = (r0.x != 0) ? r1.x : 1;
	r0.x = asint(r1.z * 2.20000005);
	r0.x = asint(min(asfloat(r0.x), 5));
	r0.y = asint(-(vCustomData[1].w) * 1.04999995 + 2);
	r0.y = asint(max(asfloat(r0.y), 0.100000001));
	r0.y = asint(asfloat(r0.y) * vCustomData[0].w);
	r0.x = asint(asfloat(r0.y) * 0.490000010 + -(asfloat(r0.x)));
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.yzw = asint(vCustomData[2].yyy * float3(1, 256, 65536));
	r0.yzw = asint(frac(asfloat(r0.yzw)));
	r0.yzw = asint(asfloat(r0.yzw) * float3(0.100000001, 0.100000001, 0.100000001));
	o.color.xyz = asfloat(r0.xxx) * asfloat(r0.yzw);
	r0.x = asint(-(vCustomData[0].z) * gLifeTimeScale + 1);
	r0.x = asint(-(r1.z) * gDistanceScale + asfloat(r0.x));
	r0.x = asint(-(vCustomData[0].y) * 1.04999995 + asfloat(r0.x));
	o.color.w = saturate(-(vCustomData[1].x) * 0.000000100000001 + asfloat(r0.x));

	return o;
}
