sampler2D gDeferredLightSampler1 : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(gDeferredLightSampler1, texcoord.xy);
	r0.x = dot(r0.yzw, float3(255, 1, 0.003921569));
	r0.y = r0.x * 0.004;
	r0.x = r0.x + -237.5;
	o.xyz = (r0.xxx >= 0) ? r0.yyy : 0;
	o.w = 1;

	return o;
}
