cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

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
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = gViewInverse[3].xyz + -(sunPosition.xyz);
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.xyz = r0.yzx * float3(1, 0, 0);
	r1.xyz = r0.zxy * float3(0, 1, 0) + -(r1.xyz);
	r1.xyz = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * r1.xyz;
	r2 = r0.zxy * r1.yzx;
	r2 = r0.yzx * r1.zxy + -(r2.xyz);
	r0.xyz = r0.xyz * position.yyy;
	r0.xyz = position.xxx * r1.xyz + r0.xyz;
	r0.xyz = position.zzz * r2.xyz + r0.xyz;
	r0.xyz = r0.xyz + sunPosition.xyz;
	r1 = r0.y * gWorldView[1];
	r1 = r0.x * gWorldView[0] + r1;
	r1 = r0.z * gWorldView[2] + r1;
	r1 = r1 + gWorldView[3];
	r1.xyz = r1.xyz / r1.www;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = sqrt(r0.w);
	r1.xyz = r1.xyz / r0.www;
	r0.w = r0.w + -1;
	o.sv_position.z = r0.w * 0.0000400015997;
	r0.w = r1.z + 1;
	o.sv_position.xy = r1.xy / r0.ww;
	o.sv_position.w = 1;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r0.xyw;
	o.texcoord = position.www * gWorld[3].xyz + r0.xyz;

	return o;
}
