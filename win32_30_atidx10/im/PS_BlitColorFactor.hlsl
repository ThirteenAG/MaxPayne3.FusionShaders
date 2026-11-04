sampler2D DiffuseSampler : register(s1);
float GammaCorrection : register(c201);

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
	r0.xyz = r0.xyz * i.color.xyz;
	o.xyz = r0.xyz * GammaCorrection.xxx;
	o.w = i.color.w;

	return o;
}
