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
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	r0.xyz = i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.x = dot(r0.xyz, -(sunDirection.xyz));
	r0.y = -(sunConstants.x) * r0.x + sunConstants.y;
	r0.x = r0.x * r0.x + 1;
	r0.y = abs(r0.y) + 0.00000999999975;
	r0.y = log2(r0.y);
	r0.y = r0.y * 1.50001001;
	r0.y = exp2(r0.y);
	r0.x = r0.x / r0.y;
	r0.x = saturate(r0.x * sunConstants.z);
	r0.yzw = sunColor.xyz * sunHdrIntensity + -(i.texcoord2.xyz);
	r0.xyz = r0.xxx * r0.yzw + i.texcoord2.xyz;
	r0.xyz = r0.xyz * sphereReflectionSkyIntensity;
	r0.xyz = saturate(r0.xyz * float3(0.0625, 0.0625, 0.0625));
	o.sv_target.xyz = sqrt(r0.xyz);
	o.sv_target.w = 1;
	o.sv_target1 = float4(64, 64, 64, 64);

	return o;
}
