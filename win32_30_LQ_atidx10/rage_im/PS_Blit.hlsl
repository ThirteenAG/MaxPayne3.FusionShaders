sampler2D TextureSampler : register(s0);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(TextureSampler, i.texcoord.xy);
	o = r0 * i.color;

	return o;
}
