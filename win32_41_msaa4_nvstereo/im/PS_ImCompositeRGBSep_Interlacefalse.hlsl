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
	float InterlaceIndex : packoffset(c216);
	float StencilTech : packoffset(c217);
	float InterlaceTotalNum : packoffset(c218);
};

SamplerState InterlaceMapSampler : register(s4);
Texture2D InterlaceMapSampler_tex : register(t4);

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

	int2 r0;
	int3 r1;
	int3 r2;
	r0.x = (0 < InterlaceTotalNum) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(1 / InterlaceTotalNum);
		r0.y = asint(asfloat(r0.x) * InterlaceIndex);
		r0.x = asint(asfloat(r0.x) * 0.5 + asfloat(r0.y));
		r0.y = asint(i.texcoord.y);
		r0.x = asint(InterlaceMapSampler_tex.Sample(InterlaceMapSampler, asfloat(r0.xy)).w);
	} else {
		r0.x = 1065353216;
	}
	r0.y = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.x = asint(asfloat(r0.x) * i.color.w);
	r0.x = r0.x & r0.y;
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	r1 = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r2 = (float3(0, 0, 0) < asfloat(r1.xyz)) ? -1 : 0;
	r1 = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r1 = r1.xyz & r2.xyz;
	o.xyz = asfloat(r0.yyy & r1.xyz);
	o.w = asfloat(r0.x);

	return o;
}
