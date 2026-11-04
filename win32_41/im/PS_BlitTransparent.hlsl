SamplerState TransparentSrcMapSampler : register(s3);
Texture2D TransparentSrcMapSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, i.texcoord.xy);

	return o;
}
