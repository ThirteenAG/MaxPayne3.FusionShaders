sampler2D DensitySampler : register(s0);
float2 gDensityShiftScale : register(c29);
float4 gPiercingLightPower_Strength_NormalStrength_Thickness : register(c31);

float4 main(float2 texcoord1 : TEXCOORD1) : COLOR
{
	float4 o;

	float4 r0;
	float r1;
	r0 = tex2D(DensitySampler, texcoord1.xy);
	r0.x = r0.y * -r0.y + 1;
	r0.x = r0.x + -gDensityShiftScale.x;
	r0.x = saturate(r0.x * gDensityShiftScale.y);
	r0.x = -r0.x + 1;
	r1 = 1;
	r0.y = r1.x + -gPiercingLightPower_Strength_NormalStrength_Thickness.w;
	r0.x = saturate(r0.x * gPiercingLightPower_Strength_NormalStrength_Thickness.w + r0.y);
	r0.x = r0.x * -12 + 1;
	o.w = max(r0.x, 0);
	o.xyz = 0;

	return o;
}
