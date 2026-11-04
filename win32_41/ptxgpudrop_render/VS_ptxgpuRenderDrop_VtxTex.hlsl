cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
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
};

cbuffer GPURenderParam : register(b4)
{
	float gWrapScale : packoffset(c0);
	float gWrapBias : packoffset(c0.y);
	float gDiffuse : packoffset(c0.z);
	float gAmbientAmount : packoffset(c0.w);
};

cbuffer PtxGPURenderAttribs : register(b7)
{
	float2 gTextureRowsCols : packoffset(c0);
	float4 gSizeMinMax : packoffset(c1);
	float2 gSplashSizeMinMax : packoffset(c2);
	float4 gColour : packoffset(c3);
	float4 gColourSplash : packoffset(c4);
	float2 gSplashFrames : packoffset(c5);
	float2 gFadeInOut : packoffset(c5.z);
	float2 gRotSpeedMinMax : packoffset(c6);
	float gDirectional : packoffset(c6.z);
};

SamplerState PositionTexSampler : register(s0);
SamplerState VelocityTexSampler : register(s1);
Texture2D PositionTexSampler_tex : register(t0);
Texture2D VelocityTexSampler_tex : register(t1);

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
	int4 r2;
	float4 r3;
	int4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float3 r11;
	float3 r12;
	float4 r13;
	float4 r14;
	r0 = PositionTexSampler_tex.SampleLevel(PositionTexSampler, i.position.xy, i.position.w);
	r1 = VelocityTexSampler_tex.SampleLevel(VelocityTexSampler, i.position.xy, i.position.w);
	r2.x = (r1.w >= 10000) ? -1 : 0;
	r2.y = asint(r1.w + -10000);
	r1.w = (r2.x != 0) ? asfloat(r2.y) : r1.w;
	r1.w = frac(r1.w);
	r2.y = asint(r1.w * 1000);
	r2.y = asint(frac(asfloat(r2.y)));
	if (r2.x == 0) {
		r2.zw = asint(-(gSizeMinMax.xy) + gSizeMinMax.zw);
		r2.zw = asint(asfloat(r2.zw) * asfloat(r2.yy) + gSizeMinMax.xy);
		r3.x = frac(r0.w);
		r3.y = r0.w + -(r3.x);
		r3.xy = r3.xy * float2(100, 0.00999999978);
		r3.zw = i.texcoord.xy + float2(-0.5, -0.5);
		r4.x = (0 < gDirectional) ? -1 : 0;
		if (r4.x != 0) {
			r4.xyz = asint(-(r0.yzx) + gViewInverse[3].yzx);
			r4.w = asint(dot(r1.xyz, r1.xyz));
			r4.w = asint(rsqrt(asfloat(r4.w)));
			r1.xyz = r1.xyz * asfloat(r4.www);
			r4.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
			r4.w = asint(rsqrt(asfloat(r4.w)));
			r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
			r5.xyz = r1.zxy * asfloat(r4.xyz);
			r4.xyz = asint(r1.yzx * asfloat(r4.yzx) + -(r5.xyz));
			r4.w = asint(dot(asfloat(r4.xyz), asfloat(r4.xyz)));
			r4.w = asint(rsqrt(asfloat(r4.w)));
			r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
			r1.xyz = asfloat(r2.www) * r1.xyz;
			r4.xyz = asint(asfloat(r2.zzz) * asfloat(r4.xyz));
			r4.w = asint(-(i.texcoord.y) + 0.699999988);
			r1.xyz = -(r1.xyz) * asfloat(r4.www);
			r1.xyz = r3.zzz * asfloat(r4.xyz) + r1.xyz;
		} else {
			r4.x = asint(dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz)));
			r4.x = asint(rsqrt(asfloat(r4.x)));
			r4.xyz = asint(asfloat(r4.xxx) * -(gViewInverse[1].xyz));
			r4.w = asint(dot(gViewInverse[0].xyz, gViewInverse[0].xyz));
			r4.w = asint(rsqrt(asfloat(r4.w)));
			r5.xyz = asfloat(r4.www) * gViewInverse[0].xyz;
			r4.xyz = asint(asfloat(r2.www) * asfloat(r4.xyz));
			r5.xyz = asfloat(r2.zzz) * r5.xyz;
			r4.xyz = asint(r3.www * asfloat(r4.xyz));
			r1.xyz = r3.zzz * r5.xyz + asfloat(r4.xyz);
		}
		r2.z = asint(dot(r1.xyz, r1.xyz));
		r2.z = asint(rsqrt(asfloat(r2.z)));
		r4.xyz = asint(r1.xyz * asfloat(r2.zzz));
		r1.xyz = r0.xyz + r1.xyz;
		r5 = r1.y * gWorldViewProj[1];
		r5 = r1.x * gWorldViewProj[0] + r5;
		r5 = r1.z * gWorldViewProj[2] + r5;
		r5 = r5 + gWorldViewProj[3];
		r2.z = asint(gColour.w + 0.100000001);
		r2.w = asint(gTextureRowsCols.y * gTextureRowsCols.x);
		r1.w = r1.w * asfloat(r2.w);
		r1.w = r1.w * 99.9000015;
		r1.w = floor(r1.w);
		r1.w = r1.w / gTextureRowsCols.y;
		r2.w = (r1.w >= -(r1.w)) ? -1 : 0;
		r3.z = frac(abs(r1.w));
		r2.w = asint((r2.w != 0) ? r3.z : -(r3.z));
		r6.x = asfloat(r2.w) * gTextureRowsCols.y;
		r6.y = floor(r1.w);
		r3.zw = float2(1, 1) / gTextureRowsCols.yx;
		r6.xy = r6.xy + i.texcoord.xy;
		r3.zw = r3.zw * r6.xy;
		r6 = gColour.xyz;
	} else {
		r1.w = -(gSplashSizeMinMax.x) + gSplashSizeMinMax.y;
		r1.w = r1.w * asfloat(r2.y) + gSplashSizeMinMax.x;
		r2.y = asint(frac(r0.w));
		r0.w = r0.w + -(asfloat(r2.y));
		r3.y = r0.w * 0.00999999978;
		r3.x = asfloat(r2.y) * 100;
		r2.yw = asint(i.texcoord.xy + float2(-0.5, -0.5));
		r0.w = dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz));
		r0.w = rsqrt(r0.w);
		r7.xyz = r0.www * -(gViewInverse[1].xyz);
		r0.w = dot(gViewInverse[0].xyz, gViewInverse[0].xyz);
		r0.w = rsqrt(r0.w);
		r8.xyz = r0.www * gViewInverse[0].xyz;
		r7.xyz = r1.www * r7.xyz;
		r8.xyz = r1.www * r8.xyz;
		r7.xyz = asfloat(r2.www) * r7.xyz;
		r7.xyz = asfloat(r2.yyy) * r8.xyz + r7.xyz;
		r0.w = dot(r7.xyz, r7.xyz);
		r0.w = rsqrt(r0.w);
		r4.xyz = asint(r0.www * r7.xyz);
		r1.xyz = r0.xyz + r7.xyz;
		r7 = r1.y * gWorldViewProj[1];
		r7 = r1.x * gWorldViewProj[0] + r7;
		r7 = r1.z * gWorldViewProj[2] + r7;
		r5 = r7 + gWorldViewProj[3];
		r0.w = r3.y / r3.x;
		r0.w = r0.w * gSplashFrames.x;
		r0.w = floor(r0.w);
		r1.w = i.texcoord.x * gSplashFrames.y;
		r0.w = r0.w * gSplashFrames.y + r1.w;
		r3.z = r0.w + -10;
		r2.z = asint(gColourSplash.w + 0.100000001);
		r6 = gColourSplash.xyz;
		r3.w = i.texcoord.y;
	}
	r7 = -(r1.x) + gLightPosX;
	r8 = -(r1.y) + gLightPosY;
	r1 = -(r1.z) + gLightPosZ;
	r9 = r7 * r7;
	r9 = r8 * r8 + r9;
	r9 = r1 * r1 + r9;
	r10 = r9 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r10 = rsqrt(r10);
	r9 = -(r9) * gLightFallOff + float4(1, 1, 1, 1);
	r9 = max(r9, float4(0, 0, 0, 0));
	r9 = r9 * r9;
	r9 = r9 * r9 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r9 = max(r9, float4(0, 0, 0, 0));
	r9 = r9 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r9 = min(r9, float4(1, 1, 1, 1));
	r11.x = r7.x;
	r11.y = r8.x;
	r11.z = r1.x;
	r11 = r11.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r11.xyz, r11.xyz);
	r0.w = rsqrt(r0.w);
	r11 = r0.www * r11.xyz;
	r12.x = r7.y;
	r12.y = r8.y;
	r12.z = r1.y;
	r12 = r12.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r12.xyz, r12.xyz);
	r0.w = rsqrt(r0.w);
	r12 = r0.www * r12.xyz;
	r1.x = r7.z;
	r1.y = r8.z;
	r7.xyz = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r7.xyz, r7.xyz);
	r0.w = rsqrt(r0.w);
	r7.xyz = r0.www * r7.xyz;
	r1.x = r7.w;
	r1.y = r8.w;
	r1.xyz = r1.xyw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyw = r0.www * r1.xyz;
	r8.x = r11.x;
	r8.y = r12.x;
	r8.z = r7.x;
	r8.w = r1.x;
	r13 = r8 * -(gLightDirX);
	r14.x = r11.y;
	r14.y = r12.y;
	r14.z = r7.y;
	r14.w = r1.y;
	r13 = r14 * -(gLightDirY) + r13;
	r1.x = r11.z;
	r1.y = r12.z;
	r1.z = r7.z;
	r7 = r1 * -(gLightDirZ) + r13;
	r7 = saturate(r7 * gLightConeScale + gLightConeOffset);
	r7 = r9 * r7;
	r7 = r10 * r7;
	r8 = r7 * r8;
	r9 = r7 * r14;
	r1 = r1 * r7;
	r0.w = r7.x * gWrapBias;
	r2.y = asint(dot(asfloat(r4.xyz), -(gDirectionalLight.xyz)));
	r0.w = saturate(asfloat(r2.y) * gWrapScale + r0.w);
	r8 = asfloat(r4.x) * r8;
	r8 = asfloat(r4.y) * r9 + r8;
	r1 = asfloat(r4.z) * r1 + r8;
	r1 = saturate(gWrapBias * r7.x + r1);
	r7.x = dot(gLightColR, r1);
	r7.y = dot(gLightColG, r1);
	r7.z = dot(gLightColB, r1);
	r1.xyz = r0.www * gDirectionalColour.xyz + r7.xyz;
	r0.w = dot(asfloat(r4.xyz), gWorldView[2].xyz);
	r0.w = saturate(r0.w * -0.5 + 0.5);
	r4.xyz = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r4.xyz = asint(r0.www * asfloat(r4.xyz) + gLightAmbient0.xyz);
	r4.xyz = asint(asfloat(r4.xyz) * gAmbientOcclusionEffect.yyy);
	r4.xyz = asint(asfloat(r4.xyz) * gAmbientAmount);
	r4.xyz = asint(asfloat(r4.xyz) / gAmbientOcclusionEffect.yyy);
	r1.xyz = r1.xyz + asfloat(r4.xyz);
	r1.xyz = r1.xyz * gDiffuse;
	r1.xyz = r1.xyz * r6.xyz;
	r0.xyz = -(r0.xyz) + gViewInverse[3].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = r0.x * 0.666666687;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	r1.w = r0.x * asfloat(r2.z);
	if (r2.x != 0) {
		o.sv_position = r5;
		o.color = r1;
		o.texcoord = r3.zw;
		return o;
	}
	r0.x = -(r3.y) + r3.x;
	r0.x = saturate(r0.x / gLifeFade.x);
	r0.y = saturate(r3.y / gLifeFade.y);
	r0.x = r0.y * r0.x;
	o.color.w = r0.x * r1.w;
	o.sv_position = r5;
	o.color.xyz = r1.xyz;
	o.texcoord = r3.zw;

	return o;
}
