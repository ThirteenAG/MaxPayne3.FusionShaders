sampler2D DepthMapTexSampler : register(s12);
sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c197);
float4 deSatContrastGamma : register(c46);
float4 gActiveUnit : register(c200);
float4 gAdrenoFXVars : register(c68);
float4 gInvScreenSize : register(c129);
float4 gTexCoordScaleOffset0 : register(c201);
float4 gTexCoordScaleOffset1 : register(c202);
float4 gTexCoordScaleOffset2 : register(c203);
float4 gTexCoordScaleOffset3 : register(c204);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord6 : TEXCOORD6;
	float2 vpos : VPOS;
	float3 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = i.texcoord1.xy * gTexCoordScaleOffset2.xy + gTexCoordScaleOffset2.zw;
	r0 = tex2D(DiffuseTexSampler, r0.xy);
	r1.xy = i.texcoord1.xy * gTexCoordScaleOffset0.xy + gTexCoordScaleOffset0.zw;
	r1 = tex2D(DiffuseTexSampler, r1.xy);
	r2.xy = i.texcoord1.xy * gTexCoordScaleOffset1.xy + gTexCoordScaleOffset1.zw;
	r2 = tex2D(DiffuseTexSampler, r2.xy);
	r3 = gActiveUnit * i.texcoord6;
	r2 = r2 * r3.y;
	r1 = r3.x * r1 + r2;
	r0 = r3.z * r0 + r1;
	r1.xy = i.texcoord1.xy * gTexCoordScaleOffset3.xy + gTexCoordScaleOffset3.zw;
	r1 = tex2D(DiffuseTexSampler, r1.xy);
	r0 = r3.w * r1 + r0;
	r1 = r0.wxyz * i.texcoord.wxyz;
	r0.w = dot(r1.yzw, float3(0.2125, 0.7154, 0.0721));
	r1.x = saturate(r1.x);
	r0.xyz = r0.xyz * i.texcoord.xyz + -r0.www;
	r2.x = gAdrenoFXVars.x;
	r1.y = r2.x * deSatContrastGamma.x;
	r0.xyz = r1.yyy * r0.xyz + r0.www;
	r1.yzw = lerp(r0.xyz, i.texcoord4.xyz, i.texcoord4.www);
	r0.w = 1;
	r0.x = (-HybridAdd.x >= 0) ? r0.w : r1.x;
	r2.w = r1.x * i.texcoord3.z;
	r2.xyz = r0.xxx * r1.yzw;
	r0 = max(r2, 0);
	r1 = min(r0, 32);
	r0.xy = i.vpos.xy * gInvScreenSize.xy + gInvScreenSize.zw;
	r0 = tex2D(DepthMapTexSampler, r0.xy);
	r0.x = saturate(-r0.x + -i.texcoord3.y);
	o = r0.x * r1;

	return o;
}
