cbuffer Dome : register(b1)
{
	float3 SkyColor : packoffset(c0);
	float3 EastColor : packoffset(c1);
	float3 WestColor : packoffset(c2);
	float3 gSunDirection : packoffset(c3);
	float3 gSunColor : packoffset(c4);
	float3 gCloudColor : packoffset(c5);
	float3 gAmbientColor : packoffset(c6);
	float3 gBounceColor : packoffset(c7);
	float2 gDensityShiftScale : packoffset(c8);
	float4 gScatterG_GSquared_PhaseMult_Scale : packoffset(c9);
	float4 gPiercingLightPower_Strength_NormalStrength_Thickness : packoffset(c10);
	float3 gScaleDiffuseFillAmbient : packoffset(c11);
	float2 gWrapLighting : packoffset(c12);
	float gHDRExposure : packoffset(c12.z);
	float4 gNearFarQMult : packoffset(c13);
	float3 gAnimCombine : packoffset(c14);
	float3 gAnimSculpt : packoffset(c15);
	float3 gAnimBlendWeights : packoffset(c16);
	float2 gUVOffset[3] : packoffset(c17);
	float3 gReflScales : packoffset(c20);
};

SamplerState DensitySampler : register(s0);
SamplerState NormalSampler : register(s1);
Texture2D DensitySampler_tex : register(t0);
Texture2D NormalSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float3 texcoord8 : TEXCOORD8;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xy = NormalSampler_tex.Sample(NormalSampler, i.texcoord4.xy).yw;
	r0.xy = r0.yx * float2(2, 2) + float2(-1, -1);
	r0.z = -(r0.x) * r0.x + 1;
	r0.z = -(r0.y) * r0.y + r0.z;
	r0.z = max(r0.z, 0);
	r0.z = sqrt(r0.z);
	r1.xyz = r0.yyy * i.texcoord3.xyz;
	r0.xyw = r0.xxx * i.texcoord2.xyz + r1.xyz;
	r0.xyz = r0.zzz * i.texcoord1.xyz + r0.xyw;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.xy = r0.zx * r0.ww + float2(1, 1);
	r1.zw = -(r0.zx) * r0.ww + float2(1, 1);
	r0.xyz = r0.www * r0.xyz;
	r0.w = r1.z + r1.x;
	r0.w = r1.y + r0.w;
	r0.w = r1.w + r0.w;
	r0.w = r0.w + 0.00000999999975;
	r1 = r0.zzxx * float4(1, -1, 1, -1) + float4(1, 1, 1, 1);
	r1 = r1 / r0.w;
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
	r0.yzw = gAmbientColor.xyz * gScaleDiffuseFillAmbient.zzz + r0.yzw;
	r1.x = DensitySampler_tex.Sample(DensitySampler, i.texcoord4.xy).y;
	r1.x = -(r1.x) * r1.x + 1;
	r1.x = r1.x + -(gDensityShiftScale.x);
	r1.x = saturate(r1.x * gDensityShiftScale.y);
	r1.y = -(r1.x) + 1;
	o.w = r1.x;
	r1.x = -(gPiercingLightPower_Strength_NormalStrength_Thickness.w) + 1;
	r1.x = saturate(r1.y * gPiercingLightPower_Strength_NormalStrength_Thickness.w + r1.x);
	r1.yzw = r1.xxx * i.texcoord8.xyz;
	r0.yzw = gCloudColor.xyz * r0.yzw + r1.yzw;
	r1.y = r0.x * i.texcoord7.w;
	r0.x = -(r0.x) * i.texcoord7.w + i.texcoord7.w;
	r0.x = i.texcoord7.w * r0.x + r1.y;
	r0.x = r1.x * r0.x;
	r1.xyz = r0.xxx * gSunColor.xyz;
	r0.xyz = r1.xyz * gPiercingLightPower_Strength_NormalStrength_Thickness.yyy + r0.yzw;
	r0.xyz = r0.xyz * gHDRExposure;
	r0.xyz = r0.xyz * gReflScales.zzz;
	r0.xyz = saturate(r0.xyz * float3(0.0625, 0.0625, 0.0625));
	o.xyz = sqrt(r0.xyz);

	return o;
}
