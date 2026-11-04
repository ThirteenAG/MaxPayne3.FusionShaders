sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c196);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r2.x = saturate(i.texcoord3.x);
	r3 = lerp(r0, r1, r2.x);
	r0 = r3.wxyz * i.texcoord.wxyz;
	r0.y = dot(r0.yzw, float3(0.2125, 0.7154, 0.0721));
	r0.x = saturate(r0.x);
	r1.xyz = r3.xyz * i.texcoord.xyz + -r0.yyy;
	r2.x = gAdrenoFXVars.x;
	r0.z = r2.x * deSatContrastGamma.x;
	r0.yzw = r0.zzz * r1.xyz + r0.yyy;
	r1.xyz = lerp(r0.yzw, i.texcoord4.xyz, i.texcoord4.www);
	r0.w = 1;
	r0.y = (-HybridAdd.x >= 0) ? r0.w : r0.x;
	r2.w = r0.x * i.texcoord3.z;
	r2.xyz = r0.yyy * r1.xyz;
	r0 = max(r2, 0);
	o = min(r0, 32);

	return o;
}
