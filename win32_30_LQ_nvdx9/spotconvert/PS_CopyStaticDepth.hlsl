sampler2D ConvertSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	r0 = tex2D(ConvertSampler, texcoord.xy);
	r0.xyz = r0.wxy * 255 + 0.5;
	r1 = frac(r0.xyz);
	r0.xyz = r0.xyz + -r1.xyz;
	o = dot(r0.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));

	return o;
}
