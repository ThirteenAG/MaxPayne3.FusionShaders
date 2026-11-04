SamplerState RefBlurMapSampler : register(s2);
Texture2D RefBlurMapSampler_tex : register(t2);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float3 r0;
	r0 = RefBlurMapSampler_tex.Sample(RefBlurMapSampler, i.texcoord.xy).xyz;
	o.xyz = r0.xyz;
	o.w = 1;

	return o;
}
