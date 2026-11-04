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

SamplerState RenderMapPointSampler : register(s1);
SamplerState AlphaMaskMapSampler : register(s3);
SamplerState InterlaceMapSampler : register(s4);
Texture2D RenderMapPointSampler_tex : register(t1);
Texture2D AlphaMaskMapSampler_tex : register(t3);
Texture2D InterlaceMapSampler_tex : register(t4);
Texture2D<uint4> StencilCopyTexture : register(t6);

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
	float4 r2;
	int3 r3;
	r0.x = asint(AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord1.xy).w);
	r0.y = (0 < InterlaceTotalNum) ? -1 : 0;
	if (r0.y != 0) {
		r0.y = asint(1 / InterlaceTotalNum);
		r0.z = asint(asfloat(r0.y) * InterlaceIndex);
		r1.x = asint(asfloat(r0.y) * 0.5 + asfloat(r0.z));
		r1.y = asint(i.texcoord.y);
		r0.y = asint(InterlaceMapSampler_tex.Sample(InterlaceMapSampler, asfloat(r1.xy)).w);
	} else {
		r0.y = 1065353216;
	}
	float2 dimensions0;
	StencilCopyTexture.GetDimensions(dimensions0.x, dimensions0.y);
	r0.zw = asint(dimensions0.xy);
	r0.zw = asint(asfloat(r0.zw) * i.texcoord.xy);
	r1.xy = (int2)asfloat(r0.zw);
	r1.zw = int2(0, 0);
	r0.z = StencilCopyTexture.Load(r1.xyz).y;
	r0.zw = r0.zz & int2(7, 128);
	r0.zw = (r0.zw == int2(1, 128)) ? -1 : 0;
	r1.x = r0.z & 1065353216;
	r1.y = (r0.w == 0) ? -1 : 0;
	r1.y = r0.z & r1.y;
	r1.y = r1.y & 1065353216;
	r1.zw = (abs(StencilTech) == float2(1, 2)) ? -1 : 0;
	r0.z = r0.w & r0.z;
	r0.z = r0.z & 1065353216;
	r0.z = (r1.w != 0) ? r0.z : r1.x;
	r0.z = (r1.z != 0) ? r1.y : r0.z;
	r0.w = (StencilTech < 0) ? -1 : 0;
	r1.x = asint(-(asfloat(r0.z)) + 1);
	r1.x = asint(asfloat(r1.x) * i.color.w);
	r0.z = asint(asfloat(r0.z) * i.color.w);
	r0.z = (r0.w != 0) ? r1.x : r0.z;
	r0.w = (MaskAlphaReverse == 0) ? -1 : 0;
	r1.x = asint(asfloat(r0.x) * asfloat(r0.z));
	r1.x = asint(asfloat(r0.y) * asfloat(r1.x));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.z));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = (r0.w != 0) ? r1.x : r0.x;
	r0.yzw = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy).xyz);
	r1.x = (0 < asfloat(r0.x)) ? -1 : 0;
	r1.yzw = asint(-(asfloat(r0.yzw)) + float3(1, 1, 1));
	r2.xyz = i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
	r1.yzw = asint(asfloat(r1.yzw) * r2.xyz);
	r2.w = asfloat(r0.y) * 0.0078125;
	r3 = (float3(0, 0, 0) < r2.xyz) ? -1 : 0;
	r1.yzw = asint(asfloat(r1.yzw) * float3(0.0078125, 0.0078125, 0.0078125));
	r2.xyz = r2.xyz * r2.www;
	r1.yzw = (r3.xyz != 0) ? r1.yzw : asint(r2.xyz);
	r0.yzw = r0.yzw & r1.xxx;
	r1.xyz = r1.yzw & r1.xxx;
	o.xyz = asfloat(r0.yzw) + asfloat(r1.xyz);
	o.w = asfloat(r0.x);

	return o;
}
