cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
	float4 TransColor : packoffset(c207);
	float4 TransPos : packoffset(c208);
	float4 TransTex0 : packoffset(c209);
	float4 TexelSize : packoffset(c210);
};

SamplerState TransparentSrcMapSampler : register(s3);
Texture2D TransparentSrcMapSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, i.texcoord.xy);
	r1 = TexelSize.xyxy * float4(-0.75, -0.75, 0.75, -0.75) + i.texcoord.xyxy;
	r2 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r1.xy);
	r1 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r1.zw);
	r0 = r2 * float4(0.75, 0.75, 0.75, 0.75) + r0;
	r0 = r1 * float4(0.75, 0.75, 0.75, 0.75) + r0;
	r1 = TexelSize.xyxy * float4(-0.75, 0.75, 0.75, 0.75) + i.texcoord.xyxy;
	r2 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r1.xy);
	r1 = TransparentSrcMapSampler_tex.Sample(TransparentSrcMapSampler, r1.zw);
	r0 = r2 * float4(0.75, 0.75, 0.75, 0.75) + r0;
	r0 = r1 * float4(0.75, 0.75, 0.75, 0.75) + r0;
	o = r0 * float4(0.25, 0.25, 0.25, 0.25);

	return o;
}
