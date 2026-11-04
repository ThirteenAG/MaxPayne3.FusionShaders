sampler2D GBufferTextureSamplerDepth : register(s10);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float3 gDeferredLightPosition : register(c203);
float4 gDeferredLightRadiusProjShearParams : register(c206);
float4 gDeferredProjParams : register(c216);
float4 gooDeferredLightScreenSize : register(c215);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	float3 r3;
	r0.xy = 0.51 + i.vpos.xy;
	r0.xy = r0.xy * gooDeferredLightScreenSize.zw;
	r0 = tex2D(GBufferTextureSamplerDepth, r0.xy);
	r0.x = r0.x * -gDeferredProjParams.z + gDeferredProjParams.w;
	r0.x = r0.x * i.texcoord.w;
	r0.x = 1 / r0.x;
	r0.x = saturate(-r0.x);
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1 = normalize(r0.yzw);
	r0.y = dot(r1.xyz, i.texcoord1.xyz);
	r0.z = dot(r1.xyz, i.texcoord.xyz);
	r0.x = r0.y * r0.x + r0.z;
	r1 = i.texcoord1.xyz;
	r2 = r1.zxy * i.texcoord.xyz;
	r1 = i.texcoord.zxy * r1.xyz + -r2.xyz;
	r2 = r1.xyz * i.texcoord1.zxy;
	r1 = i.texcoord1.yzx * r1.yzx + -r2.xyz;
	r1 = r1.xyz + 1E-05;
	r2 = normalize(r1.xyz);
	r0.y = dot(r2.xyz, i.texcoord.xyz);
	r0.w = r0.y + -gDeferredLightRadiusProjShearParams.x;
	r0.w = (r0.w >= 0) ? 0 : 1;
	r1.x = gDeferredLightRadiusProjShearParams.x * gDeferredLightRadiusProjShearParams.x;
	r0.y = r0.y * -r0.y + r1.x;
	r1.x = 1 / r1.x;
	r0.y = rsqrt(abs(r0.y));
	r0.y = 1 / r0.y;
	r0.y = r0.w * r0.y;
	r1.y = max(r0.x, -r0.y);
	r2.x = min(r0.y, r1.y);
	r1.y = max(r0.z, -r0.y);
	r2.y = min(r0.y, r1.y);
	r0.x = -r2.y + r2.x;
	r0.yzw = -gDeferredLightPosition.xyz + i.texcoord3.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r2 = normalize(r0.yzw);
	r0.yzw = 1E-05 + i.texcoord.xyz;
	r3 = normalize(r0.yzw);
	r0.y = dot(r2.xyz, r3.xyz);
	r0.y = saturate(abs(r0.y) + -0.25);
	r0.x = r0.y * r0.x;
	r0.x = r0.x * r0.x;
	r0.x = r1.x * r0.x;
	r0.yzw = r0.xxx * i.texcoord2.xyz;
	r0.y = dot(r0.yzw, float3(0.2125, 0.7154, 0.0721));
	r0.xzw = i.texcoord2.xyz * r0.xxx + -r0.yyy;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xzw + r0.yyy;
	o.w = 0;

	return o;
}
