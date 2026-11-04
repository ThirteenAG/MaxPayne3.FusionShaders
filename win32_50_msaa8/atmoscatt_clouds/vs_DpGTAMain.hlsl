cbuffer _Globals : register(b1)
{
	float4 SunDirection : packoffset(c132);
	float3 SkyColor : packoffset(c133);
	float3 AzimuthColor : packoffset(c134);
	float3 SunColor : packoffset(c135);
	float UnderLightStrength : packoffset(c136);
	float3 gtaSkyDomeFade : packoffset(c137);
	float3 gtaWaterColor : packoffset(c138);
	float MoonGlow : packoffset(c139);
	float2 SunAxias : packoffset(c140);
	float3 AzimuthColorEast : packoffset(c141);
	float AzimuthHeight : packoffset(c142);
	float4 CloudColor : packoffset(c143);
	float4 SunsetColor : packoffset(c144);
	float AzimuthStrength : packoffset(c145);
	float CloudThreshold : packoffset(c146);
	float CloudBias : packoffset(c147);
	float CloudFadeOut : packoffset(c148);
	float TopCloudHeight : packoffset(c149);
	float TopCloudDetail : packoffset(c150);
	float TopCloudThreshold : packoffset(c151);
	float4 TopCloudBiasDetailThresholdHeight : packoffset(c152);
	float3 TopCloudColor : packoffset(c153);
	float TopCloudLight : packoffset(c154);
	float CloudShadowStrength : packoffset(c155);
	float CloudShadowOffset : packoffset(c156);
	float4 CloudThicknessEdgeSmoothDetailScaleStrength : packoffset(c157);
	float CloudInscatteringRange : packoffset(c158);
	float4 StarFieldBrightness : packoffset(c159);
	float StarFieldUVRepeat : packoffset(c160);
	float2 GalaxyOffset : packoffset(c161);
	float4 MoonTexPosition : packoffset(c162);
	float4 MoonLight : packoffset(c163);
	float StarThreshold : packoffset(c164);
	float MoonVisiblity : packoffset(c165);
	float4 MoonColorConstant : packoffset(c166);
	float3 MoonPosition : packoffset(c167);
	float3 MoonXVector : packoffset(c168);
	float3 MoonYVector : packoffset(c169);
	float2 DetailOffset : packoffset(c170);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
};

