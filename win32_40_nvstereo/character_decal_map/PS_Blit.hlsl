SamplerState SeamTextureSampler : register(s2);
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
	r0 = SeamTextureSampler_tex.Sample(SeamTextureSampler, i.texcoord.xy);
	o.xyw = r0.zzz;
	o.z = 0.5;

	return o;
}
