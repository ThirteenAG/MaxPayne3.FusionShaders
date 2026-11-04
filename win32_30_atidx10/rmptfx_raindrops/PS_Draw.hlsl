sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c89);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 globalScalars4 : register(c51);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float2 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float2 r2;
	float4 r3;
	r0 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r2.x = saturate(i.texcoord3.x);
	r3 = lerp(r0, r1, r2.x);
	r0 = r3 * i.texcoord;
	r1.x = globalScalars4.x * i.texcoord5.y;
	r1.yzw = r0.xyz * r1.xxx;
	r1.y = dot(r1.yzw, float3(0.2125, 0.7154, 0.0721));
	r1.xzw = r0.xyz * r1.xxx + -r1.yyy;
	r0.w = saturate(r0.w);
	r2.x = gAdrenoFXVars.x;
	r2.x = r2.x * deSatContrastGamma.x;
	r1.xyz = r2.xxx * r1.xzw + r1.yyy;
	r0.xyz = lerp(r1.xyz, i.texcoord4.xyz, i.texcoord4.www);
	r1.xyz = r0.www * r0.xyz;
	r2.x = abs(HybridAdd.x);
	r2.y = 1 + -i.texcoord5.x;
	r1.w = r0.w * r2.y;
	r0 = (-r2.x >= 0) ? r0 : r1;
	o = max(r0, 0);

	return o;
}