struct VS_IN
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	r0.xyz = asint(i.position.yyy * gWorldView[1].xyz);
	r0.xyz = asint(i.position.xxx * gWorldView[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.position.zzz * gWorldView[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + gWorldView[3].xyz);
	r0.w = asint(asfloat(r0.z) + 512);
	r0.w = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r0.z = asint(asfloat(r0.z) + 512);
	r1.x = asint(asfloat(r0.z) / asfloat(r0.w));
	r1.yz = asint(asfloat(r0.zz) * float2(0.000399999990, -0.000399999990));
	r0.z = asint(-(asfloat(r1.x)) + 1);
	r0.z = asint(asfloat(r0.z) * asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) + 1);
	r0.w = asint(1 / asfloat(r0.w));
	r2.z = asint(-(asfloat(r0.w)) + 1);
	r0.z = asint(1 / asfloat(r0.z));
	r2.xy = asint(asfloat(r0.zz) * asfloat(r0.xy));
	r0.x = asint(max(asfloat(r1.z), -1));
	r1.y = asint(saturate(asfloat(r1.y)));
	r1.y = asint(asfloat(r1.y) * 0.200000003 + 1);
	r0.x = asint(min(asfloat(r0.x), 1));
	r1.x = asint(-(asfloat(r0.x)) * 0.200000003 + 1);
	r1.z = 1065353216;
	r0.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xyz));
	o.texcoord.z = -(asfloat(r2.z)) * asfloat(r1.z) + 1;
	o.sv_position.xyz = asfloat(r0.xyz);
	o.sv_position.w = 1;
	o.texcoord.xy = i.texcoord.xy;
	r0.xyz = asint(i.position.yyy * gWorld[1].xyz);
	r0.xyz = asint(i.position.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.position.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.position.www * gWorld[3].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + -(gWorld[3].xyz));
	o.texcoord1 = asfloat(r0.xyz);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xy = asint(-(asfloat(r0.xz)) * asfloat(r0.ww) + SunDirection.xz);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r1.z = asint(0.100000001 * CloudShadowOffset);
	r1.xy = asint(asfloat(r1.xy) * asfloat(r1.zz));
	r1.zw = asint(i.texcoord.xy * float2(2, 2) + float2(-1, -1));
	r1.z = asint(dot(asfloat(r1.zw), asfloat(r1.zw)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	o.texcoord2.xy = asfloat(r1.xy) * asfloat(r1.zz) + i.texcoord.xy;
	r1.xy = asint(i.texcoord.xy + float2(-0.5, -0.5));
	r1.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.w = asint(asfloat(r1.z) + 0.00000999999975);
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xy = asint(asfloat(r1.ww) * asfloat(r1.xy));
	r1.w = (asfloat(r1.z) == 0) ? -1 : 0;
	r2.xy = (r1.ww != 0) ? int2(0, 0) : r2.xy;
	r1.zw = asint(asfloat(r1.zz) * asfloat(r2.xy));
	o.texcoord2.zw = asfloat(r1.zw) * CloudThicknessEdgeSmoothDetailScaleStrength.zz + DetailOffset.xy;
	r0.w = asint(asfloat(r0.y) * 1.5);
	r2.xyz = asint(asfloat(r0.xwz) + float3(0.00000999999975, 0.500010014, 0.00000999999975));
	r0.z = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r0.zw = asint(asfloat(r0.zz) * asfloat(r2.xz));
	r1.zw = asint(abs(asfloat(r0.zw)) * float2(-0.0187292993, -0.0187292993) + float2(0.0742610022, 0.0742610022));
	r1.zw = asint(asfloat(r1.zw) * abs(asfloat(r0.zw)) + float2(-0.212114394, -0.212114394));
	r1.zw = asint(asfloat(r1.zw) * abs(asfloat(r0.zw)) + float2(1.57072878, 1.57072878));
	r2.xy = asint(-(abs(asfloat(r0.zw))) + float2(1, 1));
	r0.zw = (asfloat(r0.zw) < -(asfloat(r0.zw))) ? -1 : 0;
	r2.xy = asint(sqrt(asfloat(r2.xy)));
	r2.zw = asint(asfloat(r1.zw) * asfloat(r2.xy));
	r2.zw = asint(asfloat(r2.zw) * float2(-2, -2) + float2(3.14159274, 3.14159274));
	r0.zw = r0.zw & r2.zw;
	r0.zw = asint(asfloat(r1.zw) * asfloat(r2.xy) + asfloat(r0.zw));
	r0.zw = asint(-(asfloat(r0.zw)) + float2(1.57079637, 1.57079637));
	r0.zw = asint(asfloat(r0.zw) * float2(0.317732662, 0.317732662) + GalaxyOffset.xy);
	r0.zw = asint(asfloat(r0.zw) + float2(0.5, 0.5));
	o.texcoord3.xy = asfloat(r0.zw) * StarFieldUVRepeat;
	o.texcoord3.zw = asfloat(r0.zw);
	r0.zw = asint(asfloat(r1.xy) * TopCloudBiasDetailThresholdHeight.ww);
	o.texcoord4.xy = asfloat(r1.xy) * TopCloudBiasDetailThresholdHeight.ww + float2(0.5, 0.5);
	r0.z = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	o.texcoord4.z = -(asfloat(r0.z)) + 1;
	r0.y = asint(saturate(asfloat(r0.y) * AzimuthHeight));
	r0.x = asint(asfloat(r0.x) * 0.5 + 0.5);
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(asfloat(r0.y) * AzimuthStrength);
	r1.xyz = asint(AzimuthColor.xyz + -(AzimuthColorEast.xyz));
	r0.xzw = asint(asfloat(r0.xxx) * asfloat(r1.xyz) + AzimuthColorEast.xyz);
	o.texcoord5 = asfloat(r0.xzw) * asfloat(r0.yyy) + SkyColor.xyz;

	return o;
}
