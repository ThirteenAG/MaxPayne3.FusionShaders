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

	float r0;
	r0 = ConvertSampler_tex.Sample(ConvertSampler, i.texcoord.xy).y;
	o.sv_target = r0.x;
	o.sv_depth = r0.x;

	return o;
}
