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
	float4 gColorTintPhase2 : packoffset(c5);
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
	int4 r1;
	float4 r2;
	float3 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0 = PositionTexSampler_tex.SampleLevel(PositionTexSampler, i.position.xy, i.position.w);
	r1 = asint(VelocityTexSampler_tex.SampleLevel(VelocityTexSampler, i.position.xy, i.position.w));
	r1.w = (asfloat(r1.w) == 0) ? -1 : 0;
	if (r1.w != 0) {
		r2.y = 0;
		r2.xw = gRadius.xx * float2(0.125, 0.5);
		r2.yzw = r0.xyz + r2.yyw;
		r3.xy = i.texcoord.xy + float2(-0.5, -0.699999988);
		r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
		r4.xyz = -(r2.yzw) + gViewInverse[3].xyz;
		r5.xyz = asfloat(r1.zxy) * r4.yzx;
		r5.xyz = asfloat(r1.yzx) * r4.zxy + -(r5.xyz);
		r1.w = asint(dot(r5.xyz, r5.xyz));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r5.xyz = asfloat(r1.www) * r5.xyz;
		r5.xyz = r2.xxx * r5.xyz;
		r1.xyz = asint(asfloat(r1.xyz) * gRadius.xxx);
		r1.xyz = asint(asfloat(r1.xyz) * r3.yyy);
		r1.xyz = asint(r3.xxx * r5.xyz + asfloat(r1.xyz));
		r1.w = asint(dot(r4.xyz, r4.xyz));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r3 = asfloat(r1.www) * r4.xyz;
		r1.xyz = asint(asfloat(r1.xyz) + r2.yzw);
		r2 = asfloat(r1.y) * gWorldViewProj[1];
		r2 = asfloat(r1.x) * gWorldViewProj[0] + r2;
		r1 = asint(asfloat(r1.z) * gWorldViewProj[2] + r2);
		o.sv_position = asfloat(r1) + gWorldViewProj[3];
		r1.x = asint(gColorTint.w + 0.0500000007);
		r1.yzw = asint(gColorTint.xyz);
		r2.x = i.texcoord.x;
	} else {
		r4.x = 0;
		r4.z = gRadius.z * 0.5;
		r4 = r0 + r4.xxzx;
		r2.zw = i.texcoord.xy + float2(-0.5, -0.5);
		r0.w = dot(gViewInverse[0].xyz, gViewInverse[0].xyz);
		r0.w = rsqrt(r0.w);
		r5.xyz = r0.www * gViewInverse[0].xyz;
		r5.xyz = r5.xyz * gRadius.zzz;
		r0.w = dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz));
		r0.w = rsqrt(r0.w);
		r6 = r0.www * -(gViewInverse[1].xyz);
		r6 = r6.xyz * gRadius.zzz;
		r6 = r2.www * r6.xyz;
		r5.xyz = r2.zzz * r5.xyz + r6.xyz;
		r0.w = dot(r5.xyz, r5.xyz);
		r0.w = rsqrt(r0.w);
		r3 = r0.www * r5.xyz;
		r4.xyz = r4.xyz + r5.xyz;
		r5 = r4.y * gWorldViewProj[1];
		r5 = r4.x * gWorldViewProj[0] + r5;
		r5 = r4.z * gWorldViewProj[2] + r5;
		o.sv_position = r5 + gWorldViewProj[3];
		r1.x = asint(gColorTintPhase2.w + 0.100000001);
		r0.w = r4.w * gTextureAnimation.x + -(gTextureAnimation.y);
		r0.w = trunc(r0.w);
		r0.w = saturate(r0.w * gTextureAnimation.z);
		r0.w = gTextureAnimation.z * i.texcoord.x + r0.w;
		r2.x = r0.w + -10;
		r1.yzw = asint(gColorTintPhase2.xyz);
	}
	r0.w = dot(r3.xyz, gWorldView[2].xyz);
	r0.w = saturate(r0.w * -0.5 + 0.5);
	r3 = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r3 = r0.www * r3.xyz + gLightAmbient0.xyz;
	r3 = r3.xyz * gAmbientOcclusionEffect.yyy;
	r3 = r3.xyz * gAmbientAmount;
	r3 = r3.xyz / gAmbientOcclusionEffect.yyy;
	r3 = r3.xyz * gDiffuse;
	o.color.xyz = asfloat(r1.yzw) * r3.xyz;
	r0.xyz = -(r0.xyz) + gViewInverse[3].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = r0.x * 0.666666687;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * asfloat(r1.x);
	r2.y = i.texcoord.y;
	o.texcoord = r2.xy;

	return o;
}
