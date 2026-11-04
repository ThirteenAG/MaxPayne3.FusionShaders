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
};

SamplerState AlphaMaskMapSampler : register(s3);
Texture2D AlphaMaskMapSampler_tex : register(t3);
Texture2DMS<float4> RenderPointMapMSAA : register(t5);
Texture2DMS<uint4> StencilCopyTexture : register(t6);

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
	StencilCopyTexture.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = StencilCopyTexture.Load(r0.xy, 0).y;
	r0.xy = r0.xx & int2(7, 128);
	r0.xy = (r0.xy == int2(1, 128)) ? -1 : 0;
	r0.z = (r0.y == 0) ? -1 : 0;
	r0.yz = r0.yz & r0.xx;
	r0.xyz = r0.xyz & int3(1065353216, 1065353216, 1065353216);
	r1.xy = (abs(StencilTech) == float2(1, 2)) ? -1 : 0;
	r0.x = (r1.y != 0) ? r0.y : r0.x;
	r0.x = (r1.x != 0) ? r0.z : r0.x;
	r0.y = asint(-(asfloat(r0.x)) + 1);
	r0.xy = asint(asfloat(r0.xy) * i.color.ww);
	r0.z = (StencilTech < 0) ? -1 : 0;
	r0.x = (r0.z != 0) ? r0.y : r0.x;
	r0.y = asint(AlphaMaskMapSampler_tex.Sample(AlphaMaskMapSampler, i.texcoord1.xy).w);
	r0.z = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = asint(asfloat(r0.z) * asfloat(r0.x));
	r0.z = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.x = (r0.z != 0) ? r0.y : r0.x;
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	o.w = asfloat(r0.x);
	float3 dimensions1;
	RenderPointMapMSAA.GetDimensions(dimensions1.x, dimensions1.y, dimensions1.z);
	r0.xz = asint(dimensions1.xy);
	r0.xz = asint(asfloat(r0.xz) * i.texcoord.xy);
	r1.xy = (int2)asfloat(r0.xz);
	r1.zw = int2(0, 0);
	r0.xzw = asint(RenderPointMapMSAA.Load(r1.xy, 0).xyz);
	r1.xyz = asint(RenderPointMapMSAA.Load(r1.xy, 1).xyz);
	r1 = asint(asfloat(r0.xzwx) + asfloat(r1.xyzx));
	r0.xzw = asint(-(asfloat(r1.xyz)) * float3(0.5, 0.5, 0.5) + float3(1, 1, 1));
	r1 = asint(asfloat(r1) * float4(0.5, 0.5, 0.5, 0.00390625));
	r2 = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r0.xzw = asint(asfloat(r0.xzw) * asfloat(r2.xyz));
	r0.xzw = asint(asfloat(r0.xzw) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = asfloat(r1.www) * asfloat(r2.xyz);
	r1.xyz = r0.yyy & r1.xyz;
	r2 = (float3(0, 0, 0) < asfloat(r2.xyz)) ? -1 : 0;
	r0.xzw = (r2.xyz != 0) ? r0.xzw : asint(r3.xyz);
	r0.xyz = r0.xzw & r0.yyy;
	o.xyz = asfloat(r0.xyz) + asfloat(r1.xyz);

	return o;
}
