SamplerState MLAALinearSampler : register(s1);
Texture2D MLAALinearSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = MLAALinearSampler_tex.Sample(MLAALinearSampler, i.texcoord.xy);

	return o;
}
