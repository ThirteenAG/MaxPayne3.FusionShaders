sampler2D SkyMapSampler : register(s1);
float4 TexelSize : register(c131);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = float2(-0.5, 0.5);
	r1 = TexelSize.x * r0.xxyx + texcoord.xyxy;
	r2 = tex2D(SkyMapSampler, r1.xy);
	r1 = tex2D(SkyMapSampler, r1.zw);
	r1 = r1 + r2;
	r0 = TexelSize.x * r0.xyyy + texcoord.xyxy;
	r2 = tex2D(SkyMapSampler, r0.xy);
	r0 = tex2D(SkyMapSampler, r0.zw);
	r1 = r1 + r2;
	r0 = r0 + r1;
	o = r0 * 0.25;

	return o;
}
