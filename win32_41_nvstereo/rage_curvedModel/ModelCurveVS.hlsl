cbuffer _Globals : register(b1)
{
	float3 DiffuseColour : packoffset(c49);
	float SegmentSize : packoffset(c50);
	float4 curveCoeffs[60] : packoffset(c148);
	float4 approxTangent[21] : packoffset(c85);
	float4 velocity[21] : packoffset(c106);
	float3 uvScales : packoffset(c51);
	float radius : packoffset(c52);
	float MotionBlurAmt : packoffset(c53);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

struct VS_IN
{
	float3 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	float3 r6;
	r0.x = asint(i.sv_position.y * SegmentSize);
	r0.y = (int)asfloat(r0.x);
	r0.x = asint(trunc(asfloat(r0.x)));
	r1.y = asint(i.sv_position.y * SegmentSize + -(asfloat(r0.x)));
	r0.x = r0.y * 3;
	r0.z = asint(asfloat(r1.y) + 0.00100000005);
	r2.z = asfloat(r0.z) * asfloat(r0.z);
	r2.w = asfloat(r0.z) * r2.z;
	r1.x = 1065353216;
	r2.xy = asfloat(r1.xy) + float2(0, 0.00100000005);
	r3.z = dot(curveCoeffs[r0.x], r2);
	r0.zw = r0.yy * int2(3, 3) + int2(1, 2);
	r3.x = dot(curveCoeffs[r0.z], r2);
	r3.y = dot(curveCoeffs[r0.w], r2);
	r1.z = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.w = asint(asfloat(r1.y) * asfloat(r1.z));
	r2.x = dot(curveCoeffs[r0.x], asfloat(r1));
	r2.y = dot(curveCoeffs[r0.z], asfloat(r1));
	r2.z = dot(curveCoeffs[r0.w], asfloat(r1));
	r0.xzw = asint(-(r2.yzx) + r3.xyz);
	r1.x = asint(dot(asfloat(r0.xzw), asfloat(r0.xzw)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xzw = asint(asfloat(r0.xzw) * asfloat(r1.xxx));
	r1.x = asint(-(asfloat(r1.y)) + 1);
	r1.z = r0.y + 1;
	r3.xyz = asfloat(r1.yyy) * approxTangent[r1.z].zxy;
	r3.xyz = approxTangent[r0.y].zxy * asfloat(r1.xxx) + r3.xyz;
	r4 = asfloat(r0.wxz) * r3.xyz;
	r3.xyz = asfloat(r0.zwx) * r3.yzx + -(r4.xyz);
	r1.w = asint(dot(r3.xyz, r3.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.xyz = asfloat(r1.www) * r3.xyz;
	r4 = asfloat(r0.zwx) * r3.zxy;
	r4 = r3.yzx * asfloat(r0.wxz) + -(r4.xyz);
	r1.w = asint(dot(r4.xyz, r4.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4 = asfloat(r1.www) * r4.xyz;
	r5.xyz = r4.zxy * i.sv_position.xxx;
	r6 = r3.zxy * i.sv_position.zzz;
	r6 = r6.xyz * radius;
	r5.xyz = r5.xyz * radius + r6.xyz;
	r2.xyz = r2.xyz + r5.xyz;
	r5 = asfloat(r1.y) * velocity[r1.z];
	r1.z = asint(-(approxTangent[r0.y].w) + approxTangent[r1.z].w);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.z) + approxTangent[r0.y].w);
	r5 = velocity[r0.y] * asfloat(r1.x) + r5;
	r0.y = asint(asfloat(r1.y) * uvScales.z);
	o.texcoord1.y = i.texcoord.y * uvScales.y + asfloat(r0.y);
	r1.xyz = asint(r3.yzx * i.normal.zzz);
	r3.xyz = r3.xyz * i.tangent.zzz;
	r3.xyz = r4.xyz * i.tangent.xxx + r3.xyz;
	r1.xyz = asint(r4.yzx * i.normal.xxx + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r0.zwx) * i.normal.yyy + asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.xzw) * i.tangent.yyy + r3.xyz);
	r0.w = asint(dot(asfloat(r1.yzx), r5.xyz));
	r0.w = (0 < asfloat(r0.w)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r3.xyz = asfloat(r0.www) * r5.xyz;
	o.texcoord3.w = r5.w;
	r2.xyz = r3.xyz * MotionBlurAmt + r2.xyz;
	r3 = r2.y * gWorldViewProj[1];
	r3 = r2.x * gWorldViewProj[0] + r3;
	r3 = r2.z * gWorldViewProj[2] + r3;
	o.sv_position = r3 + gWorldViewProj[3];
	r3.xyz = r2.yyy * gWorld[1].xyz;
	r2.xyw = r2.xxx * gWorld[0].xyz + r3.xyz;
	r2.xyz = r2.zzz * gWorld[2].xyz + r2.xyw;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	o.texcoord = r2.xyz;
	r2.xyz = -(r2.xyz) + gViewInverse[3].xyz;
	o.texcoord1.x = i.texcoord.x * uvScales.x;
	r3.xyz = asfloat(r1.zzz) * gWorld[1].xyz;
	r3.xyz = asfloat(r1.yyy) * gWorld[0].xyz + r3.xyz;
	r3.xyz = asfloat(r1.xxx) * gWorld[2].xyz + r3.xyz;
	r0.w = asint(dot(r3.xyz, r3.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	o.texcoord2 = asfloat(r0.www) * r3.xyz;
	o.texcoord3.xyz = i.color.xyz;
	r3.xyz = asfloat(r0.xxx) * gWorld[1].xyz;
	r3.xyz = asfloat(r0.zzz) * gWorld[0].xyz + r3.xyz;
	r3.xyz = asfloat(r0.yyy) * gWorld[2].xyz + r3.xyz;
	r0.w = asint(dot(r3.xyz, r3.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	o.texcoord4 = asfloat(r0.www) * r3.xyz;
	r3.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	r0.xyz = asint(asfloat(r1.zxy) * asfloat(r0.yzx) + -(r3.xyz));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	o.texcoord5 = asfloat(r0.www) * asfloat(r0.xyz);
	r0.x = asint(dot(r2.xyz, r2.xyz));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	o.texcoord6 = asfloat(r0.xxx) * r2.xyz;

	return o;
}
