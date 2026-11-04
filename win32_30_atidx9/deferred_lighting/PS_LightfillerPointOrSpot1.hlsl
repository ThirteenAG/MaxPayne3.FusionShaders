sampler2D GBufferStencilTextureSampler : register(s11);
sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
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
	float4 r3;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.z = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord.w;
	r0.z = 1 / r0.z;
	r1.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r1.xyz = -r1.xyz + i.texcoord2.xyz;
	r2.xyz = r1.xyz + 1E-05;
	r0.z = dot(r1.xyz, r1.xyz);
	r0.z = saturate(r0.z * -i.texcoord1.y + 1);
	r0.z = r0.z + 1E-05;
	r1.x = pow(r0.z, 2.00001);
	r0.z = r1.x + -0.33333334;
	r1.xyz = normalize(r2.xyz);
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r2.xyz = r2.xyz * 2 + -1;
	r3.xyz = normalize(r2.xyz);
	r0.w = dot(r3.xyz, r1.xyz);
	r1.x = dot(r1.xyz, i.texcoord3.xyz);
	r1.x = saturate(r1.x * i.texcoord1.w + i.texcoord1.z);
	r0.w = r0.w + -0.2;
	r0.w = saturate(r0.w * 1.25);
	r1.y = r0.z * 1.5;
	r1.x = r1.x * r1.y;
	r0.w = r0.w * r1.x;
	r1.xyz = r0.www * i.texcoord4.xyz;
	r2 = tex2D(GBufferTextureSampler0, r0.xy);
	r3 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r0.xyw = r2.xyz * r2.xyz;
	r0.xyw = r1.xyz * r0.xyw;
	r1 = tex2D(materialIdSampler, r3.ww);
	r1.x = r1.y * 64;
	r1.x = r3.w * 255 + -r1.x;
	r1.y = r1.x + -127.9;
	r1.y = (r1.y >= 0) ? -128 : -0;
	r1.x = r1.y + r1.x;
	r1.y = r1.x + -63.9;
	r1.y = (r1.y >= 0) ? -64 : -0;
	r1.x = r1.y + r1.x;
	r1.y = r1.x + -31.9;
	r1.y = (r1.y >= 0) ? -32 : -0;
	r1.x = r1.y + r1.x;
	r1.y = r1.x + -15.9;
	r1.y = (r1.y >= 0) ? -16 : -0;
	r1.x = r1.y + r1.x;
	r1.x = r1.x + -7.9;
	r0.xyw = (r1.xxx >= 0) ? r0.xyw : 0;
	o.xyz = (r0.zzz >= 0) ? r0.xyw : 0;
	o.w = 1;

	return o;
}
