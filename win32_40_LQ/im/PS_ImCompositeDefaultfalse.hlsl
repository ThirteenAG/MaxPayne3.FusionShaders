cbuffer _Globals : register(b4)
{
	float4 TransColor : packoffset(c206);
	float4 TransPos : packoffset(c207);
	float4 TransTex0 : packoffset(c208);
	float4 TexelSize : packoffset(c209);
	float GammaCorrection : packoffset(c210);
	float g_fBilateralCoefficient : packoffset(c211);
	float4 refMipBlurParams : packoffset(c212);
	float4 SubViewportParams : packoffset(c213);
	float MaskAlphaReverse : packoffset(c214);
};

SamplerState RenderMapPointSampler : register(s1);
Texture2D RenderMapPointSampler_tex : register(t1);

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
	int4 r1;
	float3 r2;
	int3 r3;
	r0 = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy));
	r1.xyz = asint(-(asfloat(r0.xyz)) + float3(1, 1, 1));
	r2 = i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
	r1.xyz = asint(asfloat(r1.xyz) * r2.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = (float3(0, 0, 0) < r2.xyz) ? -1 : 0;
	r0.w = asint(asfloat(r0.x) * 0.0078125);
	r2 = r2.xyz * asfloat(r0.www);
	r1.xyz = (r3.xyz != 0) ? r1.xyz : asint(r2.xyz);
	r0.w = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.w = r0.w & asint(i.color.w);
	r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
	o.w = asfloat(r0.w);
	r1.xyz = r1.xyz & r1.www;
	r0.xyz = r0.xyz & r1.www;
	o.xyz = asfloat(r1.xyz) + asfloat(r0.xyz);

	return o;
}
