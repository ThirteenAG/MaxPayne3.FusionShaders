SamplerState TextureSampler : register(s0);
Texture2D TextureSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = TextureSampler_tex.Sample(TextureSampler, i.texcoord.xy);

	return o;
}
