sampler2D DiffuseSampler : register(s0);
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
	r0 = abs(r0) + 1E-05;
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r1.w = log2(r0.w);
	r0 = r1 * 2.20001;
	r0.w = exp2(r0.w);
	r0.w = r0.w * i.color.w;
	o.w = r0.w * globalScalars.x;
	r1.x = exp2(r0.x);
	r1.y = exp2(r0.y);
	r1.z = exp2(r0.z);
	r0.xyz = r1.xyz * i.color.xyz;
	r0.xyz = r0.xyz * emissiveMultiplier.xxx;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

	return o;
}
