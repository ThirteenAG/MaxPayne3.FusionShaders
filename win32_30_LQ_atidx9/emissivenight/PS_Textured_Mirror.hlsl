sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float emissiveMultiplier : register(c198);
float emissiveReflectMultiplier : register(c199);
float4 globalDayNightEffects : register(c42);
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
	r0.x = emissiveMultiplier.x;
	r0.x = r0.x * globalDayNightEffects.w;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	r0.xyz = r0.xxx * r1.xyz;
	r0.w = r1.w * globalScalars.x;
	r0 = r0 * colorize;
	r0.xyz = r0.xyz * emissiveReflectMultiplier.xxx;
	o.w = r0.w;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

	return o;
}
