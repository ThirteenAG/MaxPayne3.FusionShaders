SamplerState DiffuseSampler : register(s0);
SamplerState SeamTextureSampler : register(s2);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D SeamTextureSampler_tex : register(t2);

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
	float4 r1;
	r0 = SeamTextureSampler_tex.Sample(SeamTextureSampler, i.texcoord.xy).zxyw;
	r0.x = saturate(r0.x);
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	o.w = r0.x * r1.w;
	o.xyz = r1.xyz;

	return o;
}
