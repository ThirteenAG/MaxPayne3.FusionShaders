SamplerState ConvertSampler : register(s0);
Texture2D ConvertSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float r0;
	r0 = ConvertSampler_tex.Sample(ConvertSampler, i.texcoord.xy).x;
	o = r0.x;

	return o;
}
