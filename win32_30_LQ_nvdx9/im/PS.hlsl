sampler2D RenderMapPointSampler : register(s1);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(RenderMapPointSampler, i.texcoord.xy);
	o.xyz = r0.xyz * i.color.xyz;
	o.w = i.color.w;

	return o;
}
