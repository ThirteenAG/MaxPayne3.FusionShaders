float3 sunDiscColor : register(c142);
float waterReflectionSkyIntensity : register(c139);
float3 zenithConstants : register(c136);

half4 main(float3 texcoord : TEXCOORD) : COLOR
{
	half4 o;

	float3 r0;
	r0 = 1E-05 + texcoord.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = saturate(r0.x * r0.z);
	r0.y = 1 / zenithConstants.x;
	r0.x = r0.y * r0.x;
	r0.x = saturate(r0.x * 0.5);
	r0 = half3(r0.xxx * sunDiscColor.xyz);
	r0 = half3(r0.xyz * waterReflectionSkyIntensity.xxx);
	r0 = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;
	o.w = 1;

	return o;
}
