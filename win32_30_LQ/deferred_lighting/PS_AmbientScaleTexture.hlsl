sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDeferredLightColourAndIntensity : register(c214);
float gDeferredLightConeOffset : register(c212);
float gDeferredLightConeScale : register(c213);
float3 gDeferredLightDirection : register(c204);
float3 gDeferredLightPosition : register(c203);
float4 gDeferredLightRadiusProjShearParams : register(c206);
sampler2D gDeferredLightSampler : register(s0);
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
	float4 r2;
	float3 r3;
	r0.xyz = gDeferredLightDirection.xyz;
	r1.xyz = r0.zxy * gDeferredLightTangent.yzx;
	r0.xyz = r0.yzx * gDeferredLightTangent.zxy + -r1.xyz;
	r1.xy = 0.51 + i.vpos.xy;
	r1.xy = r1.xy * gooDeferredLightScreenSize.zw;
	r2 = tex2D(GBufferTextureSamplerDepth, r1.xy);
	r1 = tex2D(GBufferTextureSampler1, r1.xy);
	r1.xyz = r1.xyz * 2 + -1;
	r3 = normalize(r1.xyz);
	r0.w = dot(gDeferredLightDirection.xyz, r3.xyz);
	r1.x = r2.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.xyz = i.texcoord.xyz * -r1.xxx + gViewInverse[3].xyz;
	r1.xyz = -r1.xyz + gDeferredLightPosition.xyz;
	r0.x = dot(r0.xyz, r1.xyz);
	r1.w = 2.2;
	r0.y = r1.w * gDeferredLightConeOffset.x;
	r0.y = 1 / r0.y;
	r0.x = r0.y * r0.x;
	r0.z = dot(gDeferredLightTangent.xyz, r1.xyz);
	r1.x = dot(-gDeferredLightDirection.xyz, r1.xyz);
	r2.xzw = float3(1.8, 0, 0);
	r1.y = r2.x * gDeferredLightConeScale.x;
	r1.y = 1 / r1.y;
	r0.y = r0.z * r1.y;
	r2.xy = r0.xy * 0.5 + 0.5;
	r2 = tex2Dlod(gDeferredLightSampler, r2);
	r0.x = (r1.x >= 0) ? 0 : 1;
	r0.y = (-r1.x >= 0) ? -0 : -1;
	r0.z = r1.x + -gDeferredLightRadiusProjShearParams.x;
	r0.x = r0.y + r0.x;
	r0.x = saturate(r0.w * r0.x);
	r0.x = r0.x * r0.x;
	r0.x = r0.x * r2.x;
	r0.y = gDeferredLightRadiusProjShearParams.x + gDeferredLightRadiusProjShearParams.x;
	r0.y = 1 / r0.y;
	r0.y = saturate(r0.z * -r0.y + 1);
	r0.y = r0.y * r0.y;
	r0.x = r0.y * r0.x;
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	o.w = gAmbientOcclusionEffect.x * r0.x + r0.x;
	o.xyz = 0;

	return o;
}
