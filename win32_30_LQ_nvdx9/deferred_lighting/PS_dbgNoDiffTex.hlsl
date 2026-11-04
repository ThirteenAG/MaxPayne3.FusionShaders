float4 gDeferredLightColourAndIntensity : register(c214);

float4 main() : COLOR
{
	float4 o;

	float2 r0;
	r0 = float2(1, 0);
	o = gDeferredLightColourAndIntensity.xyzx * r0.xxxy + r0.yyyx;

	return o;
}
