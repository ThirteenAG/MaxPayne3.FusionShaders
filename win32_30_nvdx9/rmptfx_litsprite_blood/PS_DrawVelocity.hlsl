sampler2D DepthMapTexSampler : register(s12);
sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c197);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gInvScreenSize : register(c129);

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
	r0 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r2 = lerp(r0, r1, 0.5);
	r0 = r2.wxyz * i.texcoord.wxyz;
	r0.y = dot(r0.yzw, float3(0.2125, 0.7154, 0.0721));
	r0.x = saturate(r0.x);
	r1.xw = float2(1, 0);
	r0.x = (-HybridAdd.x >= 0) ? r1.x : r0.x;
	r1.xyz = r2.xyz * i.texcoord.xyz + -r0.yyy;
	r2.x = gAdrenoFXVars.x;
	r0.z = r2.x * deSatContrastGamma.x;
	r0.yzw = r0.zzz * r1.xyz + r0.yyy;
	r1.xyz = lerp(r0.yzw, i.texcoord4.xyz, i.texcoord4.www);
	r0.xyz = r0.xxx * r1.xyz;
	r1.xyz = max(r0.xyz, 0);
	r0 = min(r1, 32);
	r1.xy = i.vpos.xy * gInvScreenSize.xy + gInvScreenSize.zw;
	r1 = tex2D(DepthMapTexSampler, r1.xy);
	r1.x = saturate(-r1.x + -i.texcoord3.y);
	o = r0 * r1.x;

	return o;
}
