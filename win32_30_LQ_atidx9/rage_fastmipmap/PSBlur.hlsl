sampler2D BaseSampler : register(s3);
float4 TexelSize : register(c38);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = float2(-1, 1);
	r1 = TexelSize.xxyx * r0.xxyx + texcoord.xyxy;
	r2 = tex2D(BaseSampler, r1.xy);
	r1 = tex2D(BaseSampler, r1.zw);
	r1 = r1 + r2;
	r0 = TexelSize.xyyy * r0.xyyy + texcoord.xyxy;
	r2 = tex2D(BaseSampler, r0.xy);
	r0 = tex2D(BaseSampler, r0.zw);
	r1 = r1 + r2;
	r0 = r0 + r1;
	o = r0 * 0.25;

	return o;
}
