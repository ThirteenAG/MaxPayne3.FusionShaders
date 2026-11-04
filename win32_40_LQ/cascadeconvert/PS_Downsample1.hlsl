cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
};

cbuffer CascadeShadowLocals : register(b4)
{
	float4 clearcol : packoffset(c0);
	float4 DofProj : packoffset(c1);
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
	float4 r2;
	r0.z = gShadowParam18192021.x * 0.5 + i.texcoord.x;
	r0.xyw = -(gShadowParam18192021.xyy) * float3(0.5, 0.5, 0.5) + i.texcoord.xyy;
	r1 = ConvertSampler_tex.Sample(ConvertSampler, r0.zw).yxzw;
	r0 = ConvertSampler_tex.Sample(ConvertSampler, r0.xy);
	r1.x = r0.x;
	r0.x = -(gShadowParam18192021.x) * 0.5 + i.texcoord.x;
	r0.yzw = gShadowParam18192021.yxy * float3(0.5, 0.5, 0.5) + i.texcoord.yxy;
	r2 = ConvertSampler_tex.Sample(ConvertSampler, r0.xy);
	r0 = ConvertSampler_tex.Sample(ConvertSampler, r0.zw);
	r1.w = r0.x;
	r1.z = r2.x;
	r0.x = -(DofProj.x) + DofProj.y;
	r0 = r1 * r0.x + DofProj.x;
	r0 = r0 + DofProj.z;
	r1.x = dot(r0, float4(1, 1, 1, 1));
	r1.y = dot(r0, r0);
	r1.zw = float2(0, 4);
	o = r1 * float4(0.25, 0.25, 0.25, 0.25);

	return o;
}
