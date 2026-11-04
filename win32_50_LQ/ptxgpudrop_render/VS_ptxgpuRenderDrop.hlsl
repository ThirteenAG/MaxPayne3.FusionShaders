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

cbuffer GPURenderParam : register(b1)
{
	float gWrapScale : packoffset(c0);
	float gWrapBias : packoffset(c0.y);
	float gDiffuse : packoffset(c0.z);
	float gAmbientAmount : packoffset(c0.w);
};

cbuffer PtxGPURenderAttribs : register(b4)
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
	float2 gFadeNearFar : packoffset(c7);
};

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
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

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	r0.x = (i.texcoord1.w >= 10000) ? -1 : 0;
	r0.y = asint(i.texcoord1.w + -10000);
	r0.y = (r0.x != 0) ? r0.y : asint(i.texcoord1.w);
	r0.y = asint(frac(asfloat(r0.y)));
	r0.z = asint(asfloat(r0.y) * 1000);
	r0.z = asint(frac(asfloat(r0.z)));
	if (r0.x == 0) {
		r1.xy = asint(-(gSizeMinMax.xy) + gSizeMinMax.zw);
		r1.xy = asint(asfloat(r1.xy) * asfloat(r0.zz) + gSizeMinMax.xy);
		r0.w = asint(frac(i.texcoord.w));
		r1.z = asint(-(asfloat(r0.w)) + i.texcoord.w);
		r1.z = asint(asfloat(r1.z) * 0.00999999978);
		r2.xy = asint(i.texcoord2.xy + float2(-0.5, -0.5));
		r1.w = (0 < gDirectional) ? -1 : 0;
		if (r1.w != 0) {
			r3.xyz = -(i.texcoord.yzx) + gViewInverse[3].yzx;
			r1.w = asint(dot(i.texcoord1.xyz, i.texcoord1.xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r4.xyz = asfloat(r1.www) * i.texcoord1.xyz;
			r1.w = asint(dot(r3.xyz, r3.xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r3.xyz = asfloat(r1.www) * r3.xyz;
			r5 = r3.xyz * r4.zxy;
			r3.xyz = r4.yzx * r3.yzx + -(r5.xyz);
			r1.w = asint(dot(r3.xyz, r3.xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r3.xyz = asfloat(r1.www) * r3.xyz;
			r4.xyz = asfloat(r1.yyy) * r4.xyz;
			r3.xyz = asfloat(r1.xxx) * r3.xyz;
			r1.w = asint(-(i.texcoord2.y) + 0.699999988);
			r4.xyz = -(r4.xyz) * asfloat(r1.www);
			r3.xyz = asfloat(r2.xxx) * r3.xyz + r4.xyz;
		} else {
			r1.w = asint(dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz)));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r4.xyz = asfloat(r1.www) * -(gViewInverse[1].xyz);
			r1.w = asint(dot(gViewInverse[0].xyz, gViewInverse[0].xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r5 = asfloat(r1.www) * gViewInverse[0].xyz;
			r4.xyz = asfloat(r1.yyy) * r4.xyz;
			r1.xyw = asint(asfloat(r1.xxx) * r5.xyz);
			r2.yzw = asint(asfloat(r2.yyy) * r4.xyz);
			r3.xyz = asfloat(r2.xxx) * asfloat(r1.xyw) + asfloat(r2.yzw);
		}
		r1.x = asint(dot(r3.xyz, r3.xyz));
		r1.x = asint(rsqrt(asfloat(r1.x)));
		r1.xyw = asint(asfloat(r1.xxx) * r3.xyz);
		r2.xyz = asint(r3.xyz + i.texcoord.xyz);
		r3 = asfloat(r2.y) * gWorldViewProj[1];
		r3 = asfloat(r2.x) * gWorldViewProj[0] + r3;
		r3 = asfloat(r2.z) * gWorldViewProj[2] + r3;
		r3 = r3 + gWorldViewProj[3];
		r2.w = asint(gTextureRowsCols.y * gTextureRowsCols.x);
		r0.y = asint(asfloat(r0.y) * asfloat(r2.w));
		r0.yw = asint(asfloat(r0.yw) * float2(99.9000015, 100));
		r0.y = asint(floor(asfloat(r0.y)));
		r0.y = asint(asfloat(r0.y) / gTextureRowsCols.y);
		r2.w = (asfloat(r0.y) >= -(asfloat(r0.y))) ? -1 : 0;
		r4.x = frac(abs(asfloat(r0.y)));
		r2.w = asint((r2.w != 0) ? r4.x : -(r4.x));
		r4.x = asfloat(r2.w) * gTextureRowsCols.y;
		r4.y = floor(asfloat(r0.y));
		r4.zw = float2(1, 1) / gTextureRowsCols.yx;
		r4.xy = r4.xy + i.texcoord2.xy;
		r4.xy = r4.zw * r4.xy;
		r5 = gColour.xyz;
		r0.y = asint(gColour.w);
	} else {
		r2.w = asint(-(gSplashSizeMinMax.x) + gSplashSizeMinMax.y);
		r0.z = asint(asfloat(r2.w) * asfloat(r0.z) + gSplashSizeMinMax.x);
		r2.w = asint(frac(i.texcoord.w));
		r4.z = -(asfloat(r2.w)) + i.texcoord.w;
		r1.z = asint(r4.z * 0.00999999978);
		r0.w = asint(asfloat(r2.w) * 100);
		r4.zw = i.texcoord2.xy + float2(-0.5, -0.5);
		r2.w = asint(dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz)));
		r2.w = asint(rsqrt(asfloat(r2.w)));
		r6.xyz = asfloat(r2.www) * -(gViewInverse[1].xyz);
		r2.w = asint(dot(gViewInverse[0].xyz, gViewInverse[0].xyz));
		r2.w = asint(rsqrt(asfloat(r2.w)));
		r7.xyz = asfloat(r2.www) * gViewInverse[0].xyz;
		r6.xyz = asfloat(r0.zzz) * r6.xyz;
		r7.xyz = asfloat(r0.zzz) * r7.xyz;
		r6.xyz = r4.www * r6.xyz;
		r6.xyz = r4.zzz * r7.xyz + r6.xyz;
		r0.z = asint(dot(r6.xyz, r6.xyz));
		r0.z = asint(rsqrt(asfloat(r0.z)));
		r1.xyw = asint(asfloat(r0.zzz) * r6.xyz);
		r2.xyz = asint(r6.xyz + i.texcoord.xyz);
		r6 = asfloat(r2.y) * gWorldViewProj[1];
		r6 = asfloat(r2.x) * gWorldViewProj[0] + r6;
		r6 = asfloat(r2.z) * gWorldViewProj[2] + r6;
		r3 = r6 + gWorldViewProj[3];
		r0.z = asint(asfloat(r1.z) / asfloat(r0.w));
		r0.z = asint(asfloat(r0.z) * gSplashFrames.x);
		r0.z = asint(floor(asfloat(r0.z)));
		r2.w = asint(i.texcoord2.x * gSplashFrames.y);
		r0.z = asint(asfloat(r0.z) * gSplashFrames.y + asfloat(r2.w));
		r4.x = asfloat(r0.z) + -10;
		r5 = gColourSplash.xyz;
		r4.y = i.texcoord2.y;
		r0.y = asint(gColourSplash.w);
	}
	r6.xyz = asfloat(r1.yyy) * gWorldView[1].xyz;
	r6.xyz = asfloat(r1.xxx) * gWorldView[0].xyz + r6.xyz;
	r1.xyw = asint(asfloat(r1.www) * gWorldView[2].xyz + r6.xyz);
	r6.xyz = asfloat(r2.yyy) * gWorldView[1].xyz;
	r2.xyw = asint(asfloat(r2.xxx) * gWorldView[0].xyz + r6.xyz);
	r2.xyz = asint(asfloat(r2.zzz) * gWorldView[2].xyz + asfloat(r2.xyw));
	r2.xyz = asint(asfloat(r2.xyz) + gWorldView[3].xyz);
	r6 = -(asfloat(r2.x)) + gLightPosX;
	r7 = -(asfloat(r2.y)) + gLightPosY;
	r2 = asint(-(asfloat(r2.z)) + gLightPosZ);
	r8 = r6 * r6;
	r8 = r7 * r7 + r8;
	r8 = asfloat(r2) * asfloat(r2) + r8;
	r9 = r8 + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r9 = rsqrt(r9);
	r8 = -(r8) * gLightFallOff + float4(1, 1, 1, 1);
	r8 = max(r8, float4(0, 0, 0, 0));
	r8 = r8 * r8;
	r8 = r8 * r8 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r8 = max(r8, float4(0, 0, 0, 0));
	r8 = r8 * r9;
	r8 = r8 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r8 = min(r8, float4(1, 1, 1, 1));
	r10 = r6 * -(gLightDirX);
	r10 = r7 * -(gLightDirY) + r10;
	r10 = asfloat(r2) * -(gLightDirZ) + r10;
	r10 = r9 * r10;
	r10 = saturate(r10 * gLightConeScale + gLightConeOffset);
	r8 = r8 * r10;
	r8 = r9 * r8;
	r6 = r6 * r8;
	r7 = r7 * r8;
	r2 = asint(asfloat(r2) * r8);
	r0.z = asint(r8.x * gWrapBias);
	r4.z = dot(asfloat(r1.xyw), -(gDirectionalLight.xyz));
	r0.z = asint(saturate(r4.z * gWrapScale + asfloat(r0.z)));
	r6 = asfloat(r1.x) * r6;
	r6 = asfloat(r1.y) * r7 + r6;
	r2 = asint(asfloat(r1.w) * asfloat(r2) + r6);
	r2 = asint(saturate(gWrapBias * r8.x + asfloat(r2)));
	r6.x = dot(gLightColR, asfloat(r2));
	r6.y = dot(gLightColG, asfloat(r2));
	r6.z = dot(gLightColB, asfloat(r2));
	r2.xyz = asint(asfloat(r0.zzz) * gDirectionalColour.xyz + r6.xyz);
	r0.z = asint(dot(asfloat(r1.xyw), gWorldView[2].xyz));
	r0.z = asint(saturate(asfloat(r0.z) * -0.5 + 0.5));
	r1.xyw = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r1.xyw = asint(asfloat(r0.zzz) * asfloat(r1.xyw) + gLightAmbient0.xyz);
	r1.xyw = asint(asfloat(r1.xyw) * gAmbientOcclusionEffect.yyy);
	r1.xyw = asint(asfloat(r1.xyw) * gAmbientAmount);
	r1.xyw = asint(asfloat(r1.xyw) / gAmbientOcclusionEffect.yyy);
	r1.xyw = asint(asfloat(r1.xyw) + asfloat(r2.xyz));
	r1.xyw = asint(asfloat(r1.xyw) * gDiffuse);
	r2.xyz = asint(asfloat(r1.xyw) * r5.xyz);
	r1.xyw = asint(-(i.texcoord.xyz) + gViewInverse[3].xyz);
	r0.z = asint(dot(asfloat(r1.xyw), asfloat(r1.xyw)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r1.xy = asint(asfloat(r0.zz) / gFadeNearFar.yx);
	r4.zw = asfloat(r1.xy) * asfloat(r1.xy);
	r1.xy = asint(saturate(asfloat(r1.xy) * r4.zw));
	r0.z = asint(-(asfloat(r1.x)) + 1);
	r0.y = asint(asfloat(r0.z) * asfloat(r0.y));
	r2.w = asint(asfloat(r1.y) * asfloat(r0.y));
	if (r0.x == 0) {
		o.sv_position = r3;
		o.color = asfloat(r2);
		o.texcoord = r4.xy;
		return o;
	}
	r0.x = asint(-(asfloat(r1.z)) + asfloat(r0.w));
	r0.x = asint(saturate(asfloat(r0.x) / gFadeInOut.x));
	r0.y = asint(saturate(asfloat(r1.z) / gFadeInOut.y));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	o.color.w = asfloat(r0.x) * asfloat(r2.w);
	o.sv_position = r3;
	o.color.xyz = asfloat(r2.xyz);
	o.texcoord = r4.xy;

	return o;
}
