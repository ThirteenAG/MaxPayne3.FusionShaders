float3 HDRExposureClamp : register(c175);
float3 HDRSunExposure : register(c174);
float3 SunCentre : register(c130);
float3 SunColor : register(c135);
float4 SunDirection : register(c132);

float4 main(float4 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = texcoord.www * float3(0, 0, 1) + float3(1E-05, 1E-05, 0);
	r0.xyz = r0.xyz + float3(0, 0, 1E-05);
	r0.w = dot(r0.yyz, r0.yyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.zw = float2(1E-05, 0.5);
	r1.xyz = r1.zzz + SunDirection.xyz;
	r2 = normalize(r1.xyz);
	r0.x = dot(r0.xyz, r2.xyz);
	r0.x = r0.x + 1;
	r0.x = r0.x * r1.w + -SunCentre.x;
	r0.y = -SunCentre.x + SunCentre.y;
	r0.y = 1 / r0.y;
	r0.x = saturate(r0.y * r0.x);
	r0.y = r0.x * -2 + 3;
	r0.x = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = r0.x * SunCentre.z;
	r0.x = r0.x * 4;
	r0.yzw = r0.xxx * SunColor.xyz;
	r0.yzw = abs(r0.yzw) + 1E-05;
	r1.x = log2(r0.y);
	r1.y = log2(r0.z);
	r1.z = log2(r0.w);
	r0.yzw = r1.xyz * 4.00001;
	r1.x = exp2(r0.y);
	r1.y = exp2(r0.z);
	r1.z = exp2(r0.w);
	r0.xyz = r0.xxx * SunColor.xyz + r1.xyz;
	r0.xyz = r0.xyz * HDRSunExposure.xxx;
	o.xyz = min(HDRExposureClamp.xyz, r0.xyz);
	o.w = 1;

	return o;
}
