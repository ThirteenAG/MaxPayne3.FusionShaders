float sphereReflectionSkyIntensity : register(c138);
float3 sunDiscColor : register(c142);
float3 zenithConstants : register(c136);

struct PS_OUT
{
	half4 color : COLOR;
	half4 color1 : COLOR1;
};

PS_OUT main(float3 texcoord : TEXCOORD)
{
	PS_OUT o;

	float3 r0;
	r0 = 1E-05 + texcoord.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = saturate(r0.x * r0.z);
	r0.y = 1 / zenithConstants.x;
	r0.x = r0.y * r0.x;
	r0.x = saturate(r0.x * 0.5);
	r0 = half3(r0.xxx * sunDiscColor.xyz);
	r0 = half3(r0.xyz * sphereReflectionSkyIntensity.xxx);
	r0 = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.color.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.color.z = 1 / r0.y;
	o.color.y = 1 / r0.x;
	o.color.w = 1;
	o.color1 = 64;

	return o;
}
