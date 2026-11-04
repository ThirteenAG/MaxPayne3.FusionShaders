cbuffer SmartBlit : register(b4)
{
	float4 clearcol : packoffset(c0);
};

SamplerState SmartBlitSampler : register(s1);
Texture2D SmartBlitSampler_tex : register(t1);

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
	r0 = SmartBlitSampler_tex.Sample(SmartBlitSampler, i.texcoord.xy);
	o.sv_target = r0;
	r0 = saturate(r0);
	o.sv_depth = dot(r0, clearcol);

	return o;
}
