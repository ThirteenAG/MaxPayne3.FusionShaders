cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
	float4 gLightPointColR : packoffset(c16);
	float4 gLightPointColG : packoffset(c17);
	float4 gLightPointColB : packoffset(c18);
	float4 gLightPointPosX : packoffset(c19);
	float4 gLightPointPosY : packoffset(c20);
	float4 gLightPointPosZ : packoffset(c21);
	float4 gLightDir2X : packoffset(c22);
	float4 gLightDir2Y : packoffset(c23);
	float4 gLightDir2Z : packoffset(c24);
	float4 gLightConeScale2 : packoffset(c25);
	float4 gLightConeOffset2 : packoffset(c26);
	float4 gLightPointFallOff : packoffset(c27);
	float4 gDistFadeParams : packoffset(c28);
	float4 gAdrenoFXVars : packoffset(c29);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
};

cbuffer PoolWater : register(b4)
{
	float4 shaderVariables : packoffset(c0);
	float4 waterColor : packoffset(c1);
	float rippleScale : packoffset(c2);
	float2 nearFarClip : packoffset(c2.y);
};

SamplerState ReflectanceSampler : register(s2);
SamplerState WaterSurfaceSampler : register(s3);
SamplerState DepthSampler : register(s5);
Texture2D ReflectanceSampler_tex : register(t2);
Texture2D WaterSurfaceSampler_tex : register(t3);
Texture2D DepthSampler_tex : register(t5);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
	float sv_clipdistance : SV_ClipDistance;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = WaterSurfaceSampler_tex.Sample(WaterSurfaceSampler, i.texcoord.xy).xyz;
	r0.xyz = r0.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.xyz = i.texcoord1.xyz * float3(20, 20, 20) + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.xyz = -(i.texcoord3.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * r1.xyz;
	r0.w = dot(r1.xyz, r0.xyz);
	r0.w = r0.w + r0.w;
	r2 = r0.xyz * -(r0.www) + r1.xyz;
	r0.x = dot(-(r1.xyz), r0.xyz);
	r0.x = saturate(-(r0.x) + 1);
	r0.x = r0.x + 0.00000999999975;
	r0.yzw = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	r0.yzw = r0.wyz * r1.xxx;
	r0.y = saturate(r0.y);
	r0.y = r0.y + 1;
	r0.y = r0.y + r0.y;
	r0.yz = r0.zw / r0.yy;
	r0.yz = r0.yz + float2(0.5, 0.5);
	r0.yz = -(r0.yz) + float2(1, 1);
	r0.yzw = ReflectanceSampler_tex.SampleLevel(ReflectanceSampler, r0.yz, 0).xyz;
	r0.yzw = r0.yzw * r0.yzw;
	r0.yzw = r0.yzw * float3(16, 16, 16);
	r1.xyz = r0.yzw * waterColor.xyz + -(r0.yzw);
	r1.w = shaderVariables.w * waterColor.w;
	r0.yzw = r1.www * r1.xyz + r0.yzw;
	r1 = i.texcoord6.y * gWorldViewProj[1].zxyw;
	r1 = i.texcoord6.x * gWorldViewProj[0].zxyw + r1;
	r1 = i.texcoord6.z * gWorldViewProj[2].zxyw + r1;
	r1 = r1 + gWorldViewProj[3].zxyw;
	r1.yz = r1.yz / r1.ww;
	r1.yz = r1.yz * float2(0.5, -0.5) + float2(0.5, 0.5);
	r1.y = DepthSampler_tex.Sample(DepthSampler, r1.yz).x;
	r1.z = -(nearFarClip.x) + nearFarClip.y;
	r1.z = nearFarClip.y / r1.z;
	r1.y = -(r1.z) + r1.y;
	r1.z = r1.z * -(nearFarClip.x);
	r1.y = r1.z / r1.y;
	r1.x = -(r1.x) + r1.y;
	r1.x = max(r1.x, 0.00999999978);
	r1.x = r1.x * -(waterColor.w);
	r1.x = r1.x * 1.44269502;
	r1.x = exp2(r1.x);
	r1.x = -(r1.x) + 1;
	r0.yzw = -(waterColor.xyz) * r1.xxx + r0.yzw;
	r1.yzw = r1.xxx * waterColor.xyz;
	r2.x = r0.x * r0.x;
	r2.x = r2.x * r2.x;
	r0.x = r0.x * r2.x;
	r2.x = -(shaderVariables.z) + 1;
	r0.x = saturate(shaderVariables.z * r0.x + r2.x);
	r2.x = r0.x * shaderVariables.y;
	r0.x = -(r0.x) * shaderVariables.y + 1;
	o.w = r0.x * r1.x;
	r0.xyz = r2.xxx * r0.yzw + r1.yzw;
	r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r0.xyz = -(r0.www) + r0.xyz;
	r1.x = gAdrenoFXVars.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;

	return o;
}
