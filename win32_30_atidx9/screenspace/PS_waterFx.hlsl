sampler2D GBufferTextureSamplerDepth : register(s10);
sampler2D gDeferredLightSampler : register(s0);
float4 gDeferredProjParams : register(c119);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c118);

struct PS_IN
{
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float2 r1;
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
	r0 = tex2D(gDeferredLightSampler, r0.xy);
	o.xyz = r0.xyz * i.texcoord3.xyz;
	o.w = 1;

	return o;
}
