sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);
sampler2D materialIdSampler : register(s9);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
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
	r0.xyz = 1E-05 + i.texcoord.xyz;
	r1.xyz = normalize(r0.xyz);
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r2.xyz = r2.xyz * 2 + -1;
	r3 = normalize(r2.xyz);
	r0.z = dot(r1.xyz, r3.xyz);
	r0.z = r0.z + r0.z;
	r1.xyz = r3.xyz * -r0.zzz + r1.xyz;
	r2 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.z = r2.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord.w;
	r0.z = 1 / r0.z;
	r2.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r2.xyz = -r2.xyz + i.texcoord1.xyz;
	r0.z = dot(r2.xyz, r2.xyz);
	r0.w = r0.z + 1E-05;
	r0.z = saturate(r0.z * -i.texcoord1.w + 1);
	r0.z = r0.z * r0.z;
	r0.z = r0.z * r0.z + -0.1;
	r0.w = rsqrt(r0.w);
	r2.xyz = r0.www * r2.xyz;
	r0.w = saturate(dot(r2.xyz, r1.xyz));
	r0.w = r0.w + 1E-05;
	r1 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r1 = tex2D(materialIdSampler, r1.ww);
	r1.x = r1.w * -132 + 196;
	r4 = tex2D(GBufferTextureSampler2, r0.xy);
	r5 = tex2D(GBufferTextureSampler0, r0.xy);
	r1.yzw = r5.xyz * r5.xyz;
	r0.x = r4.y * r4.y;
	r0.x = r1.x * r0.x;
	r0.x = r0.x * 0.25 + 1E-05;
	r1.x = pow(r0.w, r0.x);
	r0.x = saturate(dot(r2.xyz, r3.xyz));
	r0.y = dot(r2.xyz, i.texcoord3.xyz);
	r0.w = i.texcoord2.w;
	r0.y = saturate(-r0.y * r0.w + i.texcoord3.w);
	r2.xyz = r0.xxx * i.texcoord2.xyz;
	r0.xyw = r0.yyy * r2.xyz;
	r2.x = r0.z * 1.1111112;
	r0.xyw = r0.xyw * r2.xxx;
	r0.xyz = (r0.zzz >= 0) ? r0.xyw : 0;
	r2.xyz = r1.xxx * r0.xyz;
	r2.xyz = r2.xyz * r4.xxx;
	o.xyz = r1.yzw * r0.xyz + r2.xyz;
	o.w = 1;

	return o;
}
