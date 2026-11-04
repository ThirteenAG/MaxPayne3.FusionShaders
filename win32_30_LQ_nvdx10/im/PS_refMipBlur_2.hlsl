sampler2D RefBlurMapSampler : register(s2);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(RefBlurMapSampler, texcoord.xy);
	o.xyz = r0.xyz;
	o.w = 1;

	return o;
}
