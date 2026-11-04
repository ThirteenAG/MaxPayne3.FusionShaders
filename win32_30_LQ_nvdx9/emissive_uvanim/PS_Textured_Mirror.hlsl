sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float emissiveMultiplier : register(c198);
float emissiveReflectMultiplier : register(c199);
float3 globalAnimUV0 : register(c196);
float3 globalAnimUV1 : register(c197);
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
	float2 r2;
	r0.x = 1;
	r0.x = r0.x + -globalScalars.x;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = r1.w * i.color.w;
	r0.x = r0.x * r0.y + -1;
	r0.x = 1 / r0.x;
	r0.z = r0.x * -globalScalars.x;
	r0.x = -globalScalars.x * -r0.x + globalScalars.x;
	r0.x = globalScalars.y * r0.x + r0.z;
	r0.w = r0.x * r0.y;
	r1.xyz = i.texcoord.xyx * float3(1, 1, 0) + float3(0, 0, 1);
	r2.x = dot(globalAnimUV0.xyz, r1.xyz);
	r2.y = dot(globalAnimUV1.xyz, r1.xyz);
	r1 = tex2D(DiffuseSampler, r2.xy);
	r1.xyz = r1.xyz * i.color.xyz;
	r0.xyz = r1.xyz * emissiveMultiplier.xxx;
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
