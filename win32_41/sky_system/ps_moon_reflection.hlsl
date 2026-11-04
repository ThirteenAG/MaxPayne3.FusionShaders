cbuffer SkySystem : register(b1)
{
	float3 azimuthEastColor : packoffset(c0);
	float3 azimuthWestColor : packoffset(c1);
	float3 azimuthTransitionColor : packoffset(c2);
	float azimuthTransitionPosition : packoffset(c2.w);
	float3 zenithColor : packoffset(c3);
	float3 zenithTransitionColor : packoffset(c4);
	float3 zenithConstants : packoffset(c5);
	float hdrIntensity : packoffset(c5.w);
	float sphereReflectionSkyIntensity : packoffset(c6);
	float waterReflectionSkyIntensity : packoffset(c6.y);
	float mirrorReflectionSkyIntensity : packoffset(c6.z);
	float3 sunColor : packoffset(c7);
	float3 sunDiscColor : packoffset(c8);
	float sunHdrIntensity : packoffset(c8.w);
	float4 sunConstants : packoffset(c9);
	float3 sunDirection : packoffset(c10);
	float3 sunPosition : packoffset(c11);
	float3 cloudBaseColour : packoffset(c12);
	float3 cloudMidColour : packoffset(c13);
	float3 cloudShadowColour : packoffset(c14);
	float4 cloudDetailConstants : packoffset(c15);
	float4 cloudConstants1 : packoffset(c16);
	float4 cloudConstants2 : packoffset(c17);
	float4 cloudConstants3 : packoffset(c18);
	float4 smallCloudConstants : packoffset(c19);
	float3 smallCloudColorXHdrIntensity : packoffset(c20);
	float4 effectsConstants : packoffset(c21);
	float horizonLevel : packoffset(c22);
	float3 speedConstants : packoffset(c22.y);
	float starfieldIntensity : packoffset(c23);
	float3 moonDirection : packoffset(c23.y);
	float3 moonPosition : packoffset(c24);
	float moonIntensity : packoffset(c24.w);
	float3 lunarCycle : packoffset(c25);
	float3 moonColor : packoffset(c26);
};

SamplerState moonSampler : register(s5);
Texture2D moonSampler_tex : register(t5);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.xy = i.texcoord.xy + float2(-0.5, -0.5);
	r0.xy = r0.xy + r0.xy;
	r0.x = dot(r0.xy, r0.xy);
	r0.x = -(r0.x) + 1;
	r0.x = max(r0.x, 0);
	r0.y = sqrt(r0.x);
	r0.xz = i.texcoord.xy * float2(2, 2) + float2(-1, -1);
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.xyz = lunarCycle.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * r1.xyz;
	r0.x = dot(r0.xyz, r1.xyz);
	r0.x = max(r0.x, 0);
	r1 = moonSampler_tex.Sample(moonSampler, i.texcoord.xy);
	r0.yzw = r1.xyz * moonColor.xyz;
	r0.xyz = r0.xxx * r0.yzw;
	r0.xyz = r1.www * r0.xyz;
	r0.xyz = r0.xyz * moonIntensity;
	r1.xyz = i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = saturate(r0.w * r1.z);
	r0.w = r0.w / zenithConstants.x;
	r0.w = saturate(r0.w + r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.xyz = r0.xyz * waterReflectionSkyIntensity;
	r0.xyz = saturate(r0.xyz * float3(0.0625, 0.0625, 0.0625));
	o.xyz = sqrt(r0.xyz);
	o.w = 1;

	return o;
}
