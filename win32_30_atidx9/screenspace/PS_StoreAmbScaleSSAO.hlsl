sampler2D GBufferTextureSampler2 : register(s13);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	r0.xy = 0.5 + vpos.xy;
	r0.xy = r0.xy * globalScreenSize.zw;
	r0 = tex2D(GBufferTextureSampler2, r0.xy);
	o = r0.z * float4(0, 0, 0, 1);

	return o;
}
