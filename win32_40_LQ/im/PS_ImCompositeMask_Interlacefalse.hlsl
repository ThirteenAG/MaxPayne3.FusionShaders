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
SamplerState AlphaMaskMapSampler : register(s3);
SamplerState InterlaceMapSampler : register(s4);
Texture2D RenderMapPointSampler_tex : register(t1);
Texture2D AlphaMaskMapSampler_tex : register(t3);
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

	int4 r0;
	int4 r1;
	int3 r2;
	float3 r3;
	int3 r4;
	r0 = asint(AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord1.xy));
	r0.x = (0 < InterlaceTotalNum) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(1 / InterlaceTotalNum);
		r0.y = asint(asfloat(r0.x) * InterlaceIndex);
		r0.x = asint(asfloat(r0.x) * 0.5 + asfloat(r0.y));
		r0.y = asint(i.texcoord.y);
		r1 = asint(InterlaceMapSampler_tex.Sample(InterlaceMapSampler, asfloat(r0.xy)).wxyz);
	} else {
		r1.x = 1065353216;
	}
	r0.x = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.y = asint(asfloat(r0.w) * i.color.w);
	r0.z = asint(-(asfloat(r0.w)) + 1);
	r0.z = asint(asfloat(r0.z) * i.color.w);
	r0.yz = asint(asfloat(r1.xx) * asfloat(r0.yz));
	r0.x = (r0.x != 0) ? r0.y : r0.z;
	r1 = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy));
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	r2 = asint(-(asfloat(r1.xyz)) + float3(1, 1, 1));
	r3 = i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
	r2 = asint(asfloat(r2.xyz) * r3.xyz);
	r0.z = asint(asfloat(r1.x) * 0.0078125);
	r4 = (float3(0, 0, 0) < r3.xyz) ? -1 : 0;
	r2 = asint(asfloat(r2.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = r3.xyz * asfloat(r0.zzz);
	r2 = (r4.xyz != 0) ? r2.xyz : asint(r3.xyz);
	r1.xyz = r1.xyz & r0.yyy;
	r0.yzw = r0.yyy & r2.xyz;
	o.xyz = asfloat(r0.yzw) + asfloat(r1.xyz);
	o.w = asfloat(r0.x);

	return o;
}
