SamplerState DiffuseTexSampler : register(s0);
SamplerState DiffuseSampler : register(s1);
Texture2D DiffuseTexSampler_tex : register(t0);
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

	int3 r0;
	float4 r1;
	r0.x = (i.texcoord.x >= 0) ? -1 : 0;
	r0.yz = asint(i.texcoord.xy + float2(10, 0));
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, asfloat(r0.yz));
	if (r0.x != 0) {
		r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	}
	o = r1 * i.color;

	return o;
}
