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

	int4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	float3 r4;
	r0 = asint(i.position.y * gWorldView[1]);
	r0 = asint(i.position.x * gWorldView[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldView[2] + asfloat(r0));
	r0 = asint(asfloat(r0) + gWorldView[3]);
	r0.xyz = asint(asfloat(r0.xyz) / asfloat(r0.www));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.xyz) / asfloat(r0.www));
	r0.zw = asint(asfloat(r0.zw) + float2(1, -1));
	o.sv_position.z = asfloat(r0.w) * 0.0000400015997;
	r0.xy = asint(asfloat(r0.xy) / asfloat(r0.zz));
	o.sv_position.xy = asfloat(r0.xy);
	r0.xy = asint(-(asfloat(r0.xy)) * float2(0.999999881, 0.999999881) + moonTexConvert.xy);
	r0.xy = asint(asfloat(r0.xy) * moonTexConvert.zw);
	o.texcoord7 = asfloat(r0.xy) * float2(0.5, 0.5) + float2(0.5, 0.5);
	o.sv_position.w = 1;
	r0.xy = asint(i.texcoord.xy * float2(2, 2) + float2(-1, -1));
	r0.x = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.yzw = asint(i.position.yyy * gWorld[1].xyz);
	r0.yzw = asint(i.position.xxx * gWorld[0].xyz + asfloat(r0.yzw));
	r0.yzw = asint(i.position.zzz * gWorld[2].xyz + asfloat(r0.yzw));
	r0.yzw = asint(i.position.www * gWorld[3].xyz + asfloat(r0.yzw));
	r1.xy = -(gViewInverse[3].xy);
	r1.z = -(horizonLevel);
	r1.xyz = asfloat(r0.yzw) + r1.xyz;
	o.texcoord1 = asfloat(r0.yzw);
	r0.yzw = asint(r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0.yzw), asfloat(r0.yzw));
	r1.x = rsqrt(r1.x);
	r1.yz = -(asfloat(r0.yz)) * r1.xx + sunDirection.xy;
	r0.yz = asint(asfloat(r0.yw) * r1.xx);
	r0.w = asint(cloudConstants2.y * 0.100000001);
	r1.xy = r1.yz * asfloat(r0.ww);
	o.texcoord.zw = -(r1.xy) * asfloat(r0.xx) + i.texcoord.xy;
	o.texcoord.xy = i.texcoord.xy;
	r0.x = asint(abs(asfloat(r0.z)) + -(zenithConstants.x));
	r0.w = asint(-(zenithConstants.x) + 1);
	r0.x = asint(asfloat(r0.x) / asfloat(r0.w));
	r0.y = asint(asfloat(r0.y) * -0.5 + 0.5);
	r0.w = asint(asfloat(r0.y) + -(azimuthTransitionPosition));
	r1.x = -(azimuthTransitionPosition) + 1;
	r0.w = asint(asfloat(r0.w) / r1.x);
	r1.xyz = azimuthWestColor.xyz + -(azimuthTransitionColor.xyz);
	r1.xyz = asfloat(r0.www) * r1.xyz + azimuthTransitionColor.xyz;
	r0.w = asint(asfloat(r0.y) / azimuthTransitionPosition);
	r2 = -(azimuthEastColor.xyz) + azimuthTransitionColor.xyz;
	r2 = asfloat(r0.www) * r2.xyz + azimuthEastColor.xyz;
	r0.w = (asfloat(r0.y) < azimuthTransitionPosition) ? -1 : 0;
	r1.xyz = (r0.www != 0) ? r2.xyz : r1.xyz;
	r2 = -(r1.xyz) + zenithTransitionColor.xyz;
	r0.w = asint(-(zenithConstants.y) + zenithConstants.z);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w) + zenithConstants.y);
	r3 = asfloat(r0.yyy) * r2.xyz + r1.xyz;
	r2 = r2.xyz * asfloat(r0.yyy);
	r4 = -(r3.xyz) + zenithColor.xyz;
	r0.xyw = asint(asfloat(r0.xxx) * r4.xyz + r3.xyz);
	r1.w = abs(asfloat(r0.z)) / zenithConstants.x;
	r0.z = (abs(asfloat(r0.z)) < zenithConstants.x) ? -1 : 0;
	r1.xyz = r1.www * r2.xyz + r1.xyz;
	r0.xyz = (r0.zzz != 0) ? asint(r1.xyz) : r0.xyw;
	r0.xyz = asint(asfloat(r0.xyz) * hdrIntensity);
	o.texcoord2.xyz = asfloat(r0.xyz);
	r0.x = asint(dot(asfloat(r0.xyz), float3(0.300000012, 0.589999974, 0.109999999)));
	o.texcoord2.w = asfloat(r0.x) * cloudConstants3.x;
	r0.xy = asint(i.texcoord.xy + float2(-0.5, -0.5));
	r1 = asfloat(r0.xyyx) * cloudDetailConstants.yyww + float4(0.5, 0.5, 0.5, 0.5);
	r0.xy = asint(asfloat(r0.xy) * smallCloudConstants.xx + float2(0.5, 0.5));
	o.texcoord5 = speedConstants.xx * smallCloudConstants.xx + asfloat(r0.xy);
	o.texcoord3 = speedConstants.zzyy * cloudDetailConstants.yyww + r1;
	o.texcoord4 = i.texcoord.zw * float2(64, 64);
	o.texcoord6 = i.texcoord.zw * float2(12, 12);

	return o;
}
