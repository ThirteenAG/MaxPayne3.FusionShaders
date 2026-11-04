cbuffer _Globals : register(b1)
{
	float4 TexelSize : packoffset(c38);
};

SamplerState BaseSampler : register(s3);
Texture2D BaseSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float2 r0;
	r0 = TexelSize.xx * float2(-0.5, -0.5) + i.texcoord.xy;
	o = BaseSampler_tex.Sample(BaseSampler, r0.xy);

	return o;
}
