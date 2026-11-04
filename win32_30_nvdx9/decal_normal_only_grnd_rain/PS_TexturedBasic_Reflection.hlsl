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

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	o.w = globalScalars.x * i.color.w;
	r0.zw = float2(0.15, 1);
	r0.x = saturate(AmbientLightingParams.x * -r0.z + r0.w);
	r0.x = saturate(r0.x + 0.2);
	r0.x = r0.x * AmbientLightingParams.y;
	r0.x = i.color.x * r0.x + -i.color.x;
	r0.x = gAmbientOcclusionEffect.x * r0.x + i.color.x;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	r0.y = dot(gLightAmbientDir1.xyz, r1.xyz);
	r0.y = saturate(r0.y + gLightAmbientDir0.w);
	r0.yzw = r0.yyy * gLightAmbient1.xyz;
	r1.w = dot(gLightAmbientDir0.xyz, r1.xyz);
	r1.x = dot(r1.xyz, -gDirectionalLight.xyz);
	r1.x = saturate(r1.x + -0.25);
	r1.x = r1.x * 1.3333334;
	r1.xyz = r1.xxx * gDirectionalColour.xyz;
	r1.w = saturate(r1.w + gLightAmbientDir0.w);
	r0.yzw = r1.www * gLightAmbient0.xyz + r0.yzw;
	r0.xyz = r0.yzw * r0.xxx + r1.xyz;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = abs(r1.xyz) + 1E-05;
	r2.x = log2(r1.x);
	r2.y = log2(r1.y);
	r2.z = log2(r1.z);
	r1.xyz = r2.xyz * 2.20001;
	r2.x = exp2(r1.x);
	r2.y = exp2(r1.y);
	r2.z = exp2(r1.z);
	r0.xyz = r0.xyz * r2.xyz;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

	return o;
}
