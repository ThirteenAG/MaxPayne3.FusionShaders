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
Texture2DMS<float4> RenderPointMapMSAA : register(t5);

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
	float3 dimensions0;
	RenderPointMapMSAA.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r1.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 0).xyz);
	r0.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 1).xyz);
	r0 = asint(asfloat(r0.xyzx) + asfloat(r1.xyzx));
	r1.xyz = asint(-(asfloat(r0.xyz)) * float3(0.5, 0.5, 0.5) + float3(1, 1, 1));
	r0 = asint(asfloat(r0) * float4(0.5, 0.5, 0.5, 0.00390625));
	r2 = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = asfloat(r0.www) * asfloat(r2.xyz);
	r2 = (float3(0, 0, 0) < asfloat(r2.xyz)) ? -1 : 0;
	r1.xyz = (r2.xyz != 0) ? r1.xyz : asint(r3.xyz);
	r0.w = (MaskAlphaReverse == 0) ? -1 : 0;
	r1.w = asint(AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord1.xy).w);
	r2.x = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(asfloat(r1.w) * i.color.w);
	r2.x = asint(asfloat(r2.x) * i.color.w);
	r0.w = (r0.w != 0) ? r1.w : r2.x;
	r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
	o.w = asfloat(r0.w);
	r1.xyz = r1.xyz & r1.www;
	r0.xyz = r0.xyz & r1.www;
	o.xyz = asfloat(r1.xyz) + asfloat(r0.xyz);

	return o;
}
