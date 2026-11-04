sampler2D DensitySampler : register(s0);
float3 EastColor : register(c22);
sampler2D NormalSampler : register(s1);
float3 SkyColor : register(c21);
float3 WestColor : register(c23);
float3 gAmbientColor : register(c27);
float3 gBounceColor : register(c28);
float3 gCloudColor : register(c26);
float2 gDensityShiftScale : register(c29);
float gHDRExposure : register(c34);
float4 gPiercingLightPower_Strength_NormalStrength_Thickness : register(c31);
float3 gScaleDiffuseFillAmbient : register(c32);
float3 gSunColor : register(c25);
float3 gSunDirection : register(c24);
float2 gWrapLighting : register(c33);

struct PS_IN
{
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
	float4 texcoord7 : TEXCOORD7;
	float3 texcoord8 : TEXCOORD8;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0 = tex2D(NormalSampler, i.texcoord4.xy);
	r0.xy = r0.wy * 2 + -1;
	r0.z = r0.x * -r0.x + 1;
	r0.z = r0.y * -r0.y + r0.z;
	r1.x = max(r0.z, 0);
	r0.z = rsqrt(r1.x);
	r0.z = 1 / r0.z;
	r1.xyz = r0.yyy * i.texcoord3.xyz;
	r0.xyw = r0.xxx * i.texcoord2.xyz + r1.xyz;
	r0.xyz = r0.zzz * i.texcoord1.xyz + r0.xyw;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.xy = r0.zx * r0.ww + 1;
	r1.zw = r0.zx * -r0.ww + 1;
	r0.xyz = r0.www * r0.xyz;
	r0.w = r1.z + r1.x;
	r0.w = r1.y + r0.w;
	r0.w = r1.w + r0.w;
	r0.w = r0.w + 1E-05;
	r0.w = 1 / r0.w;
	r1 = r0.zzxx * float4(1, -1, 1, -1) + 1;
	r1 = r0.w * r1;
	r2 = r1.yyy * gBounceColor.xyz;
	r2 = SkyColor.xyz * r1.xxx + r2.xyz;
	r1.xyz = EastColor.xyz * r1.zzz + r2.xyz;
	r1.xyz = WestColor.xyz * r1.www + r1.xyz;
	r0.w = dot(r0.xyz, gSunDirection.xyz);
	r0.x = saturate(dot(r0.xyz, i.texcoord7.xyz));
	r0.x = r0.x * gPiercingLightPower_Strength_NormalStrength_Thickness.z;
	r0.y = saturate(r0.w * gWrapLighting.x + gWrapLighting.y);
	r0.yzw = r0.yyy * gSunColor.xyz;
	r0.yzw = r0.yzw * gScaleDiffuseFillAmbient.xxx;
	r0.yzw = r1.xyz * gScaleDiffuseFillAmbient.yyy + r0.yzw;
	r1.z = gScaleDiffuseFillAmbient.z;
	r0.yzw = gAmbientColor.xyz * r1.zzz + r0.yzw;
	r1 = tex2D(DensitySampler, i.texcoord4.xy);
	r1.x = r1.y * -r1.y + 1;
	r1.x = r1.x + -gDensityShiftScale.x;
	r1.x = saturate(r1.x * gDensityShiftScale.y);
	r1.y = -r1.x + 1;
	o.w = r1.x;
	r1.x = 1;
	r1.x = r1.x + -gPiercingLightPower_Strength_NormalStrength_Thickness.w;
	r1.x = saturate(r1.y * gPiercingLightPower_Strength_NormalStrength_Thickness.w + r1.x);
	r1.yzw = r1.xxx * i.texcoord8.xyz;
	r0.yzw = gCloudColor.xyz * r0.yzw + r1.yzw;
	r1.y = r0.x * i.texcoord7.w;
	r0.x = r0.x * -i.texcoord7.w + i.texcoord7.w;
	r0.x = i.texcoord7.w * r0.x + r1.y;
	r0.x = r1.x * r0.x;
	r1.xyz = r0.xxx * gSunColor.xyz;
	r0.xyz = r1.xyz * gPiercingLightPower_Strength_NormalStrength_Thickness.yyy + r0.yzw;
	o.xyz = r0.xyz * gHDRExposure.xxx;

	return o;
}
