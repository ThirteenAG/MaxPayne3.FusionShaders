sampler2D depthSourceSampler : register(s13);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_OUT
{
	float depth : DEPTH;
	float4 color : COLOR;
};

PS_OUT main(float2 vpos : VPOS)
{
	PS_OUT o;

	float4 r0;
	float3 r1;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r0 = tex2D(depthSourceSampler, r0.xy);
	r0.xyz = r0.wxy * 255 + 0.5;
	r1 = frac(r0.xyz);
	r0.xyz = r0.xyz + -r1.xyz;
	o.depth = dot(r0.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	o.color = float4(0, 0, 0, 1);

	return o;
}
