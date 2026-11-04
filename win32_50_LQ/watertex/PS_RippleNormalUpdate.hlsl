cbuffer WaterRipple : register(b4)
{
	float3 g_vRippleTexelSize : packoffset(c0);
	float g_fRippleRainStrength : packoffset(c0.w);
};

SamplerState WaterRippleSampler : register(s2);
Texture2D WaterRippleSampler_tex : register(t2);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float3 r1;
	r0.xw = -(g_vRippleTexelSize.xy);
	r0.yz = float2(0, 0);
	r0 = r0 + i.texcoord.xyxy;
	r0.x = WaterRippleSampler_tex.Sample(WaterRippleSampler, r0.xy).x;
	r0.y = WaterRippleSampler_tex.Sample(WaterRippleSampler, r0.zw).x;
	r0.z = WaterRippleSampler_tex.Sample(WaterRippleSampler, i.texcoord.xy).x;
	r0.xy = -(r0.xy) + r0.zz;
	r0.z = g_fRippleRainStrength * 2 + 1;
	r1.xy = r0.xy * -(r0.zz);
	r1.z = 1;
	r0.xyz = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.z = dot(r0.xyz, r0.xyz);
	r1.z = rsqrt(r0.z);
	r1.xy = r0.xy * r1.zz;
	o.xyz = r1.xyz * float3(0.5, 0.5, 0.500005007) + float3(0.5, 0.5, 0.5);
	o.w = 1;

	return o;
}
