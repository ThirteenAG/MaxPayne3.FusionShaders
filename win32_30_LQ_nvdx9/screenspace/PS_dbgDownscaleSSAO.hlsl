sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gDeferredProjParams : register(c119);
float4 globalScreenSize : register(c41);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	r0.xy = vpos.xy + vpos.xy;
	r1.x = 1 / globalScreenSize.x;
	r1.y = 1 / globalScreenSize.y;
	r0.zw = r1.xy * 0.5;
	r0.xy = r0.xy * r1.xy + r0.zw;
	r0 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.xyz = r0.wxy * 255 + 0.5;
	r1 = frac(r0.xyz);
	r0.xyz = r0.xyz + -r1.xyz;
	r0.x = dot(r0.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	r0.x = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	o = 1 / r0.x;

	return o;
}
