float3 AmbientLightingParams : register(c196);
sampler2D DiffuseSampler : register(s0);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDepthFxParams : register(c18);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gLightAmbientDir0 : register(c72);
float4 gLightAmbientDir1 : register(c73);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
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
	r1.zw = float2(0.15, 1);
	r0.w = saturate(AmbientLightingParams.x * -r1.z + r1.w);
	r0.w = saturate(r0.w + 0.2);
	r0.w = r0.w * AmbientLightingParams.y;
	r0.w = i.color.x * r0.w + -i.color.x;
	r0.w = gAmbientOcclusionEffect.x * r0.w + i.color.x;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2 = normalize(r1.xyz);
	r1.x = dot(gLightAmbientDir1.xyz, r2.xyz);
	r1.x = saturate(r1.x + gLightAmbientDir0.w);
	r1.xyz = r1.xxx * gLightAmbient1.xyz;
	r1.w = dot(gLightAmbientDir0.xyz, r2.xyz);
	r2.x = dot(r2.xyz, -gDirectionalLight.xyz);
	r2.x = saturate(r2.x + -0.25);
	r2.x = r2.x * 1.3333334;
	r2 = r2.xxx * gDirectionalColour.xyz;
	r1.w = saturate(r1.w + gLightAmbientDir0.w);
	r1.xyz = r1.www * gLightAmbient0.xyz + r1.xyz;
	r1.xyz = r1.xyz * r0.www + r2.xyz;
	r2.x = exp2(r0.x);
	r2.y = exp2(r0.y);
	r2.z = exp2(r0.z);
	r0.xyz = r1.xyz * r2.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.w = r0.w + 1E-05;
	r0.w = abs(r0.w) + 1E-05;
	r1.x = saturate(-i.texcoord1.w * gDepthFxParams.z + gDepthFxParams.w);
	r1.y = -r1.x + 1;
	r1.x = r1.y * gDepthFxParams.y + r1.x;
	r1.x = r1.x + -0.99999;
	r2.x = pow(r0.w, r1.x);
	r0.xyz = r0.xyz * r2.xxx + -globalFogColorN.xyz;
	r1.xyz = float3(0, 0, -512) + -i.texcoord3.xyz;
	r0.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = r0.w * -1.442695;
	r1.y = exp2(r1.y);
	r1.y = -r1.y + 1;
	r1.z = 1 / r0.w;
	r0.w = -abs(r0.w) + 0.0001;
	r1.y = r1.z * r1.y;
	r1.y = r1.y * r1.x;
	r0.w = (r0.w >= 0) ? r1.x : r1.y;
	r0.w = r0.w * -globalFogParams.y;
	r0.w = r0.w * 1.442695;
	r0.w = saturate(exp2(r0.w));
	r0.xyz = r0.www * r0.xyz + globalFogColorN.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = -r0.www + r0.xyz;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;

	return o;
}
