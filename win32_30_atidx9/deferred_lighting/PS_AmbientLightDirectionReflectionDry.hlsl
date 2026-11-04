sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gAmbientOcclusionEffect : register(c63);
sampler2D gDeferredLightSampler0P : register(s3);
float4 gDeferredProjParams : register(c216);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gLightAmbientDir0 : register(c72);
float4 gLightAmbientDir1 : register(c73);
float4 gooDeferredLightScreenSize : register(c215);
sampler2D materialIdSampler : register(s9);

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
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
	float4 r5;
	float4 r6;
	float3 r7;
	r0.x = 1 / gAmbientOcclusionEffect.y;
	r0.yz = 0.51 + i.vpos.xy;
	r0.yz = r0.yz * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSampler1, r0.yz);
	r1.xyz = r1.xyz * 2 + -1;
	r2.xyz = normalize(r1.xyz);
	r0.w = dot(gLightAmbientDir1.xyz, r2.xyz);
	r0.w = r0.w + gLightAmbientDir0.w;
	r0.w = saturate(r0.w * gLightAmbientDir1.w);
	r1.xyz = r0.www * gLightAmbient1.xyz;
	r3 = tex2D(GBufferTextureSampler2, r0.yz);
	r1.xyz = r1.xyz * r3.zzz;
	r1.xyz = r0.xxx * r1.xyz;
	r0.w = dot(gLightAmbientDir0.xyz, r2.xyz);
	r0.w = r0.w + gLightAmbientDir0.w;
	r0.w = saturate(r0.w * gLightAmbientDir1.w);
	r4 = r0.www * gLightAmbient0.xyz;
	r4 = r3.zzz * r4.xyz;
	r1.xyz = r4.xyz * r0.xxx + r1.xyz;
	r0.x = dot(r2.xyz, -gDirectionalLight.xyz);
	r0.w = saturate(r0.x + -0.25);
	r0.x = saturate(r0.x * 2 + -0.5);
	r0.w = r0.w * 1.3333334;
	r4 = gDirectionalColour.www * gDirectionalColour.xyz;
	r5.xyz = r0.www * r4.xyz;
	r0.w = rsqrt(r3.z);
	r0.w = 1 / r0.w;
	r1.xyz = r5.xyz * r0.www + r1.xyz;
	r0.w = dot(r1.xyz, 0.33333334);
	r5 = tex2D(gDeferredLightSampler0P, r0.yz);
	r5.xyz = r5.xyz * r5.xyz;
	r5.xyz = r5.xyz * 16;
	r5.xyz = r0.www * r5.xyz;
	r6 = tex2D(GBufferTextureSamplerDepth, r0.yz);
	r0.w = r6.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.w = r0.w * i.texcoord1.w;
	r0.w = 1 / r0.w;
	r6.xyz = i.texcoord1.xyz * -r0.www + 1E-05;
	r7 = normalize(r6.xyz);
	r0.w = dot(r7.xyz, r2.xyz);
	r0.w = r0.w + r0.w;
	r2.xyz = r2.xyz * -r0.www + r7.xyz;
	r0.w = saturate(dot(-gDirectionalLight.xyz, r2.xyz));
	r0.w = r0.w + 1E-05;
	r2 = tex2D(GBufferStencilTextureSampler, r0.yz);
	r6 = tex2D(GBufferTextureSampler0, r0.yz);
	r2.xyz = r6.xyz * r6.xyz;
	r6 = tex2D(materialIdSampler, r2.ww);
	r0.y = r6.w * -132 + 196;
	r0.z = r3.y * r3.y;
	r0.y = r0.z * r0.y + 1E-05;
	r1.w = pow(r0.w, r0.y);
	r0.x = r0.x * r1.w;
	r0.xyz = r0.xxx * r4.xyz;
	r0.xyz = r0.xyz * r3.xxx + r5.xyz;
	o.xyz = r2.xyz * r1.xyz + r0.xyz;
	o.w = 1;

	return o;
}
