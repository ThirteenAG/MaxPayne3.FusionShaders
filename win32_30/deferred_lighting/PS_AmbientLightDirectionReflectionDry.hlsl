sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D GBufferTextureSamplerDepth : register(s10);
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
	float3 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r1 = tex2D(materialIdSampler, r1.ww);
	r0.z = -r1.z + 1;
	r1.xyz = r0.zzz * gDirectionalColour.xyz;
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r2.xyz = r2.xyz * 2 + -1;
	r3 = normalize(r2.xyz);
	r0.z = dot(r3.xyz, -gDirectionalLight.xyz);
	r0.w = saturate(r0.z + -0.25);
	r0.z = saturate(r0.z * 2 + -0.5);
	r0.w = r0.w * 1.3333334;
	r2.xyz = r0.www * r1.xyz;
	r0.w = dot(gLightAmbientDir1.xyz, r3.xyz);
	r0.w = saturate(r0.w + gLightAmbientDir0.w);
	r4.xyz = r0.www * gLightAmbient1.xyz;
	r0.w = dot(gLightAmbientDir0.xyz, r3.xyz);
	r0.w = saturate(r0.w + gLightAmbientDir0.w);
	r4.xyz = r0.www * gLightAmbient0.xyz + r4.xyz;
	r5 = tex2D(GBufferTextureSampler2, r0.xy);
	r4.xyz = r4.xyz * r5.zzz;
	r0.w = rsqrt(r5.z);
	r0.w = 1 / r0.w;
	r2.xyz = r2.xyz * r0.www + r4.xyz;
	r0.w = dot(r2.xyz, 0.33333334);
	r0.w = r0.w + 0.015;
	r4 = tex2D(gDeferredLightSampler0P, r0.xy);
	r4.xyz = r4.xyz * r4.xyz;
	r4.xyz = r4.xyz * 16;
	r4.xyz = r0.www * r4.xyz;
	r6 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r7 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyw = r7.xyz * r7.xyz;
	r1.w = r6.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r1.w = r1.w * i.texcoord1.w;
	r1.w = 1 / r1.w;
	r6.xyz = i.texcoord1.xyz * -r1.www + 1E-05;
	r7.xyz = normalize(r6.xyz);
	r1.w = dot(r7.xyz, r3.xyz);
	r1.w = r1.w + r1.w;
	r3 = r3.xyz * -r1.www + r7.xyz;
	r1.w = saturate(dot(-gDirectionalLight.xyz, r3.xyz));
	r1.w = r1.w + 1E-05;
	r2.w = r5.y * r5.y;
	r2.w = r2.w * r2.w;
	r2.w = r2.w * 196 + 1E-05;
	r3.x = pow(r1.w, r2.w);
	r0.z = r0.z * r3.x;
	r1.xyz = r0.zzz * r1.xyz;
	r1.xyz = r1.xyz * r5.xxx + r4.xyz;
	o.xyz = r0.xyw * r2.xyz + r1.xyz;
	o.w = 1;

	return o;
}
