sampler2D GBufferTextureSampler2 : register(s13);
float4 gooDeferredLightScreenSize : register(c215);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float2 r0;
	r0 = 0.51 + vpos.xy;
	r0 = r0.xy * gooDeferredLightScreenSize.zw;
	o = tex2D(GBufferTextureSampler2, r0.xy);

	return o;
}
