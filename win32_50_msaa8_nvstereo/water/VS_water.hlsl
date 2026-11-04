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

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

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
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	r0.x = asint(dot(i.normal.xy, i.normal.xy));
	r0.x = asint(asfloat(r0.x) + 0.0000999999975);
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.x) + -0.200000003);
	r0.y = asint(saturate(asfloat(r0.y) * 5));
	r0.zw = asint(i.color.xz + float2(-0.5, -0.5));
	r0.z = asint(asfloat(r0.z) * 8);
	r1.x = asint(asfloat(r0.z) * asfloat(r0.z));
	r1.y = asint(i.position.z + -(waterRenderSimParam.z));
	r1.y = asint(asfloat(r1.y) * waterRenderSimParam.x + waterRenderSimParam.z);
	r1.z = asint(asfloat(r1.y) * asfloat(r1.y) + asfloat(r1.x));
	r1.z = asint(asfloat(r1.z) + 0.0000999999975);
	r1.w = asint(sqrt(asfloat(r1.z)));
	r1.z = asint(asfloat(r1.z) / asfloat(r1.w));
	r1.w = asint(asfloat(r1.z) * 0.899999976);
	r0.z = (asfloat(r1.w) < asfloat(r0.z)) ? -1 : 0;
	r0.z = r0.z & 1065353216;
	r0.y = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.z = asint(asfloat(r1.y) / asfloat(r1.z));
	r1.x = asint(asfloat(r1.z) * asfloat(r1.z) + -(asfloat(r1.x)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r0.x = asint(asfloat(r1.x) / asfloat(r0.x));
	r0.x = asint(asfloat(r0.z) * asfloat(r0.x));
	r1.x = asint(saturate(asfloat(r0.z) * 0.5 + 0.5));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(asfloat(r0.z) * 6);
	r0.y = asint(asfloat(r0.y) * asfloat(r1.x));
	r0.x = asint(asfloat(r0.x) * 12 + asfloat(r0.z));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x) + -(asfloat(r0.z)));
	r0.xy = asint(asfloat(r0.xx) * i.normal.xy);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r0.z = asint(asfloat(r0.z) + 0.0000999999975);
	r0.w = asint(saturate(asfloat(r0.w) * 16 + -(asfloat(r1.y))));
	r0.w = asint(asfloat(r0.w) * 0.5);
	r0.z = asint(asfloat(r0.w) / asfloat(r0.z));
	r0.z = asint(min(asfloat(r0.z), 1));
	r0.xy = asint(asfloat(r0.xy) * asfloat(r0.zz) + i.position.xy);
	r2 = asfloat(r0.y) * gWorldViewProj[1];
	r0 = asint(asfloat(r0.x) * gWorldViewProj[0] + r2);
	r0 = asint(asfloat(r1.y) * gWorldViewProj[2] + asfloat(r0));
	r0 = asint(asfloat(r0.xywz) + gWorldViewProj[3].xywz);
	o.sv_position = asfloat(r0.xywz);
	r1.xz = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.25), 0).xy);
	r0.w = asint(asfloat(r0.z) + -(asfloat(r1.z)));
	o.texcoord.x = asfloat(r1.x) * asfloat(r0.w) + asfloat(r0.x);
	o.texcoord6.x = -(asfloat(r1.x)) * asfloat(r0.w) + asfloat(r0.x);
	o.texcoord.yz = asfloat(r0.yz);
	r1.xzw = asint(i.position.yyy * gWorld[1].xyz);
	r1.xzw = asint(i.position.xxx * gWorld[0].xyz + asfloat(r1.xzw));
	r1.xzw = asint(asfloat(r1.yyy) * gWorld[2].xyz + asfloat(r1.xzw));
	o.texcoord4.y = asfloat(r1.y);
	r1.xyz = asint(asfloat(r1.xzw) + gWorld[3].xyz);
	r0.x = asint(asfloat(r1.z) + -(waterRenderSimParam.z));
	r0.x = asint(asfloat(r0.x) + -2);
	o.texcoord.w = saturate(asfloat(r0.x) * 0.5);
	r0.x = asint(waterRenderSimParam.x * 0.100000001);
	r2.xyz = i.normal.xyz + float3(0, 0, -1);
	o.texcoord1.xyz = asfloat(r0.xxx) * r2.xyz + float3(0, 0, 1);
	o.texcoord1.w = 0;
	o.texcoord2.xyz = asfloat(r1.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + -(gViewInverse[3].xyz));
	o.texcoord5.xyz = asfloat(asint(-(asfloat(r1.xyz))));
	o.texcoord2.w = 0;
	r1.xy = asint(gViewInverse[2].xy + float2(0.00000999999975, 0.00000999999975));
	r1.z = 925353388;
	r0.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r1.xyz = asint(asfloat(r0.xxx) * asfloat(r1.xyz));
	r2.xy = gViewInverse[3].xy;
	r2.z = waterRenderSimParam.z;
	r2.xyz = r2.xyz + -(gWorld[3].xyz);
	r0.x = asint(gViewInverse[2].z + gViewInverse[2].z);
	r0.x = asint(max(abs(asfloat(r0.x)), 2000));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r0.xxx) + r2.xyz);
	r0.xw = asint(asfloat(r1.yy) * gWorldViewProj[1].yw);
	r0.xw = asint(asfloat(r1.xx) * gWorldViewProj[0].yw + asfloat(r0.xw));
	r0.xw = asint(asfloat(r1.zz) * gWorldViewProj[2].yw + asfloat(r0.xw));
	r0.xw = asint(asfloat(r0.xw) + gWorldViewProj[3].yw);
	r0.x = asint(asfloat(r0.x) / asfloat(r0.w));
	r0.w = asint(asfloat(r0.x) + -1);
	r1.x = (0.899999976 < abs(gViewInverse[2].z)) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r0.x = asint(asfloat(r1.x) * asfloat(r0.w) + -(asfloat(r0.x)));
	r0.w = asint(-(asfloat(r0.x)) + -1);
	r1.x = (0.00499999989 < abs(gViewInverse[0].z)) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	o.texcoord3.w = asfloat(r1.x) * asfloat(r0.w) + asfloat(r0.x);
	o.texcoord3.xyz = gViewInverse[3].xyz;
	o.texcoord4.xz = i.color.xz * float2(8, 16) + float2(-4, -8);
	o.texcoord4.w = i.normal.z;
	o.texcoord5.w = asfloat(r0.z);
	o.texcoord6.yz = asfloat(r0.yz);

	return o;
}
