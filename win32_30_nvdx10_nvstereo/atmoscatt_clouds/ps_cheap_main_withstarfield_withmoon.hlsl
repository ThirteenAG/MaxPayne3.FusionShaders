float HDRExposure : register(c173);
float3 HDRExposureClamp : register(c175);
float3 HDRSunExposure : register(c174);
float3 SunCentre : register(c130);
float3 SunColor : register(c135);
float4 SunDirection : register(c132);
float SunSize : register(c171);
float3 gtaSkyDomeFade : register(c137);
float3 gtaWaterColor : register(c138);

struct PS_IN
{
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	float3 r3;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r1 = normalize(r0.xyz);
	r0.y = dot(r1.xyz, SunDirection.xyz);
	r1.y = 1;
	r0.z = saturate(r1.y + -HDRSunExposure.y);
	r0.x = r0.z * r0.y;
	r1.x = r0.z * -11.616372;
	r1.yz = float2(0.9375, 0.5);
	r0.xyz = saturate(r0.xyy * float3(12.58, -0.0625, 0.5) + r1.xyz);
	r0.xy = r0.xy + 1E-05;
	r1.x = pow(r0.x, 32.00001);
	r1.y = pow(r0.y, 3.00001);
	r0.y = 0.6;
	r0.x = saturate(r0.y + SunDirection.w);
	r0.x = r1.y * -r0.x + r1.x;
	r0.x = r0.z * SunSize.x + r0.x;
	r0.y = saturate(r0.z * SunCentre.y + SunCentre.x);
	r0.x = saturate(r0.x * 0.5);
	r0.z = r0.y * r0.y;
	r0.y = r0.y * -2 + 3;
	r0.y = r0.y * r0.z;
	r0.y = r0.y * SunCentre.z;
	r0.x = r0.x * 4 + r0.y;
	r0.yzw = r0.xxx * SunColor.xyz;
	r0.yzw = abs(r0.yzw) + 1E-05;
	r1.x = log2(r0.y);
	r1.y = log2(r0.z);
	r1.z = log2(r0.w);
	r0.yzw = r1.xyz * 4.00001;
	r1.x = exp2(r0.y);
	r1.y = exp2(r0.z);
	r1.z = exp2(r0.w);
	r0.yzw = r0.xxx * SunColor.xyz + r1.xyz;
	r0.x = saturate(-r0.x + 1);
	r0.x = r0.x * HDRSunExposure.x;
	r1 = saturate(r0.xxx * i.texcoord5.xyz);
	r0.xyz = half3(r0.yzw * HDRSunExposure.xxx + r1.xyz);
	r0.xyz = r0.xyz * HDRExposure.xxx;
	r1 = min(r0.xyz, HDRExposureClamp.xyz);
	r0.xyz = min(HDRExposureClamp.xyz, r1.xyz);
	r1 = r0.xyz + -1;
	r2 = abs(r0.xyz) + 1E-05;
	r3.x = log2(r2.x);
	r3.y = log2(r2.y);
	r3.z = log2(r2.z);
	r2 = r3.xyz * 0.25001;
	r3.x = exp2(r2.x);
	r3.y = exp2(r2.y);
	r3.z = exp2(r2.z);
	r0.xyz = (r1.xyz >= 0) ? r0.xyz : r3.xyz;
	r0.w = gtaSkyDomeFade.x + -i.texcoord1.y;
	r0.w = saturate(r0.w * gtaSkyDomeFade.y);
	r1 = lerp(r0.xyz, gtaWaterColor.xyz, r0.www);
	r0.xyz = saturate(r1.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r1.x = saturate(1 / r0.x);
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	r1.z = saturate(1 / r0.y);
	r1.y = saturate(1 / r0.x);
	r0.xyz = r1.xyz * -2 + 3;
	r1 = r1.xyz * r1.xyz;
	o.xyz = r0.xyz * r1.xyz;
	o.w = 1;

	return o;
}
