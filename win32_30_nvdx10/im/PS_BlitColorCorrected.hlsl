float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);

float4 main(float4 color : COLOR) : COLOR
{
	float4 o;

	float4 r0;
	float r1;
	r0.x = dot(color.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.x = r0.x + 1E-07;
	r0.x = abs(r0.x) + 1E-05;
	r1 = pow(r0.x, 1E-05);
	r0.xyz = r1.xxx * color.xyz;
	r0.x = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.yzw = color.xyz * r1.xxx + -r0.xxx;
	r1 = gAdrenoFXVars.x;
	r1 = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.yzw + r0.xxx;
	o.w = color.w;

	return o;
}
