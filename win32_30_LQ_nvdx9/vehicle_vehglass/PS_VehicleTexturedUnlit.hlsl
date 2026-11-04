sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s3);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float4 globalScalars : register(c35);
float3 matDiffuseColor : register(c197);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.w = r0.w * globalScalars.x;
	r2.x = dirtLevel.x;
	if (-r2.x < 0) {
		r2 = tex2D(DirtSampler, i.texcoord1.xy);
		r2.y = r2.x * dirtLevel.x;
		r3.xyz = lerp(r0.xyz, dirtColor.xyz, r2.yyy);
		r3.w = r0.w * globalScalars.x + r2.x;
		r1.xyz = r0.xyz;
		o = (-r2.x >= 0) ? r1 : r3;
	} else {
		o.xyz = r0.xyz;
		o.w = r1.w;
	}

	return o;
}
