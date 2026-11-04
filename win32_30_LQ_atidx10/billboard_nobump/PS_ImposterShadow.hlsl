sampler2D blitSampler : register(s2);
sampler2D imposterSampler : register(s1);

float4 main(float4 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0.xy = texcoord.zz * texcoord.xy;
	r0 = tex2D(blitSampler, r0.xy);
	r0.xy = r0.ww * texcoord.ww + texcoord.xy;
	r0 = tex2D(imposterSampler, r0.xy);
	r0.x = dot(r0, 1);
	r0 = (-abs(r0.x) >= 0) ? -1 : -0;
	clip(r0);
	o = 1;

	return o;
}
