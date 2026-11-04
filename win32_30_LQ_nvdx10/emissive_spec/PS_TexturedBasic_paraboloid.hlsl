sampler2D DiffuseSampler : register(s0);
float emissiveMultiplier : register(c198);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = -512 + -i.texcoord3.z;
	clip(r0);
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = abs(r0) + 1E-05;
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r1.w = log2(r0.w);
	r0 = r1 * 2.20001;
	r1.x = exp2(r0.x);
	r1.y = exp2(r0.y);
	r1.z = exp2(r0.z);
	r0.x = exp2(r0.w);
	r0.x = r0.x * i.color.w;
	r0.x = r0.x * globalScalars.x;
	r0.yzw = r1.xyz * i.color.xyz;
	r0.yzw = r0.yzw * emissiveMultiplier.xxx;
	r0.yzw = saturate(r0.yzw * 0.0625);
	r0.y = rsqrt(r0.y);
	o.x = 1 / r0.y;
	r0.y = rsqrt(r0.z);
	r0.z = rsqrt(r0.w);
	o.z = 1 / r0.z;
	o.y = 1 / r0.y;
	r0.y = 64 + -i.texcoord1.w;
	r0.y = saturate(r0.y * 0.25);
	o.w = r0.y * r0.x;

	return o;
}
