sampler2D depthSourceSampler : register(s13);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_OUT
{
	float4 color : COLOR;
	float depth : DEPTH;
};

PS_OUT main(float2 vpos : VPOS)
{
	PS_OUT o;

	float4 r0;
	o.color = float4(0, 0, 0, 1);
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r0 = tex2D(depthSourceSampler, r0.xy);
	o.depth = r0.x;

	return o;
}
