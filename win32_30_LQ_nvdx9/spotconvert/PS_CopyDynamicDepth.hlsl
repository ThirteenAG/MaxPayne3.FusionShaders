sampler2D ConvertSampler : register(s0);

struct PS_OUT
{
	float4 color : COLOR;
	float depth : DEPTH;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	r0 = tex2D(ConvertSampler, texcoord.xy);
	o.color = r0.y;
	o.depth = r0.y;

	return o;
}
