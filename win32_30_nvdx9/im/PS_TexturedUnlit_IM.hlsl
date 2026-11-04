sampler2D DiffuseSampler : register(s1);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	o = r0 * globalScalars.yyyx;

	return o;
}
