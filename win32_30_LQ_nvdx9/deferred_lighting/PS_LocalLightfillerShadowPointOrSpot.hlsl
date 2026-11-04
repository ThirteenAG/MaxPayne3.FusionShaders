sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
row_major float4x4 dShadowMatrix : register(c197);
float4 dShadowParam0123 : register(c196);
float4 gDeferredProjParams : register(c216);
sampler2D gShadowZSamplerCache : register(s14);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

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
	float3 r3;
	float4 r4;
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
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r0 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyz = r0.xyz * r0.xyz;
	r2.xyz = r2.xyz * 2 + -1;
	r3 = normalize(r2.xyz);
	r2.xyz = r3.xyz * 0.15 + r1.xyz;
	r1.xyz = -r1.xyz + i.texcoord2.xyz;
	r4.xyz = r2.yyy * dShadowMatrix[1].xyz;
	r2.xyw = r2.xxx * dShadowMatrix[0].xyz + r4.xyz;
	r2.xyz = r2.zzz * dShadowMatrix[2].xyz + r2.xyw;
	r2.xyz = r2.xyz + dShadowMatrix[3].xyz;
	r2.w = -abs(r2.z);
	r0.w = dot(r2.xyw, r2.xyw);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r1.w = abs(r2.z) + r0.w;
	r0.w = r0.w * -dShadowParam0123.w;
	r1.w = 1 / r1.w;
	r2.xy = r1.ww * r2.xy;
	r2.zw = (-r2.zz >= 0) ? float2(1, 0) : float2(0, 1);
	r2.xy = r2.xy * float2(0.5, -0.5) + 0.5;
	r4 = tex2D(gShadowZSamplerCache, r2.xy);
	r0.w = dot(r4.xy, r2.zw) + -r0.w;
	r1.w = 1;
	r1.w = r1.w + -dShadowParam0123.z;
	r1.w = r1.w * 0.33333334;
	r0.w = (r0.w >= 0) ? 0 : r1.w;
	r0.w = r0.w + dShadowParam0123.z;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.xyz = r1.xyz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	r1.x = saturate(r1.w * -i.texcoord1.y + 1);
	r1.x = r1.x + 1E-05;
	r2.w = pow(r1.x, 2.00001);
	r1.x = r2.w + -0.33333334;
	r1.y = r1.x * 1.5;
	r1.z = dot(r2.xyz, i.texcoord3.xyz);
	r1.w = dot(r3.xyz, r2.xyz);
	r1.w = r1.w + -0.33333334;
	r1.w = saturate(r1.w * 1.5);
	r1.z = saturate(r1.z * i.texcoord1.w + i.texcoord1.z);
	r1.y = r1.z * r1.y;
	r1.y = r1.w * r1.y;
	r0.w = r0.w * r1.y;
	r1.yzw = r0.www * i.texcoord4.xyz;
	r0.xyz = r0.xyz * r1.yzw;
	o.xyz = (r1.xxx >= 0) ? r0.xyz : 0;
	o.w = 1;

	return o;
}
