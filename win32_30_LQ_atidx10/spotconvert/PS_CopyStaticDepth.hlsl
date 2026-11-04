sampler2D ConvertSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(ConvertSampler, texcoord.xy);
	o = r0.x;

	return o;
}
