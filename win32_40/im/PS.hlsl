SamplerState RenderMapPointSampler : register(s1);
Texture2D RenderMapPointSampler_tex : register(t1);

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
	o.xyz = r0.xyz * i.color.xyz;
	o.w = i.color.w;

	return o;
}
