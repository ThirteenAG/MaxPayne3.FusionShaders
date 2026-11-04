cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
};

SamplerState DiffuseSamplerPoint : register(s0);
Texture2D DiffuseSamplerPoint_tex : register(t0);

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
	r0 = DiffuseSamplerPoint_tex.Sample(DiffuseSamplerPoint, i.texcoord.xy);
	r0 = r0 * i.color;
	r1 = (g_AlphaRef >= r0.w) ? -1 : 0;
	if (r1.x != 0) discard;
	o = r0;

	return o;
}
