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
	float SunSize : packoffset(c171);
	float TimeOfDay : packoffset(c172);
	float HDRExposure : packoffset(c173);
	float3 HDRSunExposure : packoffset(c174);
	float3 HDRExposureClamp : packoffset(c175);
};

cbuffer Sun : register(b4)
{
	float3 SunCentre : packoffset(c0);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float3 r1;
	r0.xy = float2(0.00000999999975, 0.00000999999975);
	r0.z = i.texcoord.w;
	r0.xyz = r0.xyz + float3(0, 0, 0.00000999999975);
	r0.w = dot(r0.yyz, r0.yyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1 = float3(0.00000999999975, 0.00000999999975, 0.00000999999975) + SunDirection.xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1 = r0.www * r1.xyz;
	r0.x = dot(r0.xyz, r1.xyz);
	r0.x = r0.x + 1;
	r0.x = r0.x * 0.5 + -(SunCentre.x);
	r0.y = -(SunCentre.x) + SunCentre.y;
	r0.y = 1 / r0.y;
	r0.x = saturate(r0.y * r0.x);
	r0.y = r0.x * -2 + 3;
	r0.x = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = r0.x * SunCentre.z;
	r0.x = r0.x * 4;
	r0.yzw = r0.xxx * SunColor.xyz;
	r0.yzw = abs(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.yzw = log2(r0.yzw);
	r0.yzw = r0.yzw * float3(4.00001001, 4.00001001, 4.00001001);
	r0.yzw = exp2(r0.yzw);
	r0.xyz = r0.xxx * SunColor.xyz + r0.yzw;
	r0.xyz = r0.xyz * HDRSunExposure.xxx;
	o.xyz = min(r0.xyz, HDRExposureClamp.xyz);
	o.w = 1;

	return o;
}
