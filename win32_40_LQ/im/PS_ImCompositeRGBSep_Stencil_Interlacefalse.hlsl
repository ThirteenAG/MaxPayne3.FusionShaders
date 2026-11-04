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
	float2 RedOff : packoffset(c218);
	float2 GreenOff : packoffset(c219);
	float2 BlueOff : packoffset(c220);
};

SamplerState RenderMapPointSampler : register(s1);
SamplerState InterlaceMapSampler : register(s4);
Texture2D RenderMapPointSampler_tex : register(t1);
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
	int4 r2;
	int4 r3;
	int3 r4;
	r0.x = (0 < InterlaceTotalNum) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(1 / InterlaceTotalNum);
		r0.y = asint(asfloat(r0.x) * InterlaceIndex);
		r0.x = asint(asfloat(r0.x) * 0.5 + asfloat(r0.y));
		r0.y = asint(i.texcoord.y);
		r0 = asint(InterlaceMapSampler_tex.Sample(InterlaceMapSampler, asfloat(r0.xy)).wxyz);
	} else {
		r0.x = 1065353216;
	}
	float4 dimensions0 = 0;
	StencilCopyTexture.GetDimensions(0, dimensions0.x, dimensions0.y, dimensions0.w);
	r1 = asint(dimensions0);
	r0.yz = asint(asfloat(r1.xy) * i.texcoord.xy);
	r1.xy = (int2)asfloat(r0.yz);
	r1.zw = int2(0, 0);
	r1 = StencilCopyTexture.Load(r1.xyz);
	r0.yz = r1.yy & int2(7, 128);
	r0.yz = (r0.yz == int2(1, 128)) ? -1 : 0;
	r0.w = r0.y & 1065353216;
	r1.x = (r0.z == 0) ? -1 : 0;
	r1.x = r0.y & r1.x;
	r1.x = r1.x & 1065353216;
	r1.yz = (abs(StencilTech) == float2(1, 2)) ? -1 : 0;
	r0.y = r0.z & r0.y;
	r0.y = r0.y & 1065353216;
	r0.y = (r1.z != 0) ? r0.y : r0.w;
	r0.y = (r1.y != 0) ? r1.x : r0.y;
	r0.z = (StencilTech < 0) ? -1 : 0;
	r0.w = asint(-(asfloat(r0.y)) + 1);
	r0.yw = asint(asfloat(r0.yw) * i.color.ww);
	r0.y = (r0.z != 0) ? r0.w : r0.y;
	r0.z = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y));
	r0.x = r0.x & r0.z;
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	r0.zw = asint(i.texcoord.xy + RedOff.xy);
	r1 = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, asfloat(r0.zw)));
	r0.zw = asint(i.texcoord.xy + GreenOff.xy);
	r2 = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, asfloat(r0.zw)));
	r0.zw = asint(i.texcoord.xy + BlueOff.xy);
	r3 = asint(RenderMapPointSampler_tex.Sample(RenderMapPointSampler, asfloat(r0.zw)));
	if (r0.y != 0) {
		r3.x = r1.x;
		r3.y = r2.y;
	} else {
		r3.xyz = int3(0, 0, 0);
	}
	r1.xyz = asint(-(asfloat(r3.xyz)) + float3(1, 1, 1));
	r2.xyz = asint(i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xyz));
	r0.z = asint(asfloat(r3.x) * 0.0078125);
	r4 = (float3(0, 0, 0) < asfloat(r2.xyz)) ? -1 : 0;
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r0.zzz));
	r1.xyz = (r4.xyz != 0) ? r1.xyz : r2.xyz;
	r2.xyz = r0.yyy & r3.xyz;
	r0.yzw = r0.yyy & r1.xyz;
	o.xyz = asfloat(r0.yzw) + asfloat(r2.xyz);
	o.w = asfloat(r0.x);

	return o;
}
