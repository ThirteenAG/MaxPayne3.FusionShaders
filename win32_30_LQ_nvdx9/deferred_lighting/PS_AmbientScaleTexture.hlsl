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
	float3 r2;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0 = tex2D(GBufferTextureSampler1, r0.xy);
	r0.xyz = r0.xyz * 2 + -1;
	r2 = normalize(r0.xyz);
	r0.x = dot(gDeferredLightDirection.xyz, r2.xyz);
	r0.yzw = r1.wxy * 255 + 0.5;
	r1.xyz = frac(r0.yzw);
	r0.yzw = r0.yzw + -r1.xyz;
	r0.y = dot(r0.yzw, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	r0.y = r0.y * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.y = r0.y * i.texcoord.w;
	r0.y = 1 / r0.y;
	r0.yzw = i.texcoord.xyz * -r0.yyy + gViewInverse[3].xyz;
	r0.yzw = -r0.yzw + gDeferredLightPosition.xyz;
	r1.xyz = gDeferredLightDirection.xyz;
	r2 = r1.zxy * gDeferredLightTangent.yzx;
	r1.xyz = r1.yzx * gDeferredLightTangent.zxy + -r2.xyz;
	r1.x = dot(r1.xyz, r0.yzw);
	r1.w = 2.2;
	r1.y = r1.w * gDeferredLightConeOffset.x;
	r1.y = 1 / r1.y;
	r1.x = r1.y * r1.x;
	r1.z = dot(gDeferredLightTangent.xyz, r0.yzw);
	r0.y = dot(-gDeferredLightDirection.xyz, r0.yzw);
	r0.w = 1.8;
	r0.z = r0.w * gDeferredLightConeScale.x;
	r0.z = 1 / r0.z;
	r1.y = r0.z * r1.z;
	r1.xy = r1.xy * 0.5 + 0.5;
	r1.zw = 0;
	r1 = tex2Dlod(gDeferredLightSampler, r1);
	r0.z = (r0.y >= 0) ? 0 : 1;
	r0.w = (-r0.y >= 0) ? -0 : -1;
	r0.y = r0.y + -gDeferredLightRadiusProjShearParams.x;
	r0.z = r0.w + r0.z;
	r0.x = saturate(r0.x * r0.z);
	r0.x = r0.x * r0.x;
	r0.x = r0.x * r1.x;
	r0.z = gDeferredLightRadiusProjShearParams.x + gDeferredLightRadiusProjShearParams.x;
	r0.z = 1 / r0.z;
	r0.y = saturate(r0.y * -r0.z + 1);
	r0.y = r0.y * r0.y;
	r0.x = r0.y * r0.x;
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	o.w = gAmbientOcclusionEffect.x * r0.x + r0.x;
	o.xyz = 0;

	return o;
}
