sampler2D DiffuseSampler : register(s1);
float4 refMipBlurParams : register(c203);

half4 main(float2 texcoord : TEXCOORD) : COLOR
{
	half4 o;

	half4 r0;
	r0 = tex2D(DiffuseSampler, texcoord.xy);
	o.xyz = r0.xyz;
	o.w = refMipBlurParams.w;

	return o;
}
