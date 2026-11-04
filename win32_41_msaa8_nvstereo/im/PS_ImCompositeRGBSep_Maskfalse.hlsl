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
	float MaskAlphaReverse : packoffset(c215);
};

SamplerState AlphaMaskMapSampler : register(s3);
Texture2D AlphaMaskMapSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int3 r1;
	r0.xyz = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r1 = (float3(0, 0, 0) < asfloat(r0.xyz)) ? -1 : 0;
	r0.xyz = asint(asfloat(r0.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r0.xyz = r0.xyz & r1.xyz;
	r0.w = (MaskAlphaReverse == 0) ? -1 : 0;
	r1.x = asint(AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord1.xy).w);
	r1.y = asint(-(asfloat(r1.x)) + 1);
	r1.xy = asint(asfloat(r1.xy) * i.color.ww);
	r0.w = (r0.w != 0) ? r1.x : r1.y;
	r1.x = (0 < asfloat(r0.w)) ? -1 : 0;
	o.w = asfloat(r0.w);
	o.xyz = asfloat(r0.xyz & r1.xxx);

	return o;
}
