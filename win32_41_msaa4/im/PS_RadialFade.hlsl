cbuffer RadialFadeVariables : register(b4)
{
	float4 RadialFadeArea : packoffset(c0);
	float4 RadialFadeTime : packoffset(c1);
	float4 RadialWaveParam : packoffset(c2);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float2 r1;
	r0.xy = asint(i.texcoord.xy + -(RadialFadeArea.xy));
	r0.zw = (abs(asfloat(r0.xy)) < RadialFadeArea.zw) ? -1 : 0;
	r0.z = r0.w & r0.z;
	if (r0.z != 0) discard;
	r0.z = asint(-(RadialFadeTime.w) * 2 + 1);
	r0.z = asint(saturate(asfloat(r0.z) * RadialFadeTime.x + RadialFadeTime.w));
	r1 = -(RadialFadeArea.zw) + float2(1, 1);
	r0.zw = asint(asfloat(r0.zz) * r1.xy + RadialFadeArea.zw);
	r0.w = asint(asfloat(r0.z) / asfloat(r0.w));
	r0.y = asint(asfloat(r0.w) * abs(asfloat(r0.y)));
	r0.x = asint(max(asfloat(r0.y), abs(asfloat(r0.x))));
	r0.x = asint(-(asfloat(r0.z)) + asfloat(r0.x));
	o.w = RadialWaveParam.x * asfloat(r0.x) + RadialWaveParam.y;
	o.xyz = float3(0, 0, 0);

	return o;
}
