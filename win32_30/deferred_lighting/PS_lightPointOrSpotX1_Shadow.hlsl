sampler2D GBufferTextureSampler0 : register(s8);
sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D GBufferTextureSamplerDepth : register(s10);
sampler2D gDeferredLightShadowMap0 : register(s4);
float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

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
	float4 r3;
	float3 r4;
	float3 r5;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r1 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.z = r1.x * gDeferredProjParams.z + -gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord.w;
	r0.z = 1 / r0.z;
	r1.xyz = i.texcoord.xyz * -r0.zzz + gViewInverse[3].xyz;
	r2.xyz = r1.yzx + -i.texcoord1.yzx;
	r1.xyz = -r1.xyz + i.texcoord1.xyz;
	r3.xyz = r2.xyz * float3(1, -1, 1);
	r0.zw = (-r2.zz >= 0) ? float2(1, 0) : float2(0, 1);
	r3.w = -abs(r3.z);
	r1.w = dot(r3.xyw, r3.xyw);
	r1.w = rsqrt(r1.w);
	r1.w = 1 / r1.w;
	r2.x = abs(r3.z) + r1.w;
	r2.x = 1 / r2.x;
	r2.xy = r2.xx * r3.xy;
	r2.xy = r2.xy * float2(0.5, -0.5) + 0.5;
	r2 = tex2D(gDeferredLightShadowMap0, r2.xy);
	r2.z = rsqrt(i.texcoord1.w);
	r2.z = 1 / r2.z;
	r1.w = saturate(r1.w * r2.z);
	r0.z = dot(r2.xy, r0.zw) + -r1.w;
	r0.w = dot(r1.xyz, r1.xyz);
	r1.w = r0.w + 1E-05;
	r0.w = saturate(r0.w * -i.texcoord1.w + 1);
	r0.w = r0.w * r0.w;
	r0.w = r0.w * r0.w + -0.1;
	r1.w = rsqrt(r1.w);
	r1.xyz = r1.www * r1.xyz;
	r2 = tex2D(GBufferTextureSampler1, r0.xy);
	r2.xyz = r2.xyz * 2 + -1;
	r3.xyz = normalize(r2.xyz);
	r1.w = saturate(dot(r1.xyz, r3.xyz));
	r2.xyz = r1.www * i.texcoord2.xyz;
	r1.w = dot(r1.xyz, i.texcoord3.xyz);
	r2.w = i.texcoord2.w;
	r1.w = saturate(-r1.w * r2.w + i.texcoord3.w);
	r2.xyz = r1.www * r2.xyz;
	r1.w = r0.w * 1.1111112;
	r2.xyz = r1.www * r2.xyz;
	r2.xyz = (r0.zzz >= 0) ? r2.xyz : 0;
	r2.xyz = (r0.www >= 0) ? r2.xyz : 0;
	r4 = 1E-05 + i.texcoord.xyz;
	r5 = normalize(r4.xyz);
	r0.z = dot(r5.xyz, r3.xyz);
	r0.z = r0.z + r0.z;
	r3.xyz = r3.xyz * -r0.zzz + r5.xyz;
	r0.z = saturate(dot(r1.xyz, r3.xyz));
	r0.z = r0.z + 1E-05;
	r1 = tex2D(GBufferTextureSampler2, r0.xy);
	r3 = tex2D(GBufferTextureSampler0, r0.xy);
	r0.xyw = r3.xyz * r3.xyz;
	r1.y = r1.y * r1.y;
	r1.y = r1.y * r1.y;
	r1.y = r1.y * 49 + 1E-05;
	r2.w = pow(r0.z, r1.y);
	r1.yzw = r2.www * r2.xyz;
	r1.xyz = r1.yzw * r1.xxx;
	o.xyz = r0.xyw * r2.xyz + r1.xyz;
	o.w = 1;

	return o;
}
