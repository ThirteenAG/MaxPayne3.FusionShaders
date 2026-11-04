sampler2D GBufferTextureSamplerDepth : register(s10);
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
	r0.x = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = 1 / r0.x;
	r0.y = frac(r0.x);
	r1.x = -r0.y + r0.x;
	r0.x = r0.x + -r1.x;
	r0.x = r0.x * 255;
	r0.y = frac(r0.x);
	r1.y = -r0.y + r0.x;
	r0.xy = r1.xy * 0.003921569;
	r0.x = dot(r0.xy, float2(255, 1)) + 0;
	r0.yz = -globalScreenSize.zw + texcoord.xy;
	r1 = tex2D(gDeferredLightSampler1, r0.yz);
	r2.x = dot(r1.yz, float2(255, 1)) + 0;
	r0.yz = globalScreenSize.zw + texcoord.xy;
	r3 = tex2D(gDeferredLightSampler1, r0.yz);
	r2.w = dot(r3.yz, float2(255, 1)) + 0;
	r0.zw = globalScreenSize.zw;
	r4 = r0.zwzw * float4(1, -1, -1, 1) + texcoord.xyxy;
	r5 = tex2D(gDeferredLightSampler1, r4.xy);
	r4 = tex2D(gDeferredLightSampler1, r4.zw);
	r2.y = dot(r5.yz, float2(255, 1)) + 0;
	r2.z = dot(r4.yz, float2(255, 1)) + 0;
	r0 = -r0.x + r2;
	r0 = abs(r0) * 28.8539;
	r0.y = exp2(r0.y);
	r0.y = 1 / r0.y;
	r1.y = r5.x * r0.y;
	r0.x = exp2(r0.x);
	r0.x = 1 / r0.x;
	r1.x = r0.x * r1.x + r1.y;
	r0.x = r0.y + r0.x;
	r0.y = exp2(r0.z);
	r0.z = exp2(r0.w);
	r0.z = 1 / r0.z;
	r0.y = 1 / r0.y;
	r0.w = r0.y * r4.x + r1.x;
	r0.x = r0.y + r0.x;
	r0.x = r0.z + r0.x;
	r0.y = r0.z * r3.x + r0.w;
	r0.x = 1 / r0.x;
	r0.x = r0.y * r0.x + -1;
	r0.z = 1;
	r0.x = gAmbientOcclusionEffect.x * r0.x + r0.z;
	r1 = tex2D(gDeferredLightSampler2, texcoord.xy);
	o.z = r0.x * r1.w;
	o.xyw = 0;

	return o;
}
