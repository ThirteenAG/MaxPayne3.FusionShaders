sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDeferredLightColourAndIntensity : register(c214);
float4 gDeferredProjParams : register(c216);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 vpos : VPOS;
	float4 texcoord1 : TEXCOORD1;
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
	r0.x = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = r0.x * i.texcoord.w;
	r0.x = 1 / r0.x;
	r0.xyz = i.texcoord.xyz * -r0.xxx + gViewInverse[3].xyz;
	r0.xyz = -r0.xyz + i.texcoord2.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.x = r0.w * i.texcoord1.y;
	r0.x = saturate(r0.x * -3 + 1);
	r0.x = r0.x * gAmbientOcclusionEffect.y;
	r0.y = saturate(r2.z * -0.5 + 0.5);
	r0.z = dot(r1.xyz, r2.xyz);
	r0.w = dot(r1.xyz, i.texcoord3.xyz);
	r0.w = saturate(r0.w * i.texcoord1.w + i.texcoord1.z);
	r1.w = gLightAmbient1.w;
	r0.y = r0.y * r1.w + gLightAmbient0.w;
	r1.x = -r0.y + 8;
	r0.y = 1 / r0.y;
	r0.y = (r1.x >= 0) ? 0.125 : r0.y;
	r0.x = r0.y * r0.x;
	r0.x = r0.w * r0.x;
	r0.x = r0.x * gDeferredLightColourAndIntensity.w;
	r0.y = r0.z + 0.5;
	r0.z = saturate(r0.z);
	r0.y = saturate(r0.y * 0.25);
	r0.y = r0.z + r0.y;
	o.w = r0.y * r0.x;
	o.xyz = 1;

	return o;
}
