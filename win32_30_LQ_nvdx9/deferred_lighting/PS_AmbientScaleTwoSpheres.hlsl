sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDeferredLightColourAndIntensity : register(c214);
float gDeferredLightConeOffset : register(c212);
float gDeferredLightConeScale : register(c213);
float3 gDeferredLightDirection : register(c204);
float3 gDeferredLightTangent : register(c205);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0 = tex2D(GBufferTextureSampler1, r0.xy);
	r0.xyz = r0.xyz * 2 + -1;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.wxy * 255 + 0.5;
	r1.xyz = frac(r0.xyz);
	r0.xyz = r0.xyz + -r1.xyz;
	r0.x = dot(r0.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	r0.x = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = r0.x * i.texcoord.w;
	r0.x = 1 / r0.x;
	r0.xyz = i.texcoord.xyz * -r0.xxx + gViewInverse[3].xyz;
	r1.xyz = -r0.xyz + gDeferredLightDirection.xyz;
	r0.xyz = -r0.xyz + gDeferredLightTangent.xyz;
	r0.w = dot(r2.xyz, r1.xyz);
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r0.w = saturate(r0.w * r1.x);
	r1.x = 1 / r1.x;
	r0.w = r0.w * r0.w;
	r1.y = 1 / gDeferredLightConeOffset.x;
	r1.x = saturate(r1.x * -r1.y + 1);
	r0.w = r0.w * r1.x;
	r1.w = 1;
	r0.w = r0.w * -gDeferredLightColourAndIntensity.w + r1.w;
	r1.x = dot(r2.xyz, r0.xyz);
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.y = saturate(r2.z * 4);
	r0.z = saturate(r0.x * r1.x);
	r0.x = 1 / r0.x;
	r0.z = r0.z * r0.z;
	r1.x = 1 / gDeferredLightConeScale.x;
	r0.x = saturate(r0.x * -r1.x + 1);
	r0.x = r0.z * r0.x;
	r0.x = r0.x * -gDeferredLightColourAndIntensity.w + r1.w;
	r0.x = r0.w * -r0.x + 1;
	r0.x = r0.y * r0.x;
	o.w = r0.x * gAmbientOcclusionEffect.x;
	o.xyz = 0;

	return o;
}
