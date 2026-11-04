cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer TracerCommon : register(b1)
{
	float4 vCustomData[4] : packoffset(c0);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	r0.z = gWorldView[1].x;
	r0.x = gWorldView[2].x;
	r0.y = gWorldView[0].x;
	r1.y = asint(gWorldView[2].y);
	r1.z = asint(gWorldView[0].y);
	r1.x = asint(gWorldView[1].y);
	r2.xyz = asint(r0.xyz * asfloat(r1.xyz));
	r0.xyz = r0.zxy * asfloat(r1.yzx) + -(asfloat(r2.xyz));
	r1.xyz = asint(gWorldView[1].zxy * gWorldView[2].yzx);
	r1.xyz = asint(gWorldView[1].yzx * gWorldView[2].zxy + -(asfloat(r1.xyz)));
	r0.w = dot(asfloat(r1.xyz), gWorldView[0].xyz);
	r0.xyz = r0.xyz / r0.www;
	r1.xy = asint(r0.yz * float2(1, 0));
	r1 = asint(r0.zxxz * float4(0, 1, 1, 0) + -(asfloat(r1.xyyx)));
	r0.xyz = -(r0.zzz) * r0.xyz + float3(0, 0, 1);
	r0.w = dot(asfloat(r1.zw), asfloat(r1.zw));
	r0.w = rsqrt(r0.w);
	r1 = asint(r0.w * asfloat(r1));
	r1 = asint(asfloat(r1.zxyw) * float4(1, 1, 0, 0));
	r2.xz = r1.xw;
	r2.y = 0;
	r1.x = 0;
	r1.xyz = asint(-(asfloat(r2.xyz)) + asfloat(r1.xyz));
	r0.w = dot(asfloat(r1.xy), asfloat(r1.xy));
	r0.w = rsqrt(r0.w);
	r1.xyz = asint(r0.www * asfloat(r1.xyz));
	r0.w = vCustomData[0].w + 0.5;
	r1.w = asint(position.z + -0.009765625);
	r1.w = asint(max(asfloat(r1.w), 0));
	r2.z = asint(min(asfloat(r1.w), 0.0302734375));
	r3.z = 33.0322571;
	r3.yw = asfloat(r2.zz) * r3.zz + float2(-0.5, -1);
	r1.w = asint(-(r3.y) + -0.5);
	r1.w = asint(asfloat(r1.w) * 3.14159250);
	r1.w = asint(sin(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + 1);
	r1.w = asint(log2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) * 1.20000005);
	r1.w = asint(exp2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + -1);
	r0.w = asfloat(r1.w) * -(r0.w) + -0.5;
	r1.w = asint(r3.w * 3.14159250);
	r2.w = (0 < r3.y) ? -1 : 0;
	r1.w = asint(sin(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + 1);
	r1.w = asint(log2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) * 1.20000005);
	r1.w = asint(exp2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + -1);
	r3.y = -(vCustomData[0].w) + 0.5;
	r1.w = asint(asfloat(r1.w) * r3.y + 0.5);
	r0.w = (r2.w != 0) ? asfloat(r1.w) : r0.w;
	r0.w = asfloat(r2.z) * r3.z + r0.w;
	r0.w = r0.w + 0.5;
	r0.w = r0.w * 0.5;
	r1.w = (-0.5 < vCustomData[0].w) ? -1 : 0;
	r2.xy = asint(position.xy);
	r3.x = vCustomData[0].x;
	r3.xyz = asfloat(r2.xyz) * r3.xxz;
	r2.x = asint(asfloat(r2.z) * 103.773895);
	r2.x = asint(sin(-(asfloat(r2.x))));
	r2.x = asint(asfloat(r2.x) + 1);
	r2.x = asint(-(asfloat(r2.x)) * asfloat(r2.x) + 1);
	r0.w = (r1.w != 0) ? r0.w : r3.z;
	r3.w = r0.w * vCustomData[1].z;
	r0.w = dot(r3.xy, asfloat(r1.xy));
	r1.xyz = asint(-(r0.www) * asfloat(r1.xyz) + r3.xyw);
	r2.yz = asint(r3.zz * vCustomData[1].xy);
	r2.yz = asint(sin(asfloat(r2.yz)));
	r1.w = asint(dot(r0.xyz, r0.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r0.xyz = r0.xyz * asfloat(r1.www);
	r0.xyz = r0.www * r0.xyz + asfloat(r1.xyz);
	r1.z = 0;
	r0.w = asfloat(r2.z) * vCustomData[2].x;
	r0.w = asfloat(r2.y) * vCustomData[1].w + r0.w;
	r0.w = asfloat(r2.x) * r0.w;
	r2.x = asint(sin(vCustomData[3].z));
	r3.x = cos(vCustomData[3].z);
	r1.x = asint(r0.w * r3.x);
	r1.y = asint(r0.w * asfloat(r2.x));
	r0.xyz = r0.xyz + asfloat(r1.xyz);
	r1 = asint(r0.y * gWorldViewProj[1]);
	r1 = asint(r0.x * gWorldViewProj[0] + asfloat(r1));
	r0 = r0.z * gWorldViewProj[2] + asfloat(r1);
	o.sv_position = r0 + gWorldViewProj[3];
	r0.xyz = vCustomData[2].yyy * float3(1, 256, 65536);
	r0.xyz = frac(r0.xyz);
	o.color.xyz = r0.xyz * vCustomData[0].zzz;
	o.color.w = 1;

	return o;
}
