cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
};

cbuffer PedWind : register(b4)
{
	float4 gWindParams : packoffset(c0);
	float4 AirResist : packoffset(c1);
	float WindStr : packoffset(c2);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float3 position1 : POSITION1;
	float3 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
	float3 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float4 r6;
	float3 r7;
	float4 r8;
	r0.x = asint(globalScalars3.z + 0.00000999999975);
	r0.y = asint(globalScalars4.z + 0.00000999999975);
	r0.z = 925353388;
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r1.xyz = i.normal.xyz + i.normal1.xyz;
	r0.x = asint(dot(asfloat(r0.xyz), r1.xyz));
	r0.x = asint(max(asfloat(r0.x), 0.25));
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.y = asint(i.color1.z * AirResist.w);
	r0.y = asint(asfloat(r0.y) * 5);
	r2.z = asint(-(asfloat(r0.y)));
	r2.xy = asint(-(i.color1.xx));
	r0.yzw = asint(r1.xyz * asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw));
	r2 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r2 = (int4)asfloat(r2);
	r2 = r2 * int4(3, 3, 3, 3);
	r3 = i.blendweight.y * gBoneMtx[r2.y / 3][0];
	r3 = gBoneMtx[r2.x / 3][0] * i.blendweight.x + r3;
	r3 = gBoneMtx[r2.z / 3][0] * i.blendweight.z + r3;
	r3 = gBoneMtx[r2.w / 3][0] * i.blendweight.w + r3;
	r4.xyz = i.position.xyz + i.position1.xyz;
	r4.w = 1;
	r5.x = dot(r3, r4);
	r6 = i.blendweight.y * gBoneMtx[r2.y / 3][2];
	r6 = gBoneMtx[r2.x / 3][2] * i.blendweight.x + r6;
	r6 = gBoneMtx[r2.z / 3][2] * i.blendweight.z + r6;
	r6 = gBoneMtx[r2.w / 3][2] * i.blendweight.w + r6;
	r5.z = dot(r6, r4);
	r7 = r5.xxz * float3(6, 10, 10);
	r0.w = asint(r7.z + r7.y);
	r8 = i.blendweight.y * gBoneMtx[r2.y / 3][1];
	r8 = gBoneMtx[r2.x / 3][1] * i.blendweight.x + r8;
	r8 = gBoneMtx[r2.z / 3][1] * i.blendweight.z + r8;
	r2 = asint(gBoneMtx[r2.w / 3][1] * i.blendweight.w + r8);
	r5.y = dot(asfloat(r2), r4);
	r0.w = asint(r5.y * 10 + asfloat(r0.w));
	r1.w = AirResist.w * 0.00999999978 + 1;
	r2.w = asint(r1.w * globalScalars3.y);
	r1.w = globalScalars3.y * r1.w + r7.x;
	r1.w = sin(r1.w);
	r0.w = asint(asfloat(r2.w) * gWindParams.z + asfloat(r0.w));
	r0.w = asint(sin(asfloat(r0.w)));
	r3.w = saturate(WindStr);
	r1.w = abs(r1.w) * r3.w;
	r0.w = asint(abs(asfloat(r0.w)) * r1.w);
	r1.w = r5.y * 4;
	r1.w = asfloat(r2.w) * gWindParams.w + r1.w;
	r1.w = sin(r1.w);
	r0.w = asint(asfloat(r0.w) * abs(r1.w));
	o.texcoord8.xyz = asfloat(r0.xyz) * asfloat(r0.www) + r5.xyz;
	r0.xyz = asint(r5.yyy * gWorld[1].xyz);
	r0.xyz = asint(r5.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(r5.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	o.texcoord7 = asfloat(r0.xyz) + gWorld[3].xyz;
	o.texcoord8.w = 1;
	o.texcoord = i.texcoord.xy;
	r0.y = asint(dot(asfloat(r2.xyz), r1.xyz));
	r4.xyz = asfloat(r0.yyy) * gWorld[1].xyz;
	r0.x = asint(dot(r3.xyz, r1.xyz));
	r0.z = asint(dot(r6.xyz, r1.xyz));
	r1.xyz = asfloat(r0.xxx) * gWorld[0].xyz + r4.xyz;
	o.texcoord9 = asfloat(r0.xyz);
	r0.xyz = asint(asfloat(r0.zzz) * gWorld[2].xyz + r1.xyz);
	r1.x = -(asfloat(r0.z)) + 1;
	r1.x = r1.x * r1.x;
	r1.x = -(r1.x) * 0.0199999996 + 1;
	r0.w = asint(max(asfloat(r0.z), r1.x));
	r1.xyz = asfloat(r0.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = asint(dot(r1.xyz, r1.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	o.texcoord1.xyz = asfloat(r0.www) * r1.xyz;
	o.texcoord1.w = 1;
	o.texcoord2.y = i.color.y * globalScalars2.w;
	o.texcoord2.xzw = i.color.xzw;
	r1 = i.tangent + i.tangent1;
	r0.w = asint(dot(asfloat(r2.xyz), r1.xyz));
	r2.xyz = asint(asfloat(r0.www) * gWorld[1].xyz);
	r0.w = asint(dot(r3.xyz, r1.xyz));
	r2.xyz = asint(asfloat(r0.www) * gWorld[0].xyz + asfloat(r2.xyz));
	r0.w = asint(dot(r6.xyz, r1.xyz));
	r1.xyz = asfloat(r0.www) * gWorld[2].xyz + asfloat(r2.xyz);
	o.texcoord4 = r1.xyz;
	r2.xyz = asint(asfloat(r0.yzx) * r1.zxy);
	r0.xyz = asint(r1.yzx * asfloat(r0.zxy) + -(asfloat(r2.xyz)));
	o.texcoord5.xyz = r1.www * asfloat(r0.xyz);
	o.texcoord5.w = r1.w;

	return o;
}
