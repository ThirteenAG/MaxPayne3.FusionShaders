sampler2D SkyMapSampler : register(s1);
float4 TexelSize : register(c131);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xyz = float3(-1.5, -0.5, 0.5);
	r1 = TexelSize.xyxy * r0.xxyx + texcoord.xyxy;
	r2 = tex2D(SkyMapSampler, r1.zw);
	r1 = tex2D(SkyMapSampler, r1.xy);
	r2 = r2 * 0.5;
	r1 = r1 * 0.25 + r2;
	r2.xy = TexelSize.xy;
	r3 = r2.xyxy * float4(0.5, -1.5, 1.5, -1.5) + texcoord.xyxy;
	r4 = tex2D(SkyMapSampler, r3.xy);
	r3 = tex2D(SkyMapSampler, r3.zw);
	r1 = r4 * 0.5 + r1;
	r1 = r3 * 0.25 + r1;
	r3 = TexelSize.xyxy * r0.xyyy + texcoord.xyxy;
	r4 = tex2D(SkyMapSampler, r3.xy);
	r3 = tex2D(SkyMapSampler, r3.zw);
	r1 = r4 * 0.5 + r1;
	r1 = r3 + r1;
	r3 = TexelSize.xyxy * -r0.yzxz + texcoord.xyxy;
	r4 = tex2D(SkyMapSampler, r3.xy);
	r3 = tex2D(SkyMapSampler, r3.zw);
	r1 = r1 + r4;
	r1 = r3 * 0.5 + r1;
	r3 = TexelSize.xyxy * r0.xzyz + texcoord.xyxy;
	r4 = tex2D(SkyMapSampler, r3.xy);
	r3 = tex2D(SkyMapSampler, r3.zw);
	r1 = r4 * 0.5 + r1;
	r1 = r3 + r1;
	r3 = TexelSize.xyxy * -r0.yyxy + texcoord.xyxy;
	r4 = tex2D(SkyMapSampler, r3.xy);
	r3 = tex2D(SkyMapSampler, r3.zw);
	r1 = r1 + r4;
	r1 = r3 * 0.5 + r1;
	r2 = r2.xyxy * float4(-1.5, 1.5, -0.5, 1.5) + texcoord.xyxy;
	r3 = tex2D(SkyMapSampler, r2.xy);
	r2 = tex2D(SkyMapSampler, r2.zw);
	r1 = r3 * 0.25 + r1;
	r1 = r2 * 0.5 + r1;
	r0 = TexelSize.xyxy * -r0.yxxx + texcoord.xyxy;
	r2 = tex2D(SkyMapSampler, r0.xy);
	r0 = tex2D(SkyMapSampler, r0.zw);
	r1 = r2 * 0.5 + r1;
	r0 = r0 * 0.25 + r1;
	o = r0 * 0.11111111;

	return o;
}
