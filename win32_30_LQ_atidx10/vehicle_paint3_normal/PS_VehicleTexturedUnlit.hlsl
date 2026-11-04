sampler2D DiffuseSampler : register(s0);
sampler2D DiffuseSampler2 : register(s2);
sampler2D DirtSampler : register(s3);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float4 globalScalars : register(c35);
float3 matDiffuseColor : register(c197);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = r0.xyz * matDiffuseColor.xyz;
	r2 = tex2D(DiffuseSampler2, i.texcoord.zw);
	r0.xyz = lerp(r1.xyz, r2.xyz, r2.www);
	r0 = r0 * i.texcoord2;
	o.w = r0.w * globalScalars.x;
	r1.x = dirtLevel.x;
	if (-r1.x < 0) {
		r1 = tex2D(DirtSampler, i.texcoord.xy);
		r0.w = r1.x * dirtLevel.x;
		r1.yzw = lerp(r0.xyz, dirtColor.xyz, r0.www);
		o.xyz = (-r1.xxx >= 0) ? r0.xyz : r1.yzw;
	} else {
		o.xyz = r0.xyz;
	}

	return o;
}
