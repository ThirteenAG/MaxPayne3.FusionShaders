cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer PtxGPUAttribs : register(b1)
{
	float gMotionBlur : packoffset(c0);
	float4 gRadius : packoffset(c1);
	float2 gLifeFade : packoffset(c2);
	float4 gTextureAnimation : packoffset(c3);
	float4 gColorTint : packoffset(c4);
};

cbuffer GPURenderParam : register(b4)
{
	float gWrapScale : packoffset(c0);
	float gWrapBias : packoffset(c0.y);
	float gDiffuse : packoffset(c0.z);
	float gAmbientAmount : packoffset(c0.w);
};

SamplerState PositionTexSampler : register(s1);
SamplerState VelocityTexSampler : register(s3);
Texture2D PositionTexSampler_tex : register(t1);
Texture2D VelocityTexSampler_tex : register(t3);

struct VS_IN
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	float2 r4;
	r0.xyz = VelocityTexSampler_tex.SampleLevel(VelocityTexSampler, i.position.xy, i.position.w).xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.x = 0;
	r1.z = gRadius.x * 0.5;
	r2 = PositionTexSampler_tex.SampleLevel(PositionTexSampler, i.position.xy, i.position.w).xyz;
	r1.xyz = r1.xxz + r2.xyz;
	r2 = -(r2.xyz) + gViewInverse[3].xyz;
	r0.w = dot(r2.xyz, r2.xyz);
	r0.w = sqrt(r0.w);
	r0.w = r0.w * 0.666666687;
	r2 = -(r1.xyz) + gViewInverse[3].xyz;
	r3 = r0.zxy * r2.yzx;
	r3 = r0.yzx * r2.zxy + -(r3.xyz);
	r0.xyz = r0.xyz * gRadius.xxx;
	r1.w = dot(r3.xyz, r3.xyz);
	r1.w = rsqrt(r1.w);
	r3 = r1.www * r3.xyz;
	r3 = r3.xyz * gRadius.xxx;
	r4 = i.texcoord.xy + float2(-0.5, -0.699999988);
	r0.xyz = r0.xyz * r4.yyy;
	r0.xyz = r4.xxx * r3.xyz + r0.xyz;
	r0.xyz = r0.xyz + r1.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.sv_position = r1 + gWorldViewProj[3];
	r0.x = r0.w * r0.w;
	r0.x = r0.w * r0.x;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * gColorTint.w;
	r0.x = dot(r2.xyz, r2.xyz);
	r0.x = rsqrt(r0.x);
	r0.xyz = r0.xxx * r2.xyz;
	r0.x = dot(r0.xyz, gWorldView[2].xyz);
	r0.x = saturate(r0.x * -0.5 + 0.5);
	r0.yzw = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r0.xyz = r0.xxx * r0.yzw + gLightAmbient0.xyz;
	r0.xyz = r0.xyz * gAmbientOcclusionEffect.yyy;
	r0.xyz = r0.xyz * gAmbientAmount;
	r0.xyz = r0.xyz / gAmbientOcclusionEffect.yyy;
	r0.xyz = r0.xyz * gDiffuse;
	o.color.xyz = r0.xyz * gColorTint.xyz;
	o.texcoord = i.texcoord.xy;

	return o;
}
