cbuffer _Globals : register(b1)
{
	float4 TexelSize : packoffset(c38);
};

SamplerState BaseSampler : register(s3);
Texture2D BaseSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = TexelSize.xxyx * float4(-1, -1, 1, -1) + i.texcoord.xyxy;
	r1 = BaseSampler_tex.Sample(BaseSampler, r0.xy);
	r0 = BaseSampler_tex.Sample(BaseSampler, r0.zw);
	r0 = r0 + r1;
	r1 = TexelSize.xyyy * float4(-1, 1, 1, 1) + i.texcoord.xyxy;
	r2 = BaseSampler_tex.Sample(BaseSampler, r1.xy);
	r1 = BaseSampler_tex.Sample(BaseSampler, r1.zw);
	r0 = r0 + r2;
	r0 = r1 + r0;
	o = r0 * float4(0.25, 0.25, 0.25, 0.25);

	return o;
}
