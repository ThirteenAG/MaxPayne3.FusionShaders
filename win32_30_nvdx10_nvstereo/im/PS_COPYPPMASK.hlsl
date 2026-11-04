sampler2D AlphaMaskMapSampler : register(s3);
sampler2D RenderMapPointSampler : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(RenderMapPointSampler, texcoord.xy);
	o.xzw = r0.xzw;
	r0 = tex2D(AlphaMaskMapSampler, texcoord.xy);
	o.y = r0.w;

	return o;
}
