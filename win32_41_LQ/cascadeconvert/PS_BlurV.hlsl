cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
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
	float2 r1;
	r0.y = -(gShadowParam18192021.y);
	r0.xz = float2(0, 0);
	r0.xy = r0.xy + i.texcoord.xy;
	r0.xy = ConvertSampler_tex.Sample(ConvertSampler, r0.xy).xy;
	r1 = ConvertSampler_tex.Sample(ConvertSampler, i.texcoord.xy).xy;
	r0.xy = r0.xy + r1.xy;
	r0.w = gShadowParam18192021.y;
	r0.zw = r0.zw + i.texcoord.xy;
	r0.zw = ConvertSampler_tex.Sample(ConvertSampler, r0.zw).xy;
	r0.xy = r0.zw + r0.xy;
	o.xy = r0.xy * float2(0.333333343, 0.333333343);
	o.zw = float2(1, 1);

	return o;
}
