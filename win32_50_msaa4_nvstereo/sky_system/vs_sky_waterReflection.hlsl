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
	float starfieldIntensity : packoffset(c23);
	float3 moonDirection : packoffset(c23.y);
	float3 moonPosition : packoffset(c24);
	float moonIntensity : packoffset(c24.w);
	float3 lunarCycle : packoffset(c25);
	float3 moonColor : packoffset(c26);
	float4 moonTexConvert : packoffset(c27);
};

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
	float2 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
	float2 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	r0 = i.position.y * gWorldViewProj[1];
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = i.position.w * gWorldViewProj[3] + r0;
	o.sv_position = r0;
	r1.xy = asint(i.texcoord.xy * float2(2, 2) + float2(-1, -1));
	r0.z = dot(asfloat(r1.xy), asfloat(r1.xy));
	r0.z = -(r0.z) + 1;
	r1.xyz = asint(i.position.yyy * gWorld[1].xyz);
	r1.xyz = asint(i.position.xxx * gWorld[0].xyz + asfloat(r1.xyz));
	r1.xyz = asint(i.position.zzz * gWorld[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(i.position.www * gWorld[3].xyz + asfloat(r1.xyz));
	r2.xy = -(gViewInverse[3].xy);
	r2.z = -(horizonLevel);
	r2.xyz = asfloat(r1.xyz) + r2.xyz;
	o.texcoord1 = asfloat(r1.xyz);
	r1.xyz = asint(r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xy = -(asfloat(r1.xy)) * asfloat(r1.ww) + sunDirection.xy;
	r1.xy = asint(asfloat(r1.ww) * asfloat(r1.xz));
	r1.z = asint(cloudConstants2.y * 0.100000001);
	r1.zw = asint(r2.xy * asfloat(r1.zz));
	o.texcoord.zw = -(asfloat(r1.zw)) * r0.zz + i.texcoord.xy;
	o.texcoord.xy = i.texcoord.xy;
	r0.z = abs(asfloat(r1.y)) + -(zenithConstants.x);
	r1.z = asint(-(zenithConstants.x) + 1);
	r0.z = r0.z / asfloat(r1.z);
	r1.x = asint(asfloat(r1.x) * -0.5 + 0.5);
	r1.z = asint(asfloat(r1.x) + -(azimuthTransitionPosition));
	r1.w = asint(-(azimuthTransitionPosition) + 1);
	r1.z = asint(asfloat(r1.z) / asfloat(r1.w));
	r2.xyz = azimuthWestColor.xyz + -(azimuthTransitionColor.xyz);
	r2.xyz = asfloat(r1.zzz) * r2.xyz + azimuthTransitionColor.xyz;
	r1.z = asint(asfloat(r1.x) / azimuthTransitionPosition);
	r3 = -(azimuthEastColor.xyz) + azimuthTransitionColor.xyz;
	r3 = asfloat(r1.zzz) * r3.xyz + azimuthEastColor.xyz;
	r1.z = (asfloat(r1.x) < azimuthTransitionPosition) ? -1 : 0;
	r2.xyz = (r1.zzz != 0) ? r3.xyz : r2.xyz;
	r3 = -(r2.xyz) + zenithTransitionColor.xyz;
	r1.z = asint(-(zenithConstants.y) + zenithConstants.z);
	r1.x = asint(asfloat(r1.x) * asfloat(r1.z) + zenithConstants.y);
	r4 = asfloat(r1.xxx) * r3.xyz + r2.xyz;
	r1.xzw = asint(r3.xyz * asfloat(r1.xxx));
	r3 = -(r4.xyz) + zenithColor.xyz;
	r3 = r0.zzz * r3.xyz + r4.xyz;
	r0.z = abs(asfloat(r1.y)) / zenithConstants.x;
	r1.y = (abs(asfloat(r1.y)) < zenithConstants.x) ? -1 : 0;
	r1.xzw = asint(r0.zzz * asfloat(r1.xzw) + r2.xyz);
	r1.xyz = (r1.yyy != 0) ? r1.xzw : asint(r3.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * hdrIntensity);
	o.texcoord2.xyz = asfloat(r1.xyz);
	r0.z = dot(asfloat(r1.xyz), float3(0.300000012, 0.589999974, 0.109999999));
	o.texcoord2.w = r0.z * cloudConstants3.x;
	r1.xy = asint(i.texcoord.xy + float2(-0.5, -0.5));
	r2 = asfloat(r1.xyyx) * cloudDetailConstants.yyww + float4(0.5, 0.5, 0.5, 0.5);
	r1.xy = asint(asfloat(r1.xy) * smallCloudConstants.xx + float2(0.5, 0.5));
	o.texcoord5 = speedConstants.xx * smallCloudConstants.xx + asfloat(r1.xy);
	o.texcoord3 = speedConstants.zzyy * cloudDetailConstants.yyww + r2;
	o.texcoord4 = i.texcoord.zw * float2(64, 64);
	r0.z = r0.w + 0.000000100000001;
	r0.xy = r0.xy / r0.zz;
	r0.xy = -(r0.xy) + moonTexConvert.xy;
	r0.xy = r0.xy * moonTexConvert.zw;
	o.texcoord7 = r0.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
	o.texcoord6 = i.texcoord.zw * float2(12, 12);

	return o;
}
