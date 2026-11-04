sampler2D NoiseSampler : register(s0);
float noiseDensityOffset : register(c170);
float noiseFrequency : register(c166);
float noisePhase : register(c171);
float noiseScale : register(c167);
float noiseSoftness : register(c169);
float noiseThreshold : register(c168);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = -0.5 + texcoord.xy;
	r1.yzw = float3(0.5, -0.01, 0.01);
	r0.xy = r0.xy * noiseScale.xx + r1.yy;
	r0.zw = r1.zw * noisePhase.xx;
	r0.xy = r0.xy * 0.0078125 + r0.zw;
	r1 = tex2D(NoiseSampler, r0.xy);
	r0.xy = r0.xy * noiseFrequency.xx;
	r0.z = r1.x + -0.5;
	r1 = tex2D(NoiseSampler, r0.xy);
	r0.xy = r0.xy * noiseFrequency.xx;
	r2 = tex2D(NoiseSampler, r0.xy);
	r0.x = r2.z + -0.5;
	r0.y = r0.z * 2 + r1.y;
	r0.y = r0.y + -0.5;
	r0.x = r0.x * 0.5 + r0.y;
	r0.x = r0.x * 0.2857143 + 0.5;
	r1.x = noiseThreshold.x;
	r0.y = r1.x + -noiseSoftness.x;
	r0.z = -r0.y + r0.x;
	r0.w = r1.x + noiseSoftness.x;
	r1.x = -r0.y + r0.w;
	r0.yw = r0.yw + noiseDensityOffset.xx;
	r0.w = -r0.y + r0.w;
	r0.y = -r0.y + r0.x;
	o.z = r0.x;
	r0.x = 1 / r0.w;
	r0.x = saturate(r0.x * r0.y);
	r0.y = 1 / r1.x;
	r0.y = saturate(r0.y * r0.z);
	r0.z = r0.y * -2 + 3;
	r0.y = r0.y * r0.y;
	o.x = r0.y * r0.z;
	r0.y = r0.x * -2 + 3;
	r0.x = r0.x * r0.x;
	o.y = r0.x * r0.y;
	o.w = 0;

	return o;
}
