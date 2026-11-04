sampler2D SeamTextureSampler : register(s2);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(SeamTextureSampler, texcoord.xy);
	o.xyw = r0.zzz;
	o.z = 0.5;

	return o;
}
