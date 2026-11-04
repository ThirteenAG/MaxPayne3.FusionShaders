cbuffer WaterRipple : register(b4)
{
	float3 g_vRippleTexelSize : packoffset(c0);
	float g_fRippleRainStrength : packoffset(c0.w);
	float4 g_vRippleAttributes : packoffset(c1);
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
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xw = g_vRippleTexelSize.xy * g_vRippleTexelSize.zz;
	r0.yz = float2(0, 0);
	r1 = -(r0) + i.texcoord.xyxy;
	r0 = r0 + i.texcoord.xyxy;
	r2 = WaterRippleSampler_tex.Sample(WaterRippleSampler, r1.xy);
	r1 = WaterRippleSampler_tex.Sample(WaterRippleSampler, r1.zw);
	r3 = WaterRippleSampler_tex.Sample(WaterRippleSampler, r0.xy);
	r0 = WaterRippleSampler_tex.Sample(WaterRippleSampler, r0.zw);
	r0.y = r2.x + r3.x;
	r0.y = r1.x + r0.y;
	r0.x = r0.x + r0.y;
	r1 = WaterRippleSampler_tex.Sample(WaterRippleSampler, i.texcoord.xy);
	r0.x = -(r1.x) * 4 + r0.x;
	r0.y = -(r1.x) + 0.5;
	r0.zw = r1.yx + float2(-0.5, -0.5);
	r0.y = r0.y * g_vRippleAttributes.w;
	r0.x = g_vRippleAttributes.y * r0.x + r0.y;
	r0.x = g_vRippleAttributes.x * r0.x + r0.z;
	r1.x = g_vRippleAttributes.x * r0.x + r0.w;
	r1.z = r0.x * g_vRippleAttributes.z;
	o = r1.xzxz + float4(0.5, 0.5, 0.5, 0.5);

	return o;
}
