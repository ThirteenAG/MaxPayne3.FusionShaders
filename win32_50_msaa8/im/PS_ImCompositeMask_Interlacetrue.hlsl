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

SamplerState AlphaMaskMapSampler : register(s3);
SamplerState InterlaceMapSampler : register(s4);
Texture2D AlphaMaskMapSampler_tex : register(t3);
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
	r0.z = (MaskAlphaReverse == 0) ? -1 : 0;
	r0.w = asint(asfloat(r0.x) * i.color.w);
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(asfloat(r0.x) * i.color.w);
	r0.xw = asint(asfloat(r0.yy) * asfloat(r0.xw));
	r0.x = (r0.z != 0) ? r0.w : r0.x;
	float3 dimensions0;
	RenderPointMapMSAA.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.yz = asint(dimensions0.xy);
	r0.yz = asint(asfloat(r0.yz) * i.texcoord.xy);
	r1.xy = (int2)asfloat(r0.yz);
	r1.zw = int2(0, 0);
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 0).xyz);
	r2.xyz = asint(RenderPointMapMSAA.Load(r1.xy, 1).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2.xyzx));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 2).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 3).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 4).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 5).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 6).xyz);
	r2 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r0.yzw = asint(RenderPointMapMSAA.Load(r1.xy, 7).xyz);
	r1 = asint(asfloat(r0.yzwy) + asfloat(r2));
	r2 = asint(asfloat(r1) * float4(0.125, 0.125, 0.125, 0.0009765625));
	r0.y = (0 < asfloat(r0.x)) ? -1 : 0;
	r1.xyz = asint(-(asfloat(r1.xyz)) * float3(0.125, 0.125, 0.125) + float3(1, 1, 1));
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
