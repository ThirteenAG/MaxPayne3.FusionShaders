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
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.sv_position = r0;
	o.texcoord3.w = r0.z;
	o.texcoord = i.position.xyz + -(gViewInverse[3].xyz);
	o.texcoord1 = i.normal.xyz;
	o.texcoord2 = i.texcoord.xy;
	r0.x = i.position.y * gWorldView[1].z;
	r0.x = i.position.x * gWorldView[0].z + r0.x;
	r0.x = i.position.z * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord3.z = -(r0.x);
	o.texcoord3.xy = i.texcoord2.xy;
	o.texcoord4 = i.texcoord1;

	return o;
}
