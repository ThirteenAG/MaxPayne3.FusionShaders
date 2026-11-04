sampler2D GBufferStencilTextureSampler : register(s11);
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
	float3 texcoord4 : TEXCOORD4;
	float2 vpos : VPOS;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
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
	r1.xyz = r1.xyz + -i.texcoord2.xyz;
	r0.z = dot(r1.xy, r1.xy) + 0;
	r1.xy = abs(r1.zz) * -2 + float2(1, 1.00001);
	r0.z = saturate(r0.z * -i.texcoord1.y + 1);
	r0.z = r0.z + 1E-05;
	r1.z = pow(r0.z, 2.00001);
	r0.z = r1.z + -0.33333334;
	r0.w = r0.z * 1.5;
	r2.xyz = r0.www * i.texcoord4.xyz;
	r2.xyz = (r0.zzz >= 0) ? r2.xyz : 0;
	r0.z = pow(r1.y, 2.00001);
	r0.z = (r1.x >= 0) ? r0.z : 9.998849E-11;
	r1.xyz = r0.zzz * r2.xyz;
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r0 = tex2D(GBufferStencilTextureSampler, r0.xy);
	r0 = tex2D(materialIdSampler, r0.ww);
	r0.x = -r0.w + 1;
	r0.yzw = r2.xyz * 2 + -1;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = rsqrt(r0.y);
	r0.y = r0.y * r0.w;
	r0.yzw = abs(r0.yyy) * r1.xyz;
	o.xyz = r0.xxx * r0.yzw;
	o.w = 1;

	return o;
}
