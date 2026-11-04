sampler2D MLAALinearSampler : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = tex2D(MLAALinearSampler, texcoord.xy);

	return o;
}
