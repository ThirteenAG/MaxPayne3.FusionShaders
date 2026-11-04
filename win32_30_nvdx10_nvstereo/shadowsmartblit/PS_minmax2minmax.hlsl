sampler2D SmartBlitSampler : register(s1);
float4 clearcol : register(c196);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = float2(0.5, -0.5);
	r1 = clearcol.xyxy * r0.x + texcoord.xyxy;
	r2 = clearcol.xyxy * r0.yyxx + r1.zwzw;
	r0 = clearcol.xyxy * r0.xyyx + r1;
	r1 = tex2D(SmartBlitSampler, r2.xy);
	r2 = tex2D(SmartBlitSampler, r2.zw);
	r3 = tex2D(SmartBlitSampler, r0.xy);
	r0 = tex2D(SmartBlitSampler, r0.zw);
	r0.z = min(r3.x, r1.x);
	r0.w = max(r1.y, r3.y);
	r1.x = max(r0.w, r0.y);
	r1.y = min(r0.x, r0.z);
	o.x = min(r2.x, r1.y);
	o.y = max(r1.x, r2.y);
	o.zw = float2(0, 1);

	return o;
}
