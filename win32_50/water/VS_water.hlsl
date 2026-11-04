cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer WaterSim : register(b1)
{
	float4 waterRenderSimParam : packoffset(c0);
};

struct VS_IN
{
	float3 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	r0.x = asint(dot(i.normal.xy, i.normal.xy));
	r0.x = asint(asfloat(r0.x) + 0.0000999999975);
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.x) + -0.200000003);
	r0.y = asint(saturate(asfloat(r0.y) * 5));
	r0.zw = asint(i.color.xz + float2(-0.5, -0.5));
	r0.z = asint(asfloat(r0.z) * 8);
	r1.x = asfloat(r0.z) * asfloat(r0.z);
	r1.y = i.position.z + -(waterRenderSimParam.z);
	r1.y = r1.y * waterRenderSimParam.x + waterRenderSimParam.z;
	r1.z = r1.y * r1.y + r1.x;
	r1.z = r1.z + 0.0000999999975;
	r1.w = sqrt(r1.z);
	r1.z = r1.z / r1.w;
	r1.w = r1.z * 0.899999976;
	r0.z = (r1.w < asfloat(r0.z)) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	r0.y = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.z = asint(r1.y / r1.z);
	r1.x = r1.z * r1.z + -(r1.x);
	r1.x = sqrt(r1.x);
	r0.x = asint(r1.x / asfloat(r0.x));
	r0.x = asint(asfloat(r0.z) * asfloat(r0.x));
	r1.x = saturate(asfloat(r0.z) * 0.5 + 0.5);
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(asfloat(r0.z) * 6);
	r0.y = asint(asfloat(r0.y) * r1.x);
	r0.x = asint(asfloat(r0.x) * 12 + asfloat(r0.z));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x) + -(asfloat(r0.z)));
	r0.xy = asint(asfloat(r0.xx) * i.normal.xy);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r0.z = asint(asfloat(r0.z) + 0.0000999999975);
	r0.w = asint(saturate(asfloat(r0.w) * 16 + -(r1.y)));
	r0.w = asint(asfloat(r0.w) * 0.5);
	r0.z = asint(asfloat(r0.w) / asfloat(r0.z));
	r0.z = asint(min(asfloat(r0.z), 1));
	r0.xy = asint(asfloat(r0.xy) * asfloat(r0.zz) + i.position.xy);
	r2 = asfloat(r0.y) * gWorldViewProj[1];
	r0 = asint(asfloat(r0.x) * gWorldViewProj[0] + r2);
	r0 = asint(r1.y * gWorldViewProj[2] + asfloat(r0));
	r0 = asint(asfloat(r0.xywz) + gWorldViewProj[3].xywz);
	o.sv_position = asfloat(r0.xywz);
	o.texcoord.xyz = asfloat(r0.xyz);
	o.texcoord5.w = asfloat(r0.z);
	r0.xyz = asint(i.position.yyy * gWorld[1].xyz);
	r0.xyz = asint(i.position.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(r1.yyy * gWorld[2].xyz + asfloat(r0.xyz));
	o.texcoord4.y = r1.y;
	r0.xyz = asint(asfloat(r0.xyz) + gWorld[3].xyz);
	r0.w = asint(asfloat(r0.z) + -(waterRenderSimParam.z));
	r0.w = asint(asfloat(r0.w) + -2);
	o.texcoord.w = saturate(asfloat(r0.w) * 0.5);
	r0.w = asint(waterRenderSimParam.x * 0.100000001);
	r1.xyz = i.normal.xyz + float3(0, 0, -1);
	o.texcoord1.xyz = asfloat(r0.www) * r1.xyz + float3(0, 0, 1);
	o.texcoord1.w = 0;
	o.texcoord2.xyz = asfloat(r0.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + -(gViewInverse[3].xyz));
	o.texcoord5.xyz = asfloat(asint(-(asfloat(r0.xyz))));
	o.texcoord2.w = 0;
	r0.xy = asint(gViewInverse[2].xy + float2(0.00000999999975, 0.00000999999975));
	r0.z = 925353388;
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r1.xy = gViewInverse[3].xy;
	r1.z = waterRenderSimParam.z;
	r1.xyz = r1.xyz + -(gWorld[3].xyz);
	r0.w = asint(gViewInverse[2].z + gViewInverse[2].z);
	r0.w = asint(max(abs(asfloat(r0.w)), 2000));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + r1.xyz);
	r0.yw = asint(asfloat(r0.yy) * gWorldViewProj[1].yw);
	r0.xy = asint(asfloat(r0.xx) * gWorldViewProj[0].yw + asfloat(r0.yw));
	r0.xy = asint(asfloat(r0.zz) * gWorldViewProj[2].yw + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.xy) + gWorldViewProj[3].yw);
	r0.x = asint(asfloat(r0.x) / asfloat(r0.y));
	r0.y = asint(asfloat(r0.x) + -1);
	r0.z = (0.899999976 < abs(gViewInverse[2].z)) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	r0.x = asint(asfloat(r0.z) * asfloat(r0.y) + -(asfloat(r0.x)));
	r0.y = asint(-(asfloat(r0.x)) + -1);
	r0.z = (0.00499999989 < abs(gViewInverse[0].z)) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	o.texcoord3.w = asfloat(r0.z) * asfloat(r0.y) + asfloat(r0.x);
	o.texcoord3.xyz = gViewInverse[3].xyz;
	o.texcoord4.xz = i.color.xz * float2(8, 16) + float2(-4, -8);
	o.texcoord4.w = i.normal.z;

	return o;
}
