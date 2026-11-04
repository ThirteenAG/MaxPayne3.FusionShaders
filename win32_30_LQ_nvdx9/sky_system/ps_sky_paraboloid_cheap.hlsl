float sphereReflectionSkyIntensity : register(c138);
float3 sunColor : register(c141);
float4 sunConstants : register(c144);
float3 sunDirection : register(c145);
float sunHdrIntensity : register(c143);

struct PS_IN
{
	float3 texcoord1 : TEXCOORD1;
	half3 texcoord2 : TEXCOORD2;
};

struct PS_OUT
{
	half4 color : COLOR;
	half4 color1 : COLOR1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float3 r1;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r1 = half3(normalize(r0.xyz));
	r0.x = dot(r1.xyz, -sunDirection.xyz);
	r0.y = sunConstants.x * -r0.x + sunConstants.y;
	r0.x = r0.x * r0.x + 1;
	r0.y = abs(r0.y) + 1E-05;
	r1.x = pow(r0.y, 1.50001);
	r0.y = 1 / r1.x;
	r0.x = r0.y * r0.x;
	r0.x = half(saturate(r0.x * sunConstants.z));
	r1 = half3(sunColor.xyz);
	r0.yzw = half3(r1.xyz * sunHdrIntensity.xxx + -i.texcoord2.xyz);
	r0.xyz = half3(r0.xxx * r0.yzw + i.texcoord2.xyz);
	r0.xyz = half3(r0.xyz * sphereReflectionSkyIntensity.xxx);
	r0.xyz = saturate(r0.xyz * 0.0625);
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
