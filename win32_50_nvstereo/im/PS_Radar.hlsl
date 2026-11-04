cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
	float4 TransColor : packoffset(c207);
	float4 TransPos : packoffset(c208);
	float4 TransTex0 : packoffset(c209);
	float4 TexelSize : packoffset(c210);
	float GammaCorrection : packoffset(c211);
	float g_fBilateralCoefficient : packoffset(c212);
	float4 refMipBlurParams : packoffset(c213);
	float4 SubViewportParams : packoffset(c214);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
};

SamplerState DiffuseSampler : register(s1);
SamplerState AlphaMaskMapSampler : register(s3);
Texture2D DiffuseSampler_tex : register(t1);
Texture2D AlphaMaskMapSampler_tex : register(t3);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float2 r0;
	float4 r1;
	r0 = i.sv_position.xy + -(SubViewportParams.xy);
	r0 = r0.xy / SubViewportParams.zw;
	r0.x = AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, r0.xy).w;
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	r0.y = r1.w * globalScalars.x;
	o.xyz = r1.xyz * globalScalars.yyy;
	o.w = r0.x * r0.y;

	return o;
}
