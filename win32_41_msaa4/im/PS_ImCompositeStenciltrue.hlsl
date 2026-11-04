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
	int4 r2;
	float3 r3;
	float3 dimensions0;
	RenderPointMapMSAA.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r1.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 0).xyz);
	r2.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 1).xyz);
	r1 = asint(asfloat(r1.xyzx) + asfloat(r2.xyzx));
	r2.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 2).xyz);
	r0.xyz = asint(RenderPointMapMSAA.Load(r0.xy, 3).xyz);
	r1 = asint(asfloat(r1) + asfloat(r2.xyzx));
	r0 = asint(asfloat(r0.xyzx) + asfloat(r1));
	r1.xyz = asint(-(asfloat(r0.xyz)) * float3(0.25, 0.25, 0.25) + float3(1, 1, 1));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, 0.25, 0.001953125));
	r2.xyz = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = asfloat(r0.www) * asfloat(r2.xyz);
	r2.xyz = (float3(0, 0, 0) < asfloat(r2.xyz)) ? -1 : 0;
	r1.xyz = (r2.xyz != 0) ? r1.xyz : asint(r3.xyz);
	float3 dimensions1;
	StencilCopyTexture.GetDimensions(dimensions1.x, dimensions1.y, dimensions1.z);
	r2.xy = asint(dimensions1.xy);
	r2.xy = asint(asfloat(r2.xy) * i.texcoord.xy);
	r2.xy = (int2)asfloat(r2.xy);
	r2.zw = int2(0, 0);
	r0.w = StencilCopyTexture.Load(r2.xy, 0).y;
	r2.xy = r0.ww & int2(7, 128);
	r2.xy = (r2.xy == int2(1, 128)) ? -1 : 0;
	r0.w = (r2.y == 0) ? -1 : 0;
	r0.w = r0.w & r2.x;
	r0.w = r0.w & 1065353216;
	r1.w = r2.y & r2.x;
	r2.x = r2.x & 1065353216;
	r1.w = r1.w & 1065353216;
	r2.yz = (abs(StencilTech) == float2(1, 2)) ? -1 : 0;
	r1.w = (r2.z != 0) ? r1.w : r2.x;
	r0.w = (r2.y != 0) ? r0.w : r1.w;
	r1.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(asfloat(r0.w) * i.color.w);
	r1.w = asint(asfloat(r1.w) * i.color.w);
	r2.x = (StencilTech < 0) ? -1 : 0;
	r0.w = (r2.x != 0) ? r1.w : r0.w;
	r1.w = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.w = r0.w & r1.w;
	r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
	o.w = asfloat(r0.w);
	r1.xyz = r1.xyz & r1.www;
	r0.xyz = r0.xyz & r1.www;
	o.xyz = asfloat(r1.xyz) + asfloat(r0.xyz);

	return o;
}
