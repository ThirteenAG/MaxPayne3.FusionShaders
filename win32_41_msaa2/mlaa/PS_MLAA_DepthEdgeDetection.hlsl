cbuffer MLAAData : register(b1)
{
	float4 g_vTexelSize : packoffset(c0);
};

SamplerState MLAAPointSampler : register(s0);
Texture2D MLAAPointSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	r0.x = asint(MLAAPointSampler_tex.Sample(MLAAPointSampler, i.texcoord.xy).x);
	r1 = g_vTexelSize.xyxy * float4(-1, 0, 1, 0) + i.texcoord.xyxy;
	r2.x = MLAAPointSampler_tex.Sample(MLAAPointSampler, r1.xy).x;
	r2.z = MLAAPointSampler_tex.Sample(MLAAPointSampler, r1.zw).x;
	r1 = g_vTexelSize.xyxy * float4(0, -1, 0, 1) + i.texcoord.xyxy;
	r2.y = MLAAPointSampler_tex.Sample(MLAAPointSampler, r1.xy).x;
	r2.w = MLAAPointSampler_tex.Sample(MLAAPointSampler, r1.zw).x;
	r0 = asint(asfloat(r0.x) + -(r2));
	r0 = (abs(asfloat(r0)) >= float4(0.00100000005, 0.00100000005, 0.00100000005, 0.00100000005)) ? -1 : 0;
	r0 = r0 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r1.x = dot(asfloat(r0), asfloat(r0));
	o = asfloat(r0);
	r0.x = (r1.x != 0) ? -1 : 0;
	r0.x = (r0.x == 0) ? -1 : 0;
	if (r0.x != 0) discard;

	return o;
}
