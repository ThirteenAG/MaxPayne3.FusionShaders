sampler2D gDeferredLightSampler : register(s0);
float4 gooDeferredLightScreenSize : register(c215);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	r0.xy = gooDeferredLightScreenSize.zw * vpos.xy;
	r0 = tex2D(gDeferredLightSampler, r0.xy);
	o.xyz = r0.yyy;
	o.w = 1;

	return o;
}
