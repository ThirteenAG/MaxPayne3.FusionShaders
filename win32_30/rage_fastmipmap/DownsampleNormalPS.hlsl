sampler2D BaseSampler : register(s3);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	r0 = tex2D(BaseSampler, texcoord.xy);
	r0.xyz = r0.xyz * 2 + -1;
	r1 = normalize(r0.xyz);
	o.xyz = r1.xyz * 0.5 + 0.5;
	o.w = 1;

	return o;
}
