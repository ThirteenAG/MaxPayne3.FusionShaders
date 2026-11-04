float3 AmbientLightingParams : register(c201);
sampler2D DiffuseSampler : register(s0);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gLightAmbientDir0 : register(c72);
float4 gLightAmbientDir1 : register(c73);
float4 globalScalars : register(c35);
float specularColorFactor : register(c199);
float specularFactor : register(c198);

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
	float3 r3;
	float3 r4;
	o.w = globalScalars.x * i.color.w;
	r0.xzw = float3(1E-05, 0.15, 1);
	r0.y = saturate(AmbientLightingParams.x * -r0.z + r0.w);
	r0.y = saturate(r0.y + 0.2);
	r0.y = r0.y * AmbientLightingParams.y;
	r0.y = i.color.x * r0.y + -i.color.x;
	r0.y = gAmbientOcclusionEffect.x * r0.y + i.color.x;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	r0.z = dot(gLightAmbientDir0.xyz, r2.xyz);
	r0.z = r0.z + gLightAmbientDir0.w;
	r0.z = saturate(r0.z * gLightAmbientDir1.w);
	r1.xyz = r0.zzz * gLightAmbient0.xyz;
	r1.xyz = r0.yyy * r1.xyz;
	r0.z = dot(gLightAmbientDir1.xyz, r2.xyz);
	r0.z = r0.z + gLightAmbientDir0.w;
	r0.z = saturate(r0.z * gLightAmbientDir1.w);
	r3 = r0.zzz * gLightAmbient1.xyz;
	r0.yzw = r0.yyy * r3.xyz;
	r1.w = 1 / gAmbientOcclusionEffect.y;
	r0.yzw = r0.yzw * r1.www;
	r0.yzw = r1.xyz * r1.www + r0.yzw;
	r1.xyz = gDirectionalColour.www * gDirectionalColour.xyz;
	r1.w = dot(r2.xyz, -gDirectionalLight.xyz);
	r2.w = saturate(r1.w + -0.25);
	r1.w = saturate(r1.w * 2 + -0.5);
	r2.w = r2.w * 1.3333334;
	r0.yzw = r1.xyz * r2.www + r0.yzw;
	r3 = 1E-05 + i.texcoord3.xyz;
	r4 = normalize(r3.xyz);
	r2.w = dot(r4.xyz, r2.xyz);
	r2.w = r2.w + r2.w;
	r2.xyz = r2.xyz * -r2.www + r4.xyz;
	r2.x = saturate(dot(-gDirectionalLight.xyz, r2.xyz));
	r2.x = r2.x + 1E-05;
	r0.x = r0.x + specularFactor.x;
	r3.x = pow(r2.x, r0.x);
	r0.x = r1.w * r3.x;
	r1.xyz = r0.xxx * r1.xyz;
	r1.xyz = r1.xyz * gDirectionalLight.www;
	r1.xyz = r1.xyz * specularColorFactor.xxx;
	r2 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2.xyz = abs(r2.xyz) + 1E-05;
	r3.x = log2(r2.x);
	r3.y = log2(r2.y);
	r3.z = log2(r2.z);
	r2.xyz = r3.xyz * 2.20001;
	r3.x = exp2(r2.x);
	r3.y = exp2(r2.y);
	r3.z = exp2(r2.z);
	r0.xyz = r3.xyz * r0.yzw + r1.xyz;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

	return o;
}
