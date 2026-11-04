float3 AmbientLightingParams : register(c204);
sampler2D DiffuseSampler : register(s0);
float emissiveMultiplier : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gLightAmbientDir0 : register(c72);
float4 gLightAmbientDir1 : register(c73);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);
float specularColorFactor : register(c201);
float specularFactor : register(c200);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
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
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = abs(r0) + 1E-05;
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r1.w = log2(r0.w);
	r0 = r1 * 2.20001;
	r0.w = exp2(r0.w);
	r0.w = r0.w * i.color.w;
	o.w = r0.w * globalScalars.x;
	r1.xzw = float3(1E-05, 0.15, 1);
	r0.w = saturate(AmbientLightingParams.x * -r1.z + r1.w);
	r0.w = saturate(r0.w + 0.2);
	r0.w = r0.w * AmbientLightingParams.y;
	r0.w = globalScalars.z * r0.w + -globalScalars.z;
	r1.z = globalScalars.z;
	r0.w = gAmbientOcclusionEffect.x * r0.w + r1.z;
	r1.yzw = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.yzw);
	r1.y = dot(gLightAmbientDir1.xyz, r2.xyz);
	r1.y = r1.y + gLightAmbientDir0.w;
	r1.y = saturate(r1.y * gLightAmbientDir1.w);
	r1.yzw = r1.yyy * gLightAmbient1.xyz;
	r1.yzw = r0.www * r1.yzw;
	r2.w = dot(gLightAmbientDir0.xyz, r2.xyz);
	r2.w = r2.w + gLightAmbientDir0.w;
	r2.w = saturate(r2.w * gLightAmbientDir1.w);
	r3.xyz = r2.www * gLightAmbient0.xyz;
	r1.yzw = r3.xyz * r0.www + r1.yzw;
	r3.xyz = gDirectionalColour.www * gDirectionalColour.xyz;
	r0.w = dot(r2.xyz, -gDirectionalLight.xyz);
	r2.w = saturate(r0.w + -0.25);
	r0.w = saturate(r0.w * 2 + -0.5);
	r2.w = r2.w * 1.3333334;
	r1.yzw = r3.xyz * r2.www + r1.yzw;
	r4 = 1E-05 + i.texcoord3.xyz;
	r5 = normalize(r4.xyz);
	r2.w = dot(r5.xyz, r2.xyz);
	r2.w = r2.w + r2.w;
	r2.xyz = r2.xyz * -r2.www + r5.xyz;
	r2.x = saturate(dot(-gDirectionalLight.xyz, r2.xyz));
	r2.x = r2.x + 1E-05;
	r1.x = r1.x + specularFactor.x;
	r3.w = pow(r2.x, r1.x);
	r0.w = r0.w * r3.w;
	r2.xyz = r0.www * r3.xyz;
	r2.xyz = r2.xyz * gDirectionalLight.www;
	r2.xyz = r2.xyz * specularColorFactor.xxx;
	r3.x = exp2(r0.x);
	r3.y = exp2(r0.y);
	r3.z = exp2(r0.z);
	r0.xyz = r3.xyz * r1.yzw + r2.xyz;
	r1.xyz = r3.xyz * i.color.xyz;
	r1.xyz = r1.xyz * emissiveMultiplier.xxx;
	r0.xyz = r1.xyz * globalDayNightEffects.www + r0.xyz;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

	return o;
}
