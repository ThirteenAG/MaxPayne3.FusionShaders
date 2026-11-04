SamplerState RenderMapPointSamplerMSAA : register(s5);
Texture2D RenderMapPointSamplerMSAA_tex : register(t5);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = RenderMapPointSamplerMSAA_tex.Sample(RenderMapPointSamplerMSAA, i.texcoord.xy);

	return o;
}
