sampler2D DiffuseSampler : register(s0);
sampler2D SeamTextureSampler : register(s2);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(SeamTextureSampler, texcoord.xy);
	r0.x = saturate(r0.z);
	r1 = tex2D(DiffuseSampler, texcoord.xy);
	o.w = r0.x * r1.w;
	o.xyz = r1.xyz;

	return o;
}
