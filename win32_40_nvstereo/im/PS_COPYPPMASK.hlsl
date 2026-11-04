SamplerState RenderMapPointSampler : register(s1);
SamplerState AlphaMaskMapSampler : register(s3);
Texture2D RenderMapPointSampler_tex : register(t1);
Texture2D AlphaMaskMapSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0 = RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy);
	o.xzw = r0.xzw;
	r0 = AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord.xy);
	o.y = r0.w;

	return o;
}
