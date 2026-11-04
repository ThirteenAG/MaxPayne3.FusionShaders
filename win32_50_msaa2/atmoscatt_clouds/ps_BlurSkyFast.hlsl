cbuffer TextureFetch : register(b1)
{
	float4 TexelSize : packoffset(c0);
};

SamplerState SkyMapSampler : register(s1);
Texture2D SkyMapSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = TexelSize.x * float4(-0.5, -0.5, 0.5, -0.5) + i.texcoord.xyxy;
	r1 = SkyMapSampler_tex.Sample(SkyMapSampler, r0.xy);
	r0 = SkyMapSampler_tex.Sample(SkyMapSampler, r0.zw);
	r0 = r0 + r1;
	r1 = TexelSize.x * float4(-0.5, 0.5, 0.5, 0.5) + i.texcoord.xyxy;
	r2 = SkyMapSampler_tex.Sample(SkyMapSampler, r1.xy);
	r1 = SkyMapSampler_tex.Sample(SkyMapSampler, r1.zw);
	r0 = r0 + r2;
	r0 = r1 + r0;
	o = r0 * float4(0.25, 0.25, 0.25, 0.25);

	return o;
}
