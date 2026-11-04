cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_IN
{
	float3 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.sv_position.z = min(r0.w, r0.z);
	o.sv_position.xyw = r0.xyw;
	o.texcoord1.yz = r0.yw;
	o.texcoord = i.texcoord;
	r0.yz = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.25), 0).xy;
	r0.z = -(r0.z) + r0.w;
	o.texcoord1.x = r0.y * r0.z + r0.x;
	o.texcoord1.w = 1;

	return o;
}
