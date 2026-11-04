sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDeferredLightColourAndIntensity : register(c214);
float gDeferredLightConeOffset : register(c212);
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
	float4 r2;
	float4 r3;
	float3 r4;
	r0.xyz = gDeferredLightTangent.xyz;
	r1.xyz = r0.xyz + gDeferredLightDirection.xyz;
	r2.xyz = r1.xyz * -0.5 + r0.xyz;
	r0.w = dot(r2.xyz, r2.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r0.w = r0.w + gDeferredLightConeOffset.x;
	r0.w = 1 / r0.w;
	r0.w = r0.w * gDeferredLightConeOffset.x;
	r2.xy = 0.51 + i.vpos.xy;
	r2.xy = r2.xy * gooDeferredLightScreenSize.zw;
	r3 = tex2D(GBufferTextureSamplerDepth, r2.xy);
	r2 = tex2D(GBufferTextureSampler1, r2.xy);
	r2.xyz = r2.xyz * 2 + -1;
	r4 = normalize(r2.xyz);
	r1.w = r3.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r1.w = r1.w * i.texcoord.w;
	r1.w = 1 / r1.w;
	r2.xyz = i.texcoord.xyz * -r1.www + gViewInverse[3].xyz;
	r1.xyz = r1.xyz * -0.5 + r2.xyz;
	r0.xyz = r0.xyz + -gDeferredLightDirection.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2.xyz = normalize(r0.xyz);
	r0.x = dot(r1.xyz, r2.xyz);
	r0.x = r0.x * r0.w + -r0.x;
	r0.xyz = r2.xyz * r0.xxx + r1.xyz;
	r0.w = dot(r4.xyz, -r0.xyz);
	r0.x = dot(-r0.xyz, -r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.y = saturate(r4.z * 4);
	r0.z = saturate(r0.x * r0.w);
	r0.x = 1 / r0.x;
	r0.z = r0.z * r0.z;
	r0.w = 1 / gDeferredLightConeOffset.x;
	r0.x = saturate(r0.x * -r0.w + 1);
	r0.x = r0.z * r0.x;
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	r0.x = r0.y * r0.x;
	o.w = r0.x * gAmbientOcclusionEffect.x;
	o.xyz = 0;

	return o;
}
