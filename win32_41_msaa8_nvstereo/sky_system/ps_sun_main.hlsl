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
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float3 r0;
	r0 = i.texcoord.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = saturate(r0.x * r0.z);
	r0.x = r0.x / zenithConstants.x;
	r0.x = saturate(r0.x * 0.5);
	o.xyz = r0.xxx * sunDiscColor.xyz;
	o.w = 1;

	return o;
}
