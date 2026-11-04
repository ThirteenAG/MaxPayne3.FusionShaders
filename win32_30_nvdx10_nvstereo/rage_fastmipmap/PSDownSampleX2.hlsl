sampler2D BaseSampler : register(s3);
float4 TexelSize : register(c38);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float2 r0;
	r0.x = TexelSize.x;
	r0 = r0.xx * -0.5 + texcoord.xy;
	o = tex2D(BaseSampler, r0.xy);

	return o;
}
