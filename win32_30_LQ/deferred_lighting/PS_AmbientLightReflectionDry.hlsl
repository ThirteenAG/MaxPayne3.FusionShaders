sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D gDeferredLightSampler0P : register(s3);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gLightAmbientDir0 : register(c72);
float4 gLightAmbientDir1 : register(c73);
float4 gooDeferredLightScreenSize : register(c215);

float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = 0.51 + vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSampler1, r0.xy);
	r1.xyz = r1.xyz * 2 + -1;
	r2.xyz = normalize(r1.xyz);
	r0.z = dot(gLightAmbientDir1.xyz, r2.xyz);
	r0.w = dot(gLightAmbientDir0.xyz, r2.xyz);
	r0.zw = saturate(r0.zw + gLightAmbientDir0.ww);
	r1.xyz = r0.zzz * gLightAmbient1.xyz;
	r1.xyz = r0.www * gLightAmbient0.xyz + r1.xyz;
	r2 = tex2D(GBufferTextureSampler2, r0.xy);
	r1.xyz = r1.xyz * r2.zzz;
	r0.z = dot(r1.xyz, 0.33333334);
	r0.z = r0.z + 0.015;
	r2 = tex2D(gDeferredLightSampler0P, r0.xy);
	r3 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyw = r3.xyz * r3.xyz;
	r2.xyz = r2.xyz * r2.xyz;
	r2.xyz = r2.xyz * 16;
	r2.xyz = r0.zzz * r2.xyz;
	o.xyz = r0.xyw * r1.xyz + r2.xyz;
	o.w = 1;

	return o;
}
