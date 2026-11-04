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
	float3 normal : NORMAL;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.sv_position = r0;
	o.texcoord.w = r0.w;
	r0.xyz = i.position.xyz + -(gViewInverse[3].xyz);
	o.texcoord.xyz = -(r0.xyz);
	r0.xy = i.color.xx * float2(-2, 2) + float2(1, -1);
	r0.xy = r0.xy * i.texcoord.yx;
	r0.z = dot(i.texcoord.xy, i.texcoord.xy);
	r0.z = sqrt(r0.z);
	r0.z = 1 / r0.z;
	o.texcoord1.zw = r0.zz * r0.xy;
	o.texcoord1.xy = r0.zz * i.texcoord.xy;
	o.texcoord2.w = r0.z;
	o.texcoord2.xyz = i.normal.xyz;
	r0.yz = i.texcoord.xy;
	r0.w = 0;
	r0.xyz = r0.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r1.x = rsqrt(r0.w);
	r1.yzw = r0.xyz * r1.xxx;
	o.texcoord6.xyz = r1.yzw;
	o.texcoord6.w = i.color.w;
	r0.xz = r1.zy * float2(1, 0);
	r0.y = 0;
	r0.xyz = -(r1.xyz) * float3(0, 1, 0) + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord7 = r0.www * r0.xyz;

	return o;
}
