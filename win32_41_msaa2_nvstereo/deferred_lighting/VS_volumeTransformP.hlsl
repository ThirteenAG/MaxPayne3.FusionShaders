cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0 = position.y * gWorldViewProj[1];
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.sv_position = r0;
	o.texcoord.w = r0.w;
	r0.xyz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r0.xyz = r0.xyz + gViewInverse[3].xyz;
	r0.xyz = -(r0.xyz) + position.xyz;
	o.texcoord.xyz = -(r0.xyz);

	return o;
}
