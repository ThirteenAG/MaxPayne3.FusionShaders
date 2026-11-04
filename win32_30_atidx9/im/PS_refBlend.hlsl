sampler2D DiffuseSampler : register(s1);
float4 refMipBlurParams : register(c200);

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	r0 = tex2D(DiffuseSampler, texcoord.xy);
	r0.w = refMipBlurParams.w;
	o.color = r0;
	o.color1 = r0;

	return o;
}
