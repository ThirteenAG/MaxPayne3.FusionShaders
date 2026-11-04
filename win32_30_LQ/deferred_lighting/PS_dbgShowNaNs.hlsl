sampler2D gDeferredLightSampler : register(s0);
float4 gooDeferredLightScreenSize : register(c215);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float2 r0;
	r0 = gooDeferredLightScreenSize.zw * vpos.xy;
	o = tex2D(gDeferredLightSampler, r0.xy);

	return o;
}
