sampler2D SmartBlitSampler : register(s1);
float4 clearcol : register(c196);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	r0 = tex2D(SmartBlitSampler, texcoord.xy);
	r1.xy = float2(0.5, -0.5);
	r2 = clearcol.x * r1.xyxx + texcoord.xyxy;
	r3 = tex2D(SmartBlitSampler, r2.xy);
	r2 = tex2D(SmartBlitSampler, r2.zw);
	r4 = max(r0.xyz, r3.xyz);
	r0.xyz = max(r4.xyz, r2.xyz);
	r1 = clearcol.x * r1.yxyy + texcoord.xyxy;
	r2 = tex2D(SmartBlitSampler, r1.xy);
	r1 = tex2D(SmartBlitSampler, r1.zw);
	r3.xyz = max(r0.xyz, r2.xyz);
	o.xyz = max(r3.xyz, r1.xyz);
	o.w = 1;

	return o;
}
