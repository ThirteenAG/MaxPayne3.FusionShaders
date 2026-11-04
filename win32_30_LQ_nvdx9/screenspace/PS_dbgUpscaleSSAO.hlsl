sampler2D GBufferTextureSamplerDepth : register(s10);
sampler2D deferredLightDownsampleDepthSampler : register(s12);
float4 gAmbientOcclusionEffect : register(c63);
sampler2D gDeferredLightSampler1 : register(s1);
sampler2D gDeferredLightSampler2 : register(s2);
float4 gDeferredProjParams : register(c119);
float4 globalScreenSize : register(c41);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0 = tex2D(GBufferTextureSamplerDepth, texcoord.xy);
	r0.xyz = r0.wxy * 255 + 0.5;
	r1.xyz = frac(r0.xyz);
	r0.xyz = r0.xyz + -r1.xyz;
	r0.x = dot(r0.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	r0.x = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = 1 / r0.x;
	r1.x = 1 / globalScreenSize.x;
	r1.y = 1 / globalScreenSize.y;
	r0.yz = -r1.xy + texcoord.xy;
	r2 = tex2D(deferredLightDownsampleDepthSampler, r0.yz);
	r3 = tex2D(gDeferredLightSampler1, r0.yz);
	r0.yz = r1.xy + texcoord.xy;
	r1 = r1.xyxy * float4(1, -1, -1, 1) + texcoord.xyxy;
	r4 = tex2D(deferredLightDownsampleDepthSampler, r0.yz);
	r5 = tex2D(gDeferredLightSampler1, r0.yz);
	r2.w = r4.x;
	r4 = tex2D(deferredLightDownsampleDepthSampler, r1.xy);
	r2.y = r4.x;
	r4 = tex2D(deferredLightDownsampleDepthSampler, r1.zw);
	r2.z = r4.x;
	r0 = -r0.x + r2;
	r0 = abs(r0) * 28.8539;
	r0.y = exp2(r0.y);
	r0.y = 1 / r0.y;
	r2 = tex2D(gDeferredLightSampler1, r1.xy);
	r1 = tex2D(gDeferredLightSampler1, r1.zw);
	r1.y = r0.y * r2.x;
	r0.x = exp2(r0.x);
	r0.x = 1 / r0.x;
	r1.y = r0.x * r3.x + r1.y;
	r0.x = r0.y + r0.x;
	r0.y = exp2(r0.z);
	r0.z = exp2(r0.w);
	r0.z = 1 / r0.z;
	r0.y = 1 / r0.y;
	r0.w = r0.y * r1.x + r1.y;
	r0.x = r0.y + r0.x;
	r0.x = r0.z + r0.x;
	r0.y = r0.z * r5.x + r0.w;
	r0.x = 1 / r0.x;
	r0.x = r0.y * r0.x + -1;
	r0.z = 1;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.z;
	r1 = tex2D(gDeferredLightSampler2, texcoord.xy);
	o.z = r0.x * r1.w;
	o.xyw = 0;

	return o;
}
