sampler2D GBufferTextureSamplerDepth : register(s10);
sampler2D gDeferredLightSampler : register(s0);
float4 gooDeferredLightScreenSize : register(c215);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(gDeferredLightSampler, r0.xy);
	r0 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.x = -r0.x + 1;
	r0.x = r0.x * 1199.95 + -1200;
	r0.x = 1 / r0.x;
	r0.y = -r1.x + 1;
	r0.y = r0.y * 1199.95 + -1200;
	r0.y = 1 / r0.y;
	r0.y = r0.y * -60;
	r0.x = r0.x * -60 + -r0.y;
	r0.y = abs(r0.x) + -0.001;
	r0.x = abs(r0.x) * -5 + 1;
	r0.y = (r0.y >= 0) ? 1 : 0;
	r0.y = r0.y * r0.x;
	o.w = (r0.x >= 0) ? r0.y : 0;
	o.xyz = float3(1, 0, 0);

	return o;
}
