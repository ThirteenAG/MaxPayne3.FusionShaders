cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer InstanceWorld : register(b1)
{
	row_major float4x4 gWorldInstanceMatrix : packoffset(c0);
	row_major float4x4 gWorldInstanceInverseTranspose : packoffset(c4);
};

struct VS_IN
{
	float3 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = i.position.yyy * gWorldInstanceMatrix[1].xyz;
	r0.xyz = i.position.xxx * gWorldInstanceMatrix[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldInstanceMatrix[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldInstanceMatrix[3].xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord1 = r0.xyz;
	r0 = r1 + gWorldViewProj[3];
	o.sv_position = r0;
	o.texcoord2.w = r0.w;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;
	r0.xyz = i.normal.yyy * gWorldInstanceInverseTranspose[1].xyz;
	r0.xyz = i.normal.xxx * gWorldInstanceInverseTranspose[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorldInstanceInverseTranspose[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord2.xyz = r0.www * r0.xyz;

	return o;
}
