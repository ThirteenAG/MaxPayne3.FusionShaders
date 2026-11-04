sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
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
	r0.w = r0.w * globalScalars.x;
	o = r0 * colorize;

	return o;
}
