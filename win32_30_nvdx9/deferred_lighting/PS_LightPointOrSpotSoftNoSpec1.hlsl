sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gDeferredLightRadiusProjShearParams : register(c206);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);
sampler2D materialIdSampler : register(s9);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float2 vpos : VPOS;
	float4 texcoord1 : TEXCOORD1;
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
	r0.z = r0.z * i.texcoord.w;
	r0.z = 1 / r0.z;
	r1.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r1.xyz = -r1.xyz + i.texcoord2.xyz;
	r0.z = dot(r1.xyz, r1.xyz);
	r1.xyz = r1.xyz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.w = 1;
	r0.z = saturate(r0.z * -gDeferredLightRadiusProjShearParams.y + r0.w);
	r0.w = dot(r2.xyz, i.texcoord3.xyz);
	r0.w = saturate(r0.w * i.texcoord1.w + i.texcoord1.z);
	r0.z = r0.w * r0.z;
	r1.xyz = r0.zzz * i.texcoord4.xyz;
	r3 = tex2D(GBufferTextureSampler1, r0.xy);
	r3.xyz = r3.xyz * 2 + -1;
	r4 = normalize(r3.xyz);
	r0.z = dot(r2.xyz, r4.xyz);
	r0.w = r0.z + 0.5;
	r0.z = saturate(r0.z);
	r0.w = saturate(r0.w * 0.25);
	r0.z = r0.z + r0.w;
	r1.xyz = r0.zzz * r1.xyz;
	r2 = tex2D(GBufferTextureSampler0, r0.xy);
	r0 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r0 = tex2D(materialIdSampler, r0.ww);
	r0.xyw = r2.xyz * r2.xyz;
	r0.xyw = r1.xyz * r0.xyw;
	o.xyz = r0.zzz * r0.xyw;
	o.w = 1;

	return o;
}
