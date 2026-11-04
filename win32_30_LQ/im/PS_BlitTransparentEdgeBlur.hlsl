float4 TexelSize : register(c200);
sampler2D TransparentSrcMapSampler : register(s3);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = tex2D(TransparentSrcMapSampler, texcoord.xy);
	r1.xy = float2(-0.75, 0.75);
	r2 = TexelSize.xyxy * r1.xxyx + texcoord.xyxy;
	r3 = tex2D(TransparentSrcMapSampler, r2.xy);
	r2 = tex2D(TransparentSrcMapSampler, r2.zw);
	r0 = r3 * 0.75 + r0;
	r0 = r2 * 0.75 + r0;
	r1 = TexelSize.xyxy * r1.xyyy + texcoord.xyxy;
	r2 = tex2D(TransparentSrcMapSampler, r1.xy);
	r1 = tex2D(TransparentSrcMapSampler, r1.zw);
	r0 = r2 * 0.75 + r0;
	r0 = r1 * 0.75 + r0;
	o = r0 * 0.25;

	return o;
}
