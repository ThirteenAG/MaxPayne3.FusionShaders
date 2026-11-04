float GammaCorrection : register(c201);

float4 main(float3 color : COLOR) : COLOR
{
	float4 o;

	o.xyz = GammaCorrection.xxx * color.xyz;
	o.w = 1;

	return o;
}
