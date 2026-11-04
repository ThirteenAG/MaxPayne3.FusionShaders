float3 sunDiscColor : register(c142);
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
	o.xyz = r0.xxx * sunDiscColor.xyz;
	o.w = 1;

	return o;
}
