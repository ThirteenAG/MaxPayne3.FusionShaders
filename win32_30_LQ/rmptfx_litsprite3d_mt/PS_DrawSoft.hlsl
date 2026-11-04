sampler2D DiffuseTexSampler01 : register(s0);
sampler2D DiffuseTexSampler02 : register(s1);
sampler2D DiffuseTexSampler03 : register(s2);
sampler2D DiffuseTexSampler04 : register(s3);
float HybridAdd : register(c196);
float4 deSatContrastGamma : register(c46);
float4 gActiveUnit : register(c199);
float4 gAdrenoFXVars : register(c68);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(DiffuseTexSampler01, i.texcoord1.xy);
	r1 = tex2D(DiffuseTexSampler02, i.texcoord1.xy);
	r2 = gActiveUnit * i.texcoord6;
	r1 = r1 * r2.y;
	r0 = r2.x * r0 + r1;
	r1 = tex2D(DiffuseTexSampler03, i.texcoord1.xy);
	r0 = r2.z * r1 + r0;
	r1 = tex2D(DiffuseTexSampler04, i.texcoord1.xy);
	r0 = r2.w * r1 + r0;
	r1 = r0.wxyz * i.texcoord.wxyz;
	r0.w = dot(r1.yzw, float3(0.2125, 0.7154, 0.0721));
	r1.x = saturate(r1.x);
	r0.xyz = i.texcoord.xyz * r0.xyz + -r0.www;
	r2.x = gAdrenoFXVars.x;
	r1.y = r2.x * deSatContrastGamma.x;
	r0.xyz = r1.yyy * r0.xyz + r0.www;
	r1.yzw = lerp(r0.xyz, i.texcoord4.xyz, i.texcoord4.www);
	r0.w = 1;
	r0.x = (-HybridAdd.x >= 0) ? r0.w : r1.x;
	o.w = r1.x * i.texcoord3.z;
	o.xyz = r0.xxx * r1.yzw;

	return o;
}
