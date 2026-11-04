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
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	float3 r1;
	int3 r2;
	r0.xyz = i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.y = dot(r0.xyz, SunDirection.xyz);
	r0.z = saturate(1 + -(HDRSunExposure.y));
	r0.x = r0.z * r0.y;
	r1.x = r0.z * -11.6163721;
	r1.yz = float2(0.9375, 0.5);
	r0.xyz = saturate(r0.xyy * float3(12.5799999, -0.0625, 0.5) + r1.xyz);
	r0.xy = r0.xy + float2(0.00000999999975, 0.00000999999975);
	r0.xy = log2(r0.xy);
	r0.xy = r0.xy * float2(32.0000114, 3.00001001);
	r0.xy = exp2(r0.xy);
	r0.w = saturate(0.600000024 + SunDirection.w);
	r0.x = -(r0.y) * r0.w + r0.x;
	r0.x = r0.z * SunSize + r0.x;
	r0.y = saturate(r0.z * SunCentre.y + SunCentre.x);
	r0.x = saturate(r0.x * 0.5);
	r0.z = r0.y * r0.y;
	r0.y = r0.y * -2 + 3;
	r0.y = r0.y * r0.z;
	r0.y = r0.y * SunCentre.z;
	r0.x = r0.x * 4 + r0.y;
	r0.yzw = r0.xxx * SunColor.xyz;
	r0.yzw = abs(r0.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.yzw = log2(r0.yzw);
	r0.yzw = r0.yzw * float3(4.00001001, 4.00001001, 4.00001001);
	r0.yzw = exp2(r0.yzw);
	r0.yzw = r0.xxx * SunColor.xyz + r0.yzw;
	r0.x = saturate(-(r0.x) + 1);
	r0.x = r0.x * HDRSunExposure.x;
	r1 = saturate(r0.xxx * i.texcoord5.xyz);
	r0.xyz = r0.yzw * HDRSunExposure.xxx + r1.xyz;
	r0.xyz = r0.xyz * HDRExposure;
	r0.xyz = min(r0.xyz, HDRExposureClamp.xyz);
	r0.xyz = min(r0.xyz, HDRExposureClamp.xyz);
	r1 = abs(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1 = log2(r1.xyz);
	r1 = r1.xyz * float3(0.250010014, 0.250010014, 0.250010014);
	r1 = exp2(r1.xyz);
	r2 = (r0.xyz < float3(1, 1, 1)) ? -1 : 0;
	r0.xyz = (r2.xyz != 0) ? r1.xyz : r0.xyz;
	r1 = -(r0.xyz) + gtaWaterColor.xyz;
	r0.w = -(i.texcoord1.y) + gtaSkyDomeFade.x;
	r0.w = saturate(r0.w * gtaSkyDomeFade.y);
	r0.xyz = r0.www * r1.xyz + r0.xyz;
	r0.xyz = saturate(r0.xyz * float3(0.0625, 0.0625, 0.0625));
	r1 = sqrt(r0.xyz);
	r1 = r1.xyz * float3(-2, -2, -2) + float3(3, 3, 3);
	o.sv_target.xyz = r0.xyz * r1.xyz;
	o.sv_target.w = 1;
	o.sv_target1 = float4(64, 64, 64, 64);

	return o;
}
