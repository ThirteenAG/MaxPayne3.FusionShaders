sampler2D GBufferTextureSampler2 : register(s13);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float2 r1;
	r0.xy = 0.5 + vpos.xy;
	r1.x = 1 / globalScreenSize.x;
	r1.y = 1 / globalScreenSize.y;
	r0.xy = r0.xy * r1.xy;
	r0 = tex2D(GBufferTextureSampler2, r0.xy);
	o = r0.z * float4(0, 0, 0, 1);

	return o;
}
