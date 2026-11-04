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
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	float3 r4;
	r0 = asint(position.y * gWorldViewProj[1]);
	r0 = asint(position.x * gWorldViewProj[0] + asfloat(r0));
	r0 = asint(position.z * gWorldViewProj[2] + asfloat(r0));
	o.sv_position = position.w * gWorldViewProj[3] + asfloat(r0);
	r0.xyz = asint(position.yyy * gWorld[1].xyz);
	r0.xyz = asint(position.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(position.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(position.www * gWorld[3].xyz + asfloat(r0.xyz));
	o.texcoord1 = asfloat(r0.xyz);
	r1.xy = -(gViewInverse[3].xy);
	r1.z = -(horizonLevel);
	r0.xyz = asint(asfloat(r0.xyz) + r1.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r0.xy = asint(asfloat(r0.yy) * asfloat(r0.xz));
	r0.z = asint(abs(asfloat(r0.y)) + -(zenithConstants.x));
	r0.w = asint(-(zenithConstants.x) + 1);
	r0.z = asint(asfloat(r0.z) / asfloat(r0.w));
	r0.x = asint(asfloat(r0.x) * -0.5 + 0.5);
	r0.w = asint(asfloat(r0.x) + -(azimuthTransitionPosition));
	r1.x = -(azimuthTransitionPosition) + 1;
	r0.w = asint(asfloat(r0.w) / r1.x);
	r1.xyz = azimuthWestColor.xyz + -(azimuthTransitionColor.xyz);
	r1.xyz = asfloat(r0.www) * r1.xyz + azimuthTransitionColor.xyz;
	r0.w = asint(asfloat(r0.x) / azimuthTransitionPosition);
	r2 = -(azimuthEastColor.xyz) + azimuthTransitionColor.xyz;
	r2 = asfloat(r0.www) * r2.xyz + azimuthEastColor.xyz;
	r0.w = (asfloat(r0.x) < azimuthTransitionPosition) ? -1 : 0;
	r1.xyz = (r0.www != 0) ? r2.xyz : r1.xyz;
	r2 = -(r1.xyz) + zenithTransitionColor.xyz;
	r0.w = asint(-(zenithConstants.y) + zenithConstants.z);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w) + zenithConstants.y);
	r3 = asfloat(r0.xxx) * r2.xyz + r1.xyz;
	r2 = r2.xyz * asfloat(r0.xxx);
	r4 = -(r3.xyz) + zenithColor.xyz;
	r0.xzw = asint(asfloat(r0.zzz) * r4.xyz + r3.xyz);
	r1.w = abs(asfloat(r0.y)) / zenithConstants.x;
	r0.y = (abs(asfloat(r0.y)) < zenithConstants.x) ? -1 : 0;
	r1.xyz = r1.www * r2.xyz + r1.xyz;
	r0.xyz = (r0.yyy != 0) ? asint(r1.xyz) : r0.xzw;
	r0.xyz = asint(asfloat(r0.xyz) * hdrIntensity);
	r0.w = asint(dot(asfloat(r0.xyz), float3(0.300000012, 0.589999974, 0.109999999)));
	o.texcoord2.xyz = asfloat(r0.xyz);
	o.texcoord2.w = asfloat(r0.w) * cloudConstants3.x;

	return o;
}
