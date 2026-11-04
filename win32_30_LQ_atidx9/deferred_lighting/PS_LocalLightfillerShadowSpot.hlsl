sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSamplerDepth : register(s10);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gShadowMatrix : register(c57);
float4 gShadowParam0123 : register(c54);
sampler2D gShadowZSamplerDir : register(s15);
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
	float4 r3;
	float3 r4;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.z = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord.w;
	r0.z = 1 / r0.z;
	r1.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r2 = r1.y * gShadowMatrix[1];
	r2 = r1.x * gShadowMatrix[0] + r2;
	r2 = r1.z * gShadowMatrix[2] + r2;
	r1.xyz = -r1.xyz + i.texcoord2.xyz;
	r2 = r2 + gShadowMatrix[3];
	r0.z = 1 / r2.w;
	r2.xy = r2.xy * r0.zz + 1;
	r0.z = r2.z * r0.z + -gShadowParam0123.x;
	r2.x = r2.x * 0.5;
	r2.z = r2.y * -0.5 + 1;
	r2 = tex2D(gShadowZSamplerDir, r2.xz);
	r0.z = -r0.z + r2.x;
	r2.z = -1;
	r0.z = (r0.z >= 0) ? -r2.z : gShadowParam0123.y;
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r3 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyw = r3.xyz * r3.xyz;
	r2.xyz = r2.xyz * 2 + -1;
	r3.xyz = normalize(r2.xyz);
	r2.xyz = r1.xyz + 1E-05;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = saturate(r1.x * -i.texcoord1.y + 1);
	r1.x = r1.x + 1E-05;
	r2.w = pow(r1.x, 2.00001);
	r1.x = r2.w + -0.33333334;
	r4 = normalize(r2.xyz);
	r1.y = dot(r3.xyz, r4.xyz);
	r1.z = dot(r4.xyz, i.texcoord3.xyz);
	r1.z = saturate(r1.z * i.texcoord1.w + i.texcoord1.z);
	r1.y = r1.y + -0.33333334;
	r1.y = saturate(r1.y * 1.5);
	r1.w = r1.x * 1.5;
	r1.z = r1.z * r1.w;
	r1.y = r1.y * r1.z;
	r0.z = r0.z * r1.y;
	r1.yzw = r0.zzz * i.texcoord4.xyz;
	r0.xyz = r0.xyw * r1.yzw;
	o.xyz = (r1.xxx >= 0) ? r0.xyz : 0;
	o.w = 1;

	return o;
}
