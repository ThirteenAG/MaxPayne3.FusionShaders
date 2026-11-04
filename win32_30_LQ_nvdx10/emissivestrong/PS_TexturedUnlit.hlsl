sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float emissiveMultiplier : register(c198);
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
	float4 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	r1.xyz = r0.xyz * emissiveMultiplier.xxx;
	r1.w = r0.w * globalScalars.x;
	o = r1 * colorize;

	return o;
}
