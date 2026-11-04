cbuffer _Globals : register(b4)
{
	float4 TexelSize : packoffset(c205);
};

SamplerState ConvertSampler : register(s0);
Texture2D ConvertSampler_tex : register(t0);

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
	r0.xy = i.texcoord.xy + -(TexelSize.xy);
	r0.xy = ConvertSampler_tex.Sample(ConvertSampler, r0.xy).xy;
	r0.zw = ConvertSampler_tex.Sample(ConvertSampler, i.texcoord.xy).xy;
	r0.xy = r0.xy + r0.zw;
	r1 = TexelSize.xyxy * float4(-1, 1, 1, -1) + i.texcoord.xyxy;
	r0.zw = ConvertSampler_tex.Sample(ConvertSampler, r1.xy).xy;
	r1.xy = ConvertSampler_tex.Sample(ConvertSampler, r1.zw).xy;
	r0.xy = r0.zw + r0.xy;
	r0.zw = i.texcoord.xy + TexelSize.xy;
	r0.zw = ConvertSampler_tex.Sample(ConvertSampler, r0.zw).xy;
	r0.xy = r0.zw + r0.xy;
	r0.xy = r1.xy + r0.xy;
	o.xy = r0.xy * float2(0.200000003, 0.200000003);
	o.zw = float2(0, 1);

	return o;
}
