cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
};

SamplerState DiffuseSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	o = r0 * globalScalars.yyyx;

	return o;
}
