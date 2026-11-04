cbuffer MLAAData : register(b1)
{
	float4 g_vTexelSize : packoffset(c0);
	float g_fLuminanceThreshold : packoffset(c1);
	float4 g_vRelativeLuminanceThresholdParams : packoffset(c2);
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
	float4 r3;
	float4 r4;
	float3 r5;
	r0 = asint(g_vTexelSize.xyxy * float4(-1, 0, 1, 0) + i.texcoord.xyxy);
	r1.xyz = MLAAPointSampler_tex.Sample(MLAAPointSampler, asfloat(r0.xy)).xyz;
	r0.xyz = asint(MLAAPointSampler_tex.Sample(MLAAPointSampler, asfloat(r0.zw)).xyz);
	r0.w = asint(max(r1.y, r1.x));
	r0.w = asint(max(r1.z, asfloat(r0.w)));
	r1.x = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
	r0.w = asint(asfloat(r0.w) * g_vRelativeLuminanceThresholdParams.y);
	r0.w = asint(max(asfloat(r0.w), g_vRelativeLuminanceThresholdParams.x));
	r2.xyz = MLAAPointSampler_tex.Sample(MLAAPointSampler, i.texcoord.xy).xyz;
	r2.w = max(r2.y, r2.x);
	r2.w = max(r2.z, r2.w);
	r2.x = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
	r2.y = r2.w * g_vRelativeLuminanceThresholdParams.y;
	r2.y = max(r2.y, g_vRelativeLuminanceThresholdParams.x);
	r3.x = min(asfloat(r0.w), r2.y);
	r4 = g_vTexelSize.xyxy * float4(0, -1, 0, 1) + i.texcoord.xyxy;
	r5 = MLAAPointSampler_tex.Sample(MLAAPointSampler, r4.xy).xyz;
	r4.xyz = MLAAPointSampler_tex.Sample(MLAAPointSampler, r4.zw).xyz;
	r0.w = asint(max(r5.y, r5.x));
	r0.w = asint(max(r5.z, asfloat(r0.w)));
	r1.y = dot(r5.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
	r0.w = asint(asfloat(r0.w) * g_vRelativeLuminanceThresholdParams.y);
	r0.w = asint(max(asfloat(r0.w), g_vRelativeLuminanceThresholdParams.x));
	r3.y = min(asfloat(r0.w), r2.y);
	r0.w = asint(max(asfloat(r0.y), asfloat(r0.x)));
	r0.w = asint(max(asfloat(r0.z), asfloat(r0.w)));
	r1.z = dot(asfloat(r0.xyz), float3(0.212599993, 0.715200007, 0.0722000003));
	r0.x = asint(asfloat(r0.w) * g_vRelativeLuminanceThresholdParams.y);
	r0.x = asint(max(asfloat(r0.x), g_vRelativeLuminanceThresholdParams.x));
	r3.z = min(asfloat(r0.x), r2.y);
	r0.x = asint(max(r4.y, r4.x));
	r0.x = asint(max(r4.z, asfloat(r0.x)));
	r1.w = dot(r4.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
	r1 = -(r1) + r2.x;
	r0.x = asint(asfloat(r0.x) * g_vRelativeLuminanceThresholdParams.y);
	r0.x = asint(max(asfloat(r0.x), g_vRelativeLuminanceThresholdParams.x));
	r3.w = min(asfloat(r0.x), r2.y);
	r0 = (abs(r1) >= r3) ? -1 : 0;
	r0 = r0 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r1.x = dot(asfloat(r0), asfloat(r0));
	o = asfloat(r0);
	r0.x = (r1.x != 0) ? -1 : 0;
	r0.x = (r0.x == 0) ? -1 : 0;
	if (r0.x != 0) discard;

	return o;
}
