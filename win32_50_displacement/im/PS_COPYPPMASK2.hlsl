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
	float InterlaceIndex : packoffset(c215);
	float StencilTech : packoffset(c216);
	float InterlaceTotalNum : packoffset(c217);
};

SamplerState RenderMapPointSampler : register(s1);
SamplerState InterlaceMapSampler : register(s4);
Texture2D RenderMapPointSampler_tex : register(t1);
Texture2D InterlaceMapSampler_tex : register(t4);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int2 r1;
	r0.yzw = RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy).xzw;
	r1.x = (0 < InterlaceTotalNum) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / InterlaceTotalNum);
		r1.y = asint(asfloat(r1.x) * InterlaceIndex);
		r1.x = asint(asfloat(r1.x) * 0.5 + asfloat(r1.y));
		r1.y = asint(i.texcoord.y);
		r0.x = InterlaceMapSampler_tex.Sample(InterlaceMapSampler, asfloat(r1.xy)).w;
	} else {
		r0.x = 1;
	}
	o = r0.yxzw;

	return o;
}
