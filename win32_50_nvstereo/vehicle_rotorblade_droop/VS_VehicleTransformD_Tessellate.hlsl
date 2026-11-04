cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer Droop : register(b4)
{
	float3 droopParams : packoffset(c0);
	float2 gravityDroop : packoffset(c1);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	r0.xy = i.position.xy;
	r0.w = dot(i.position.xy, i.position.xy);
	r1.x = r0.w * droopParams.x;
	r0.w = r0.w * gravityDroop.x;
	r1.x = r1.x * gravityDroop.x;
	r0.z = -(r1.x) * 0.00999999978 + i.position.z;
	r1 = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.x = dot(r1.xyz, r1.xyz);
	r0.x = rsqrt(r0.x);
	r1 = r0.xxx * r1.xyz;
	r0.x = dot(r1.xzy, float3(0.707106769, 0.707106769, 0.00000707099707));
	r0.x = r0.x + gravityDroop.y;
	r0.x = r0.x * droopParams.z;
	r0.x = sin(r0.x);
	r0.y = droopParams.y * 0.00999999978;
	r0.y = r0.y * r0.w;
	r0.x = -(r0.y) * r0.x + r0.z;
	o.texcoord8.z = r0.x;
	o.texcoord8.xy = i.position.xy;
	o.texcoord8.w = 1;
	o.texcoord = i.texcoord.xy;
	r0.y = i.position.y * gWorldViewProj[1].w;
	r0.y = i.position.x * gWorldViewProj[0].w + r0.y;
	r0.y = r0.x * gWorldViewProj[2].w + r0.y;
	o.texcoord1.w = r0.y + gWorldViewProj[3].w;
	r0.yzw = i.normal.yyy * gWorld[1].xyz;
	r0.yzw = i.normal.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.normal.zzz * gWorld[2].xyz + r0.yzw;
	r0.yzw = r0.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	o.texcoord1.xyz = r0.yzw * r1.xxx;
	o.texcoord2.xyz = i.color.xyz;
	o.texcoord2.w = 1;
	r0.yzw = i.tangent.yyy * gWorld[1].xyz;
	r0.yzw = i.tangent.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.tangent.zzz * gWorld[2].xyz + r0.yzw;
	r0.yzw = r0.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	o.texcoord4 = r0.yzw * r1.xxx;
	o.texcoord5 = i.tangent.w;
	r0.yzw = i.position.yyy * gWorld[1].xyz;
	r0.yzw = i.position.xxx * gWorld[0].xyz + r0.yzw;
	r0.xyz = r0.xxx * gWorld[2].xyz + r0.yzw;
	o.texcoord6.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord6.w = 1;
	o.texcoord9 = i.normal.xyz;

	return o;
}
