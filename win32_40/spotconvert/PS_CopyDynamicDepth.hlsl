SamplerState ConvertSampler : register(s0);
Texture2D ConvertSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float sv_depth : SV_Depth;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	r0 = ConvertSampler_tex.Sample(ConvertSampler, i.texcoord.xy);
	o.sv_target = r0.y;
	o.sv_depth = r0.y;

	return o;
}
