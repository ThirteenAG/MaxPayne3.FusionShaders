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

SamplerState InterlaceMapSampler : register(s4);
Texture2D InterlaceMapSampler_tex : register(t4);
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
	int4 r2;
	float3 r3;
	int3 r4;
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
	float3 dimensions0;
	RenderPointMapMSAA.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.yz = asint(dimensions0.xy);
	r0.yz = asint(asfloat(r0.yz) * i.texcoord.xy);
	r1.xy = (int2)asfloat(r0.yz);
	r1.zw = int2(0, 0);
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 0).xyz);
	r1.xyz = asint(RenderPointMapMSAA.Load(r1.xy, 1).xyz);
	r1 = asint(asfloat(r0.yzwy) + asfloat(r1.xyzx));
	r2 = asint(asfloat(r1) * float4(0.5, 0.5, 0.5, 0.00390625));
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	r1.xyz = asint(-(asfloat(r1.xyz)) * float3(0.5, 0.5, 0.5) + float3(1, 1, 1));
	r3 = i.color.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
	r1.xyz = asint(asfloat(r1.xyz) * r3.xyz);
	r4 = (float3(0, 0, 0) < r3.xyz) ? -1 : 0;
	r1.xyz = asint(asfloat(r1.xyz) * float3(0.0078125, 0.0078125, 0.0078125));
	r3 = asfloat(r2.www) * r3.xyz;
	r1.xyz = (r4.xyz != 0) ? r1.xyz : asint(r3.xyz);
	r2.xyz = r2.xyz & r0.yyy;
	r0.yzw = r0.yyy & r1.xyz;
	o.xyz = asfloat(r0.yzw) + asfloat(r2.xyz);
	o.w = asfloat(r0.x);

	return o;
}
