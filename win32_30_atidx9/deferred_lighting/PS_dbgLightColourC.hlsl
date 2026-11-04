float4 debugLightColour : register(c145);

float4 main() : COLOR
{
	float4 o;

	o = debugLightColour;

	return o;
}
