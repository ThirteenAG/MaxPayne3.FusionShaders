sampler2D DepthMapPointSampler : register(s3);

struct PS_OUT
{
	float4 color : COLOR;
	float depth : DEPTH;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	o.color = float4(1, 0, 0, 1);
	r0 = tex2D(DepthMapPointSampler, texcoord.xy);
	o.depth = r0.x;

	return o;
}
