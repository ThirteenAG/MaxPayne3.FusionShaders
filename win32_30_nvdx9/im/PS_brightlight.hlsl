float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);

float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float2 r0;
	float3 r1;
	r0.x = gAdrenoFXVars.x;
	r0.x = r0.x * deSatContrastGamma.x;
	r0.y = dot(texcoord.xyz, float3(0.2125, 0.7154, 0.0721));
	r1 = -r0.yyy + texcoord.xyz;
	o.xyz = r0.xxx * r1.xyz + r0.yyy;
	o.w = 1;

	return o;
}
