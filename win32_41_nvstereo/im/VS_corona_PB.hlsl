cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	float3 r2;
	float3 r3;
	r0.xyz = i.normal.xyz + -(gViewInverse[3].xyz);
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = r0.x + -512;
	r0.x = saturate(r0.x * 0.5);
	r0.x = r0.x * 8 + 504;
	r1.x = asint(r0.x + gViewInverse[3].z);
	r1.yz = asint(gViewInverse[3].xy);
	r0.yzw = -(asfloat(r1.xyz)) + i.normal.zxy;
	r1.xyz = asint(r0.yzw * float3(0, 1, 0));
	r1.xyz = asint(r0.wyz * float3(1, 0, 0) + -(asfloat(r1.xyz)));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = (-1 < r0.y) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r2 = r0.yzw * asfloat(r1.yzx);
	r2 = r0.wyz * asfloat(r1.zxy) + -(r2.xyz);
	r0.y = r0.y + 1;
	r2 = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r2 = r0.zzz * r2.xyz;
	r2 = asfloat(r1.www) * r2.xyz;
	r3 = i.position.xyz + -(i.normal.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * r3.xxx + i.normal.xyz);
	r1.xyz = asint(r2.xyz * r3.yyy + asfloat(r1.xyz));
	r0.z = dot(r3.xyz, r3.xyz);
	r0.z = sqrt(r0.z);
	r0.z = r0.z * 0.353553385;
	r0.y = saturate(r0.y / r0.z);
	r2 = asfloat(r1.yyy) * gWorldView[1].xyz;
	r1.xyw = asint(asfloat(r1.xxx) * gWorldView[0].xyz + r2.xyz);
	r1.xyz = asint(asfloat(r1.zzz) * gWorldView[2].xyz + asfloat(r1.xyw));
	r1.xyz = asint(asfloat(r1.xyz) + gWorldView[3].xyz);
	r1.w = asint(r0.x + asfloat(r1.z));
	r0.x = dot(asfloat(r1.xyw), asfloat(r1.xyw));
	r0.x = sqrt(r0.x);
	r0.z = asfloat(r1.w) / r0.x;
	r0.z = -(r0.z) + 1;
	r0.z = r0.z * r0.x;
	r0.x = r0.x + 1;
	r0.x = 1 / r0.x;
	o.sv_position.z = -(r0.x) + 1;
	r0.x = 1 / r0.z;
	o.sv_position.xy = r0.xx * asfloat(r1.xy);
	o.sv_position.w = 1;
	o.texcoord.x = i.texcoord.x;
	o.texcoord.y = i.color.w;
	r0.xzw = i.color.xyz * i.texcoord.yyy;
	o.texcoord1.xyz = r0.yyy * r0.xzw;
	o.texcoord1.w = 1;

	return o;
}
