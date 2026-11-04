sampler2D SmartBlitSampler : register(s1);
float4 clearcol : register(c196);

struct PS_OUT
{
	float4 color : COLOR;
	float depth : DEPTH;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	r0 = tex2D(SmartBlitSampler, texcoord.xy);
	r1 = saturate(r0);
	o.color = r0;
	o.depth = dot(r1, clearcol);

	return o;
}
