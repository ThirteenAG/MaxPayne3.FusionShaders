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
	r0.xy = asint(i.position.zz + float2(-0.009765625, 0.25));
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(min(asfloat(r0.x), 0.0302734375));
	r0.x = asint(asfloat(r0.x) * vCustomData[0].w);
	r0.z = 1107566856;
	r0.x = asint(asfloat(r0.x) * asfloat(r0.z) + 0.0250000004);
	r1.z = min(asfloat(r0.x), abs(vCustomData[3].y));
	r2 = -(r1.z) * gWorldViewProj[1];
	r0.xz = asint(i.position.xy);
	r0.w = asint(vCustomData[0].x);
	r0.xz = asint(asfloat(r0.ww) * asfloat(r0.xz));
	r0.w = asint(abs(r1.z) / abs(vCustomData[3].y));
	r1.xy = vCustomData[3].xz * asfloat(r0.ww) + asfloat(r0.xz);
	r2 = r1.x * gWorldViewProj[0] + r2;
	r2 = r1.y * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	o.sv_position = r2;
	r0.x = asint(-(r1.z) * gWorldView[1].z);
	r0.x = asint(r1.x * gWorldView[0].z + asfloat(r0.x));
	r0.x = asint(r1.y * gWorldView[2].z + asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) + gWorldView[3].z);
	o.texcoord3 = asfloat(asint(-(asfloat(r0.x))));
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = r2;
	o.texcoord2 = r2;
	r2 = -(r1.z) * gWorld[1];
	r2 = r1.x * gWorld[0] + r2;
	r2 = r1.y * gWorld[2] + r2;
	r0.xzw = asint(r1.xyz + -(i.position.xyz));
	r0.x = asint(dot(asfloat(r0.xzw), asfloat(r0.xzw)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(-(asfloat(r0.x)) + vCustomData[0].w);
	r0.x = asint(saturate(asfloat(r0.x) / vCustomData[2].w));
	r2 = r2 + gWorld[3];
	o.texcoord4 = r2;
	r1.xyw = -(r2.xyz) + gViewInverse[3].xyz;
	o.texcoord5.xyz = gWorld[3].xyz;
	o.texcoord5.w = vCustomData[0].x * 0.009765625;
	r2.xyz = gWorld[1].xyz * -(vCustomData[0].www);
	r0.z = asint(vCustomData[0].w / abs(vCustomData[3].y));
	r0.zw = asint(asfloat(r0.zz) * vCustomData[3].xz);
	r2.xyz = asfloat(r0.zzz) * gWorld[0].xyz + r2.xyz;
	r2.xyz = asfloat(r0.www) * gWorld[2].xyz + r2.xyz;
	r0.z = asint(dot(r2.xyz, r2.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r2.xyz = asfloat(r0.zzz) * r2.xyz;
	o.texcoord6 = r2.xyz;
	r0.z = asint(dot(r1.xyw, r1.xyw));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r1.xyw = asfloat(r0.zzz) * r1.xyw;
	r3 = r1.xyw * r2.yzx;
	r1.xyw = r2.xyz * r1.ywx + -(r3.xyz);
	r0.z = asint(dot(r1.xyw, r1.xyw));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r1.xyw = asfloat(r0.zzz) * r1.xyw;
	r3 = r2.yzx * r1.xyw;
	r1.xyw = r1.wxy * r2.zxy + -(r3.xyz);
	r0.z = asint(dot(r1.xyw, r1.xyw));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	o.texcoord7.xyz = asfloat(r0.zzz) * r1.xyw;
	r0.z = (0 < vCustomData[2].w) ? -1 : 0;
	o.texcoord7.w = (r0.z != 0) ? asfloat(r0.x) : 1;
	r0.x = asint(gTotalLifeTimeScale * vCustomData[0].z);
	r0.x = asint(saturate(-(asfloat(r0.x)) * 4 + asfloat(r0.y)));
	r0.y = asint(r1.z * 2.20000005);
	r0.y = asint(min(asfloat(r0.y), 5));
	r0.z = asint(-(vCustomData[1].w) * 1.04999995 + 2);
	r0.z = asint(max(asfloat(r0.z), 0.100000001));
	r0.z = asint(asfloat(r0.z) * vCustomData[0].w);
	r0.y = asint(asfloat(r0.z) * 0.490000010 + -(asfloat(r0.y)));
	r0.y = asint(max(asfloat(r0.y), 0));
	r1.xyw = vCustomData[2].yyy * float3(1, 256, 65536);
	r1.xyw = frac(r1.xyw);
	r1.xyw = r1.xyw * float3(0.100000001, 0.100000001, 0.100000001);
	r2.xyz = asfloat(r0.yyy) * r1.xyw;
	r0.y = asint(-(vCustomData[0].z) * gLifeTimeScale + 1);
	r0.y = asint(-(r1.z) * gDistanceScale + asfloat(r0.y));
	r0.y = asint(-(vCustomData[0].y) * 1.04999995 + asfloat(r0.y));
	r2.w = saturate(-(vCustomData[1].x) * 0.000000100000001 + asfloat(r0.y));
	r1 = vCustomData[1].y * float4(0.00400000019, 0.00200000009, 0, 0);
	r0 = asint(r1 * asfloat(r0.x) + r2);
	o.color.xyz = asfloat(r0.xyz) * gDayNightScale;
	o.color.w = asfloat(r0.w);

	return o;
}
