sampler2D DepthMapTexSampler : register(s12);
sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c197);
float4 NearFarPlane : register(c128);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gInvScreenSize : register(c129);
float gSoftness : register(c196);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
	float2 vpos : VPOS;
	float2 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = i.vpos.xy * gInvScreenSize.xy + gInvScreenSize.zw;
	r0 = tex2D(DepthMapTexSampler, r0.xy);
	r0.x = -r0.x + 1;
	r0.x = r0.x * NearFarPlane.z + NearFarPlane.w;
	r0.x = 1 / r0.x;
	r0.x = r0.x + -i.texcoord3.y;
	r0.x = r0.x * r0.x;
	r0.x = saturate(r0.x * gSoftness.x);
	r0.w = r0.x * i.texcoord.w;
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r2 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r3 = lerp(r1, r2, 0.5);
	r0.xyz = i.texcoord.xyz;
	r1 = r0.wxyz * r3.wxyz;
	r0.w = dot(r1.yzw, float3(0.2125, 0.7154, 0.0721));
	r1.x = saturate(r1.x);
	r1.y = 1;
	r1.x = (-HybridAdd.x >= 0) ? r1.y : r1.x;
	r0.xyz = r3.xyz * r0.xyz + -r0.www;
	r2.x = gAdrenoFXVars.x;
	r1.y = r2.x * deSatContrastGamma.x;
	r0.xyz = r1.yyy * r0.xyz + r0.www;
	r1.yzw = lerp(r0.xyz, i.texcoord4.xyz, i.texcoord4.www);
	r0.xyz = r1.xxx * r1.yzw;
	r1.xyz = max(r0.xyz, 0);
	r1.w = 0;
	o = min(r1, 32);

	return o;
}
