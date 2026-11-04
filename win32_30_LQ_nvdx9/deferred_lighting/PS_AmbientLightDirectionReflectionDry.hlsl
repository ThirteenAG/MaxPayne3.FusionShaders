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
	float4 r3;
	float3 r4;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r1.xyz = r1.wxy * 255 + 0.5;
	r2.xyz = frac(r1.xyz);
	r1.xyz = r1.xyz + -r2.xyz;
	r0.z = dot(r1.xyz, float3(0.0039062505, 1.525879E-05, 5.960465E-08));
	r0.z = r0.z * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord1.w;
	r0.z = 1 / r0.z;
	r1.xyz = i.texcoord1.xyz * -r0.zzz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	r1 = tex2D(GBufferTextureSampler1, r0.xy);
	r1.xyz = r1.xyz * 2 + -1;
	r3.xyz = normalize(r1.xyz);
	r0.z = dot(r2.xyz, r3.xyz);
	r0.z = r0.z + r0.z;
	r1.xyz = r3.xyz * -r0.zzz + r2.xyz;
	r0.z = saturate(dot(-gDirectionalLight.xyz, r1.xyz));
	r0.z = r0.z + 1E-05;
	r1 = tex2D(GBufferTextureSampler2, r0.xy);
	r0.w = r1.y * r1.y;
	r0.w = r0.w * r0.w;
	r0.w = r0.w * 196 + 1E-05;
	r1.y = pow(r0.z, r0.w);
	r0.z = dot(r3.xyz, -gDirectionalLight.xyz);
	r0.w = saturate(r0.z * 2 + -0.5);
	r0.z = saturate(r0.z + -0.25);
	r0.z = r0.z * 1.3333334;
	r0.w = r0.w * r1.y;
	r2 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r2 = tex2D(materialIdSampler, r2.ww);
	r1.y = -r2.z + 1;
	r2.xyz = r1.yyy * gDirectionalColour.xyz;
	r4 = r0.www * r2.xyz;
	r2.xyz = r0.zzz * r2.xyz;
	r0.z = dot(gLightAmbientDir1.xyz, r3.xyz);
	r0.w = dot(gLightAmbientDir0.xyz, r3.xyz);
	r0.zw = saturate(r0.zw + gLightAmbientDir0.ww);
	r3.xyz = r0.zzz * gLightAmbient1.xyz;
	r3.xyz = r0.www * gLightAmbient0.xyz + r3.xyz;
	r3.xyz = r1.zzz * r3.xyz;
	r0.z = rsqrt(r1.z);
	r0.z = 1 / r0.z;
	r1.yzw = r2.xyz * r0.zzz + r3.xyz;
	r0.z = dot(r1.yzw, 0.33333334);
	r0.z = r0.z + 0.015;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r3 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyw = r3.xyz * r3.xyz;
	r2.xyz = r2.xyz * r2.xyz;
	r2.xyz = r2.xyz * 16;
	r2.xyz = r0.zzz * r2.xyz;
	r2.xyz = r4.xyz * r1.xxx + r2.xyz;
	o.xyz = r0.xyw * r1.yzw + r2.xyz;
	o.w = 1;

	return o;
}
