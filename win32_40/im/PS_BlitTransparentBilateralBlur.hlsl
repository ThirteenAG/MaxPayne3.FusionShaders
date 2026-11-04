cbuffer _Globals : register(b4)
{
	float4 TransColor : packoffset(c206);
	float4 TransPos : packoffset(c207);
	float4 TransTex0 : packoffset(c208);
	float4 TexelSize : packoffset(c209);
	float GammaCorrection : packoffset(c210);
	float g_fBilateralCoefficient : packoffset(c211);
};

SamplerState TransparentSrcMapSampler : register(s3);
SamplerState DepthMapPointSampler : register(s4);
SamplerState LowResDepthMapPointSampler : register(s5);
Texture2D TransparentSrcMapSampler_tex : register(t3);
Texture2D DepthMapPointSampler_tex : register(t4);
Texture2D LowResDepthMapPointSampler_tex : register(t5);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	r0 = asint(i.texcoord.xyxy * TexelSize.zwzw);
	r0 = asint(round(asfloat(r0)));
	r1.xy = asint(-(asfloat(r0.zw)) * TexelSize.xy + i.texcoord.xy);
	r2 = float4(-0.5, -0.5, 0.5, 0.5) * TexelSize.xyxy;
	r1.xy = asint(asfloat(r1.xy) / r2.zw);
	r2 = asfloat(r0) * TexelSize.xyxy + r2;
	r0.xy = asint(asfloat(r0.zw) * TexelSize.xy);
	r0 = asint(TexelSize.xyxy * float4(0.5, -0.5, -0.5, 0.5) + asfloat(r0.xyxy));
	r1.xy = asint(asfloat(r1.xy) * float2(0.5, 0.5) + float2(0.5, 0.5));
	r1.z = asint(-(asfloat(r1.x)) + 1);
	r1.z = asint(-(asfloat(r1.y)) + asfloat(r1.z));
	r1.z = asint(asfloat(r1.x) * asfloat(r1.y) + asfloat(r1.z));
	r3 = asint(LowResDepthMapPointSampler_tex.Sample(LowResDepthMapPointSampler, r2.xy));
	r1.w = (0.5 < asfloat(r1.z)) ? -1 : 0;
	r4 = asint(DepthMapPointSampler_tex.Sample(DepthMapPointSampler, i.texcoord.xy));
	r3.y = (asfloat(r4.x) < asfloat(r3.x)) ? -1 : 0;
	r1.w = r1.w & r3.y;
	r1.w = (r1.w != 0) ? r4.x : r3.x;
	r1.w = asint(-(asfloat(r4.x)) + asfloat(r1.w));
	r1.w = asint(abs(asfloat(r1.w)) / g_fBilateralCoefficient);
	r1.w = asint(asfloat(r1.w) * asfloat(r1.w));
	r1.w = asint(asfloat(r1.w) * -0.721347511);
	r1.w = asint(exp2(asfloat(r1.w)));
	r3.x = asint(asfloat(r1.z) * asfloat(r1.w));
	r5 = LowResDepthMapPointSampler_tex.Sample(LowResDepthMapPointSampler, asfloat(r0.xy));
	r3.yz = asint(-(asfloat(r1.xx)) * asfloat(r1.yy) + asfloat(r1.xy));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	r4.yz = (float2(0.5, 0.5) < asfloat(r3.yz)) ? -1 : 0;
	r1.y = (asfloat(r4.x) < r5.x) ? -1 : 0;
	r1.y = r4.y & r1.y;
	r1.y = (r1.y != 0) ? r4.x : asint(r5.x);
	r1.y = asint(-(asfloat(r4.x)) + asfloat(r1.y));
	r1.y = asint(abs(asfloat(r1.y)) / g_fBilateralCoefficient);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * -0.721347511);
	r1.y = asint(exp2(asfloat(r1.y)));
	r1.y = asint(asfloat(r3.y) * asfloat(r1.y));
	r5 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, asfloat(r0.xy));
	r5 = asfloat(r1.y) * r5;
	r0.x = asint(asfloat(r1.w) * asfloat(r1.z) + asfloat(r1.y));
	r6 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r2.xy);
	r5 = r6 * asfloat(r3.x) + r5;
	r6 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, asfloat(r0.zw));
	r7 = LowResDepthMapPointSampler_tex.Sample(LowResDepthMapPointSampler, asfloat(r0.zw));
	r0.y = (asfloat(r4.x) < r7.x) ? -1 : 0;
	r0.y = r4.z & r0.y;
	r0.y = (r0.y != 0) ? r4.x : asint(r7.x);
	r0.y = asint(-(asfloat(r4.x)) + asfloat(r0.y));
	r0.y = asint(abs(asfloat(r0.y)) / g_fBilateralCoefficient);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) * -0.721347511);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.z = asint(asfloat(r3.z) * asfloat(r0.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r3.z) + asfloat(r0.x));
	r3 = asint(r6 * asfloat(r0.z) + r5);
	r0.y = (0.5 < asfloat(r1.x)) ? -1 : 0;
	r5 = LowResDepthMapPointSampler_tex.Sample(LowResDepthMapPointSampler, r2.zw);
	r2 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r2.zw);
	r0.z = (asfloat(r4.x) < r5.x) ? -1 : 0;
	r0.y = r0.y & r0.z;
	r0.y = (r0.y != 0) ? r4.x : asint(r5.x);
	r0.y = asint(-(asfloat(r4.x)) + asfloat(r0.y));
	r0.y = asint(abs(asfloat(r0.y)) / g_fBilateralCoefficient);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) * -0.721347511);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.z = asint(asfloat(r1.x) * asfloat(r0.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r1.x) + asfloat(r0.x));
	r1 = asint(r2 * asfloat(r0.z) + asfloat(r3));
	r0.y = asint(ceil(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + -1);
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x) + 1);
	o = asfloat(r1) / asfloat(r0.x);

	return o;
}
