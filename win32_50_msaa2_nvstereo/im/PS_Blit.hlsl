cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
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
	int r1;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	r1 = (g_AlphaRef >= r0.w) ? -1 : 0;
	if (r1.x != 0) discard;
	o = r0;

	return o;
}
