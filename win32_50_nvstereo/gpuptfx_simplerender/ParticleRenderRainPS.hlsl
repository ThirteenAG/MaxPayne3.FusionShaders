SamplerState DiffuseSampler : register(s0);
SamplerState DiffuseSamplerPhase2 : register(s1);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D DiffuseSamplerPhase2_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	r0.x = (i.texcoord.x >= 0) ? -1 : 0;
	r0.yz = asint(i.texcoord.xy + float2(10, 0));
	r1 = DiffuseSamplerPhase2_tex.Sample(DiffuseSamplerPhase2, asfloat(r0.yz));
	if (r0.x != 0) {
		r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
		o = asfloat(r0) * i.color;
		return o;
	} else {
		o = r1 * i.color;
		return o;
	}

	return o;
}
