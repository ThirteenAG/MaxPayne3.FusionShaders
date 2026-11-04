sampler2D GBufferTextureSamplerDepth : register(s8);
sampler2D gDecalNormalSampler : register(s1);
sampler2D gDecalSampler : register(s0);
float4 gDeferredProjParams : register(c216);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightSettings : register(c219);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float r2;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r0 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.x = r0.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.x = r0.x * i.texcoord.w;
	r0.x = 1 / r0.x;
	r0.xy = i.texcoord.xy * -r0.xx + gViewInverse[3].xy;
	r0.xy = r0.xy + -i.texcoord2.xy;
	r1.x = dot(i.texcoord1.xy, r0.xy) + 0;
	r1.y = dot(i.texcoord1.zw, r0.xy) + 0;
	r0.x = 0.5 * i.texcoord2.w;
	r0.xy = r1.xy * r0.xx + 0.5;
	r1 = tex2D(gDecalNormalSampler, r0.xy);
	r0 = tex2D(gDecalSampler, r0.xy);
	r1.xyz = r1.xyz * 2 + -1;
	r1.w = 0;
	r1.xzw = r1.xxx * i.texcoord6.xyz + r1.wwz;
	r1.xyz = r1.yyy * i.texcoord7.xyz + r1.xzw;
	r1.x = saturate(dot(r1.xyz, -gDirectionalLight.xyz));
	r1.y = saturate(r1.x + 0.05);
	r2 = pow(r1.x, gLightSettings.y);
	r1.x = r2.x * gLightSettings.x;
	r2 = min(gLightSettings.z, r1.y);
	r0.xyz = r0.xyz * r2.xxx;
	o.w = r0.w * i.texcoord6.w;
	r0.xyz = r0.xyz * gLightSettings.www + r1.xxx;
	o.xyz = r0.xyz * gDirectionalColour.www;

	return o;
}
