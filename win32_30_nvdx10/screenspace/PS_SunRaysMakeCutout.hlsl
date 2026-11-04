sampler2D deferredLightDownsampleDepthSampler : register(s12);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(deferredLightDownsampleDepthSampler, texcoord.xy);
	r0.y = r0.x * 0.004;
	r0.x = r0.x + -237.5;
	o.xyz = (r0.xxx >= 0) ? r0.yyy : 0;
	o.w = 1;

	return o;
}
