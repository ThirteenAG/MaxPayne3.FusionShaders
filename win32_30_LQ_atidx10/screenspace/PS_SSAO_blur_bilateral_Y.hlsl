sampler2D deferredLightDownsampleDepthSampler : register(s12);
sampler2D gDeferredLightSampler1 : register(s1);
float g_fSSAOBilateralCoef : register(c122);
float4 globalScreenSize : register(c41);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0 = tex2D(deferredLightDownsampleDepthSampler, texcoord.xy);
	r1.x = 1 / globalScreenSize.x;
	r1.y = 1 / globalScreenSize.y;
	r2 = r1.xyxy * float4(0, -4, 0, -2) + texcoord.xyxy;
	r1 = r1.xyxy * float4(0, 2, 0, 4) + texcoord.xyxy;
	r3 = tex2D(deferredLightDownsampleDepthSampler, r2.xy);
	r4 = tex2D(deferredLightDownsampleDepthSampler, r2.zw);
	r3.y = r4.x;
	r4 = tex2D(deferredLightDownsampleDepthSampler, r1.xy);
	r3.z = r4.x;
	r4 = tex2D(deferredLightDownsampleDepthSampler, r1.zw);
	r3.w = r4.x;
	r0 = -r0.x + r3;
	r3.x = 1 / g_fSSAOBilateralCoef.x;
	r0 = r0 * r3.x;
	r0 = abs(r0) * abs(r0);
	r0 = r0 * -0.7213475;
	r3.x = exp2(r0.x);
	r3.y = exp2(r0.y);
	r3.z = exp2(r0.z);
	r3.w = exp2(r0.w);
	r0 = r3 * float4(0.5, 0.75, 0.75, 0.5);
	r3 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r3.y = r2.x;
	r2 = tex2D(gDeferredLightSampler1, r1.xy);
	r1 = tex2D(gDeferredLightSampler1, r1.zw);
	r3.w = r1.x;
	r3.z = r2.x;
	r1.x = dot(r3, r0);
	r0.x = dot(1, r0);
	r0.x = r0.x + 1;
	r0.x = 1 / r0.x;
	r2 = tex2D(gDeferredLightSampler1, texcoord.xy);
	r0.y = r1.x + r2.x;
	o = r0.x * r0.y;

	return o;
}
