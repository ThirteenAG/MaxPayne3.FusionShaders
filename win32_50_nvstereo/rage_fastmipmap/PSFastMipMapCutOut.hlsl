cbuffer _Globals : register(b1)
{
	float4 TexelSize : packoffset(c38);
};

SamplerState BaseSampler : register(s3);
Texture2D BaseSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	r0.z = asint(-(TexelSize.x) * 0.5 + i.texcoord.x);
	r0.xyw = asint(TexelSize.xyy * float3(0.5, 0.5, 0.5) + i.texcoord.xyy);
	r1 = BaseSampler_tex.Sample(BaseSampler, asfloat(r0.zw));
	r0 = asint(BaseSampler_tex.Sample(BaseSampler, asfloat(r0.xy)));
	r0 = asint(r1 + asfloat(r0));
	r1.x = TexelSize.x * 0.5 + i.texcoord.x;
	r1.yzw = -(TexelSize.yxy) * float3(0.5, 0.5, 0.5) + i.texcoord.yxy;
	r2 = BaseSampler_tex.Sample(BaseSampler, r1.xy);
	r1 = BaseSampler_tex.Sample(BaseSampler, r1.zw);
	r0 = asint(asfloat(r0) + r2);
	r0 = asint(r1 + asfloat(r0));
	r1.x = asfloat(r0.w) * 0.25 + -0.5;
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, 0.25, 0.25));
	o = asfloat(r0);
	r0.x = (r1.x < 0) ? -1 : 0;
	if (r0.x != 0) discard;

	return o;
}
