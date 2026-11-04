sampler2D GBufferTextureSamplerDepth : register(s8);
sampler2D ReflectTextureSampler : register(s10);
sampler2D gDecalNormalSampler : register(s1);
sampler2D gDecalSampler : register(s0);
float4 gDeferredProjParams : register(c216);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightSettings : register(c220);
float4 gSurfaceSettings : register(c219);
row_major float4x4 gViewInverse : register(c12);
float4 gWorldBinormal : register(c222);
float4 gWorldTangent : register(c221);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float2 vpos : VPOS;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
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
	r1 = tex2D(gDecalSampler, r0.xy);
	r0 = tex2D(gDecalNormalSampler, r0.xy);
	r0.xyz = r0.xyz * 2 + -1;
	o.w = r1.w * i.texcoord3.w;
	r0.xy = r0.xy * gSurfaceSettings.yy;
	r2.xyz = r0.xxx * gWorldTangent.xyz;
	r0.xzw = r0.zzz * float3(0, 0, 1) + r2.xyz;
	r0.xyz = r0.yyy * gWorldBinormal.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r2.xyz = normalize(r0.xyz);
	r0.x = saturate(dot(r2.xyz, -gDirectionalLight.xyz));
	r0.y = -r0.x + 1;
	r0.x = gSurfaceSettings.x * r0.y + r0.x;
	r1.w = min(gLightSettings.z, r0.x);
	r0.xyz = r1.xyz * r1.www;
	r1.xyz = -gViewInverse[3].xyz + i.texcoord4.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r3 = r0.www * r1.xyz;
	r1.xy = r1.xy * r0.ww + 1E-05;
	r0.w = dot(r3.xyz, r2.xyz);
	r0.w = r0.w + r0.w;
	r3 = r2.xyz * -r0.www + r3.xyz;
	r0.w = saturate(dot(r3.xyz, -gDirectionalLight.xyz));
	r1.w = pow(r0.w, gLightSettings.y);
	r0.w = r1.w * gLightSettings.x;
	r0.xyz = r0.xyz * gLightSettings.www + r0.www;
	r1.z = 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xy = r0.ww * r1.xy;
	r1.zw = float2(1, -1);
	r2 = r1.yyxz * r2.xyyx;
	r1.xy = r2.zw * r1.wx + r2.xy;
	r0.w = 1 / i.texcoord5.w;
	r1.zw = -r0.ww * i.texcoord5.xy;
	r0.w = r0.w * gSurfaceSettings.w;
	r1.zw = r1.zw * 0.5 + 0.5;
	r1.xy = r1.xy * r0.ww + r1.zw;
	r1 = tex2D(ReflectTextureSampler, r1.xy);
	r1.xyz = r1.xyz * r1.xyz;
	r1.xyz = r1.xyz * gSurfaceSettings.zzz;
	r1.xyz = r1.xyz * 16;
	o.xyz = gDirectionalColour.www * r0.xyz + r1.xyz;

	return o;
}
