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
	r1.xyz = i.texcoord.xyz * -r0.zzz + 1E-05;
	r2.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r2.xyz = -r2.xyz + i.texcoord2.xyz;
	r3 = normalize(r1.xyz);
	r1 = tex2D(GBufferTextureSampler1, r0.xy);
	r1.xyz = r1.xyz * 2 + -1;
	r4.xyz = normalize(r1.xyz);
	r0.z = dot(r3.xyz, r4.xyz);
	r0.z = r0.z + r0.z;
	r1.xyz = r4.xyz * -r0.zzz + r3.xyz;
	r3 = r2.xyz + 1E-05;
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = saturate(r0.z * -i.texcoord1.y + 1);
	r0.z = r0.z + 1E-05;
	r1.w = pow(r0.z, 4.00001);
	r0.z = r1.w + -0.1;
	r2.xyz = normalize(r3.xyz);
	r0.w = saturate(dot(r2.xyz, r1.xyz));
	r0.w = r0.w + 2E-05;
	r1 = tex2D(GBufferTextureSampler2, r0.xy);
	r1.y = r1.y * r1.y;
	r1.y = r1.y * r1.y;
	r1.y = r1.y * 196 + 1E-05;
	r2.w = pow(r0.w, r1.y);
	r0.w = r0.z * 1.1111112;
	r1.y = dot(r2.xyz, i.texcoord3.xyz);
	r1.w = saturate(dot(r2.xyz, r4.xyz));
	r1.y = saturate(r1.y * i.texcoord1.w + i.texcoord1.z);
	r0.w = r0.w * r1.y;
	r2.xyz = r0.www * i.texcoord4.xyz;
	r2.xyz = (r0.zzz >= 0) ? r2.xyz : 0;
	r3 = r2.www * r2.xyz;
	r2.xyz = r1.www * r2.xyz;
	r0.z = saturate(r1.w * 2 + -0.5);
	r3 = r0.zzz * r3.xyz;
	r4 = tex2D(GBufferTextureSampler0, r0.xy);
	r0 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r0 = tex2D(materialIdSampler, r0.ww);
	r0.x = -r0.z + 1;
	r0.yzw = r4.xyz * r4.xyz;
	r0.yzw = r2.xyz * r0.yzw;
	r0.yzw = r1.xxx * r3.xyz + r0.yzw;
	r1.x = saturate(r1.z * r1.z + 0.5);
	r0.x = r0.x * r1.x;
	o.xyz = r0.xxx * r0.yzw;
	o.w = 1;

	return o;
}
