cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
	float4 TransColor : packoffset(c207);
	float4 TransPos : packoffset(c208);
	float4 TransTex0 : packoffset(c209);
	float4 TexelSize : packoffset(c210);
	float GammaCorrection : packoffset(c211);
};

SamplerState DiffuseSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float3 r0;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy).xyz;
	r0 = r0.xyz * i.color.xyz;
	o.xyz = r0.xyz * GammaCorrection;
	o.w = i.color.w;

	return o;
}
