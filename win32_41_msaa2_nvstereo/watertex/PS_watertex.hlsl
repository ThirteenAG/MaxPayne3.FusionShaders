cbuffer WaterSim : register(b4)
{
	float4 waterSimParams1 : packoffset(c0);
	float4 waterSimParams2 : packoffset(c1);
};

SamplerState NormalTextureSampler : register(s0);
SamplerState NoiseTextureSampler : register(s1);
Texture2D NormalTextureSampler_tex : register(t0);
Texture2D NoiseTextureSampler_tex : register(t1);

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
	float4 r1;
	float4 r2;
	r0.xy = asint(i.texcoord.xy + i.color.xy);
	r0.xy = asint(NoiseTextureSampler_tex.Sample(NoiseTextureSampler, asfloat(r0.xy)).xz);
	r0.x = asint(asfloat(r0.x) * 2 + -1);
	r0.y = (asfloat(r0.y) < i.color.z) ? -1 : 0;
	r0.y = r0.y & 1065353216;
	r0.x = asint(asfloat(r0.x) * i.color.w);
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r1 = i.texcoord.xyxy + float4(0, -0.00390625, 0, 0.00390625);
	r0.y = asint(NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.xy).x);
	r0.z = asint(NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.zw).x);
	r1 = i.texcoord.xyxy + float4(-0.00390625, -0.00390625, 0.00390625, 0.00390625);
	r0.w = asint(NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.xy).x);
	r0.w = asint(asfloat(r0.w) * 0.707106769 + asfloat(r0.y));
	r1.y = NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.zy).x;
	r0.w = asint(r1.y * 0.707106769 + asfloat(r0.w));
	r2 = i.texcoord.xyxy + float4(-0.00390625, 0, 0.00390625, 0);
	r1.y = NormalTextureSampler_tex.Sample(NormalTextureSampler, r2.xy).x;
	r2.x = NormalTextureSampler_tex.Sample(NormalTextureSampler, r2.zw).x;
	r0.w = asint(asfloat(r0.w) + r1.y);
	r0.w = asint(r2.x + asfloat(r0.w));
	r1.x = NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.xw).x;
	r1.z = NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.zw).x;
	r0.w = asint(r1.x * 0.707106769 + asfloat(r0.w));
	r0.w = asint(asfloat(r0.z) + asfloat(r0.w));
	r0.w = asint(r1.z * 0.707106769 + asfloat(r0.w));
	r1.xz = NormalTextureSampler_tex.Sample(NormalTextureSampler, i.texcoord.xy).xy;
	r0.w = asint(asfloat(r0.w) * 0.146446615 + -(r1.x));
	r1.w = -(r1.x) + 0.5;
	r1.w = r1.w * waterSimParams1.y;
	r0.w = asint(asfloat(r0.w) * waterSimParams1.x + r1.w);
	r0.x = asint(asfloat(r0.x) * waterSimParams2.y + asfloat(r0.w));
	r0.x = asint(asfloat(r0.x) * waterSimParams1.w);
	r0.w = asint(asfloat(r0.x) * waterSimParams2.w);
	o.y = asfloat(r0.x) * waterSimParams2.w + r1.z;
	r0.x = asint(asfloat(r0.w) * waterSimParams2.w);
	r0.w = asint(r1.z + -0.5);
	r0.w = asint(asfloat(r0.w) * waterSimParams2.x);
	r0.w = asint(asfloat(r0.w) * waterSimParams2.w + r1.x);
	o.x = asfloat(r0.x) * 0.5 + asfloat(r0.w);
	r0.x = asint(-(r1.y) + r1.x);
	r0.w = asint(-(r1.x) + r2.x);
	r0.x = asint(asfloat(r0.w) + asfloat(r0.x));
	o.z = asfloat(r0.x) * 0.5 + 0.5;
	r0.x = asint(-(asfloat(r0.y)) + r1.x);
	r0.y = asint(asfloat(r0.z) + -(r1.x));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	o.w = asfloat(r0.x) * 0.5 + 0.5;

	return o;
}
