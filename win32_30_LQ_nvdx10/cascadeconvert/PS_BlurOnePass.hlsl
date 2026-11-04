sampler2D ConvertSampler : register(s0);
float4 TexelSize : register(c196);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.xy = -TexelSize.xy + texcoord.xy;
	r0 = tex2D(ConvertSampler, r0.xy);
	r1 = tex2D(ConvertSampler, texcoord.xy);
	r0.xy = r0.xy + r1.xy;
	r1.xy = TexelSize.xy;
	r1 = r1.xyxy * float4(-1, 1, 1, -1) + texcoord.xyxy;
	r2 = tex2D(ConvertSampler, r1.xy);
	r1 = tex2D(ConvertSampler, r1.zw);
	r0.xy = r0.xy + r2.xy;
	r0.zw = TexelSize.xy + texcoord.xy;
	r2 = tex2D(ConvertSampler, r0.zw);
	r0.xy = r0.xy + r2.xy;
	r0.xy = r1.xy + r0.xy;
	o.xy = r0.xy * 0.2;
	o.zw = float2(0, 1);

	return o;
}
