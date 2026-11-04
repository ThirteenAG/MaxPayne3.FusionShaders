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
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.xy = asint(i.texcoord.xy + i.color.xy);
	r0 = asint(NoiseTextureSampler_tex.Sample(NoiseTextureSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r0.x) * 2 + -1);
	r0.y = (asfloat(r0.z) < i.color.z) ? -1 : 0;
	r0.y = r0.y & 1065353216;
	r0.x = asint(asfloat(r0.x) * i.color.w);
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r1 = i.texcoord.xyxy + float4(0, -0.00390625, 0, 0.00390625);
	r2 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.xy);
	r1 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r1.zw);
	r3 = i.texcoord.xyxy + float4(-0.00390625, -0.00390625, 0.00390625, 0.00390625);
	r4 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r3.xy);
	r0.y = asint(r4.x * 0.707106769 + r2.x);
	r4 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r3.zy);
	r0.y = asint(r4.x * 0.707106769 + asfloat(r0.y));
	r4 = i.texcoord.xyxy + float4(-0.00390625, 0, 0.00390625, 0);
	r5 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r4.xy);
	r4 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r4.zw);
	r0.y = asint(asfloat(r0.y) + r5.x);
	r0.y = asint(r4.x + asfloat(r0.y));
	r6 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r3.xw);
	r3 = NormalTextureSampler_tex.Sample(NormalTextureSampler, r3.zw);
	r0.y = asint(r6.x * 0.707106769 + asfloat(r0.y));
	r0.y = asint(r1.x + asfloat(r0.y));
	r0.y = asint(r3.x * 0.707106769 + asfloat(r0.y));
	r3 = NormalTextureSampler_tex.Sample(NormalTextureSampler, i.texcoord.xy);
	r0.y = asint(asfloat(r0.y) * 0.146446615 + -(r3.x));
	r0.z = asint(-(r3.x) + 0.5);
	r0.z = asint(asfloat(r0.z) * waterSimParams1.y);
	r0.y = asint(asfloat(r0.y) * waterSimParams1.x + asfloat(r0.z));
	r0.x = asint(asfloat(r0.x) * waterSimParams2.y + asfloat(r0.y));
	r0.x = asint(asfloat(r0.x) * waterSimParams1.w);
	r0.y = asint(asfloat(r0.x) * waterSimParams2.w);
	o.y = asfloat(r0.x) * waterSimParams2.w + r3.y;
	r0.x = asint(asfloat(r0.y) * waterSimParams2.w);
	r0.y = asint(r3.y + -0.5);
	r0.y = asint(asfloat(r0.y) * waterSimParams2.x);
	r0.y = asint(asfloat(r0.y) * waterSimParams2.w + r3.x);
	o.x = asfloat(r0.x) * 0.5 + asfloat(r0.y);
	r0.x = asint(-(r5.x) + r3.x);
	r0.y = asint(-(r3.x) + r4.x);
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	o.z = asfloat(r0.x) * 0.5 + 0.5;
	r0.x = asint(-(r2.x) + r3.x);
	r0.y = asint(r1.x + -(r3.x));
	r0.x = asint(asfloat(r0.y) + asfloat(r0.x));
	o.w = asfloat(r0.x) * 0.5 + 0.5;

	return o;
}
