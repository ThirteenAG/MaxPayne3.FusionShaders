float3 azimuthEastColor : register(c130);
float3 azimuthTransitionColor : register(c132);
float azimuthTransitionPosition : register(c133);
float3 azimuthWestColor : register(c131);
float4 cloudConstants3 : register(c153);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float hdrIntensity : register(c137);
float horizonLevel : register(c157);
float3 zenithColor : register(c134);
float3 zenithConstants : register(c136);
float3 zenithTransitionColor : register(c135);

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0 = gWorldViewProj[1] * position.y;
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	o.position = position.w * gWorldViewProj[3] + r0;
	r0.w = 1;
	r0.x = r0.w + -azimuthTransitionPosition.x;
	r0.x = 1 / r0.x;
	r1.xyz = gWorld[1].xyz * position.yyy;
	r1.xyz = position.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = position.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = position.www * gWorld[3].xyz + r1.xyz;
	r2.xy = -gViewInverse[3].xy;
	r2.z = -horizonLevel.x;
	r2 = r1.xyz + r2.xyz;
	o.texcoord1 = r1.xyz;
	r1.xyz = r2.xyz + 1E-05;
	r0.y = dot(r1.xyz, r1.xyz);
	r0.y = rsqrt(r0.y);
	r0.yz = r0.yy * r1.xz;
	r0.y = r0.y * -0.5 + 0.5;
	r1.x = r0.y + -azimuthTransitionPosition.x;
	r0.x = r0.x * r1.x;
	r1.xyz = azimuthTransitionColor.xyz;
	r2 = -r1.xyz + azimuthWestColor.xyz;
	r2 = r0.xxx * r2.xyz + azimuthTransitionColor.xyz;
	r0.x = 1 / azimuthTransitionPosition.x;
	r0.x = r0.x * r0.y;
	r3 = lerp(azimuthEastColor.xyz, r1.xyz, r0.xxx);
	r0.x = (r0.y < azimuthTransitionPosition.x) ? 1 : 0;
	r1.x = lerp(zenithConstants.y, zenithConstants.z, r0.y);
	r1.yzw = lerp(r2.xyz, r3.xyz, r0.xxx);
	r2 = -r1.yzw + zenithTransitionColor.xyz;
	r2 = r1.xxx * r2.xyz;
	r3 = lerp(r1.yzw, zenithTransitionColor.xyz, r1.xxx);
	r0.x = 1 / zenithConstants.x;
	r0.x = r0.x * abs(r0.z);
	r1.xyz = r0.xxx * r2.xyz + r1.yzw;
	r0.x = abs(r0.z) + -zenithConstants.x;
	r0.y = (abs(r0.z) < zenithConstants.x) ? 1 : 0;
	r0.z = r0.w + -zenithConstants.x;
	r0.z = 1 / r0.z;
	r0.x = r0.z * r0.x;
	r2 = lerp(r3.xyz, zenithColor.xyz, r0.xxx);
	r3 = lerp(r2.xyz, r1.xyz, r0.yyy);
	r0.xyz = r3.xyz * hdrIntensity.xxx;
	r0.w = dot(r0.xyz, float3(0.3, 0.59, 0.11));
	o.texcoord2.xyz = r0.xyz;
	o.texcoord2.w = r0.w * cloudConstants3.x;

	return o;
}
