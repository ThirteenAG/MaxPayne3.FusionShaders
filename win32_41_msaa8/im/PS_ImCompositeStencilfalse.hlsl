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
};

SamplerState RenderMapPointSampler : register(s1);
Texture2D RenderMapPointSampler_tex : register(t1);
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
	float3 r2;
	int3 r3;
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
	r0.y = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.x = r0.x & r0.y;
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	o.w = asfloat(r0.x);
	r0.xzw = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, i.texcoord.xy).xyz);
	r1.xyz = asint(-(asfloat(r0.xzw)) + float3(1, 1, 1));
	r2 = i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
	r1.xyz = asint(asfloat(r1.xyz) * r2.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = (float3(0, 0, 0) < r2.xyz) ? -1 : 0;
	r1.w = asint(asfloat(r0.x) * 0.0078125);
	r0.xzw = r0.xzw & r0.yyy;
	r2 = r2.xyz * asfloat(r1.www);
	r1.xyz = (r3.xyz != 0) ? r1.xyz : asint(r2.xyz);
	r1.xyz = r0.yyy & r1.xyz;
	o.xyz = asfloat(r0.xzw) + asfloat(r1.xyz);

	return o;
}
