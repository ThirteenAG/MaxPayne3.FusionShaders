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
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
	float4 gShadowParam4567 : packoffset(c3);
	float4 gShadowParam891113 : packoffset(c4);
	float4 gCascadeZScales : packoffset(c5);
	float4 gCascadeZOffsets : packoffset(c6);
	float4 gCascadeXMinThresholds : packoffset(c7);
	float4 gCascadeXMaxThresholds : packoffset(c8);
	float4 gCascadeYMinThresholds : packoffset(c9);
	float4 gCascadeYMaxThresholds : packoffset(c10);
	row_major float4x4 gShadowMatrix : packoffset(c11);
};

SamplerState DiffuseSampler : register(s0);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	float4 r6;
	float4 r7;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = asint(saturate(i.texcoord2.z * -0.5 + 0.5));
	r1.yzw = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r1.xyz = asint(asfloat(r1.xxx) * asfloat(r1.yzw) + gLightAmbient0.xyz);
	r1.xyz = asint(asfloat(r1.xyz) * gAmbientOcclusionEffect.yyy);
	r1.xyz = asint(asfloat(r1.xyz) * i.color.xxx);
	r1.xyz = asint(asfloat(r1.xyz) / gAmbientOcclusionEffect.yyy);
	r1.w = asint(dot(i.texcoord2.xyz, -(gDirectionalLight.xyz)));
	r1.w = asint(saturate(asfloat(r1.w) + -0.25));
	r1.w = asint(asfloat(r1.w) * 1.33333337);
	r2.xyz = i.texcoord1.yyy * gShadowMatrix[1].xyz;
	r2.xyz = i.texcoord1.xxx * gShadowMatrix[0].xyz + r2.xyz;
	r2.xyz = i.texcoord1.zzz * gShadowMatrix[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gShadowMatrix[3].xyz;
	r3.xy = asint(r2.xy + -(gShadowParam18192021.zw));
	r3.zw = (asfloat(r3.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r3.zw = r3.zw & int2(1065353216, 1065353216);
	r4.xy = (gCascadeXMinThresholds.xy >= asfloat(r3.xx)) ? -1 : 0;
	r4.zw = (asfloat(r3.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r4 = r4 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r5.xy = (gCascadeYMinThresholds.xy >= asfloat(r3.yy)) ? -1 : 0;
	r5.xy = r5.xy & int2(1065353216, 1065353216);
	r3.zw = asint(asfloat(r3.zw) + asfloat(r4.xy));
	r3.zw = asint(asfloat(r4.zw) + asfloat(r3.zw));
	r3.zw = asint(asfloat(r5.xy) + asfloat(r3.zw));
	r4.yz = asint(min(asfloat(r3.zw), float2(1, 1)));
	r4.x = 1065353216;
	r5.x = asint(dot(asfloat(r4.xyz), gShadowParam0123.xyz));
	r5.y = asint(dot(asfloat(r4.xyz), gShadowParam4567.xyz));
	r5.z = asint(dot(asfloat(r4.xyz), gCascadeZScales.xyz));
	r6.x = dot(asfloat(r4.xyz), gShadowParam891113.xyz);
	r6.y = dot(asfloat(r4.xyz), gShadowParam14151617.xyz);
	r6.z = dot(asfloat(r4.xyz), gCascadeZOffsets.xyz);
	r2.xyz = r2.zxy * asfloat(r5.zxy) + r6.zxy;
	r2.x = saturate(r2.x);
	r4.x = asint(-(gCascadeXMinThresholds.w));
	r4.y = asint(-(gCascadeXMaxThresholds.w));
	r3.xy = asint(saturate(abs(asfloat(r3.xy)) * float2(4, 4) + asfloat(r4.xy)));
	r2.w = max(asfloat(r3.y), asfloat(r3.x));
	r2.x = -(r2.x) + 0.999999523;
	r3.xy = int2(0, -2);
	while (true) {
		r3.z = (r3.y >= 3) ? -1 : 0;
		if (r3.z != 0) break;
		r3.z = asint((float)r3.y);
		r4.x = asint(asfloat(r3.z) * gShadowParam18192021.x);
		r3.z = r3.x;
		r3.w = -2;
		while (true) {
			r4.z = (r3.w >= 3) ? -1 : 0;
			if (r4.z != 0) break;
			r4.z = asint((float)r3.w);
			r4.y = asint(asfloat(r4.z) * gShadowParam18192021.y);
			r4.yz = asint(r2.yz + asfloat(r4.xy));
			r4.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r4.yz), r2.x));
			r3.z = asint(asfloat(r3.z) + asfloat(r4.y));
			r3.w = r3.w + 1;
		}
		r3.x = r3.z;
		r3.y = r3.y + 1;
	}
	r2.x = asfloat(r3.x) * 0.0399999991 + r2.w;
	r2.x = r2.x * 1.25;
	r2.x = min(r2.x, 1);
	r2.y = r2.x * -2 + 3;
	r2.x = r2.x * r2.x;
	r2.x = r2.x * r2.y;
	r2.xyz = r2.xxx * gDirectionalColour.xyz;
	r1.xyz = asint(r2.xyz * asfloat(r1.www) + asfloat(r1.xyz));
	r2 = -(i.texcoord1.x) + gLightPosX;
	r3 = asint(-(i.texcoord1.y) + gLightPosY);
	r4 = asint(-(i.texcoord1.z) + gLightPosZ);
	r5 = asint(r2 * r2);
	r5 = asint(asfloat(r3) * asfloat(r3) + asfloat(r5));
	r5 = asint(asfloat(r4) * asfloat(r4) + asfloat(r5));
	r6 = asfloat(r5) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r6 = rsqrt(r6);
	r5 = asint(-(asfloat(r5)) * gLightFallOff + float4(1, 1, 1, 1));
	r5 = asint(max(asfloat(r5), float4(0, 0, 0, 0)));
	r5 = asint(asfloat(r5) * asfloat(r5));
	r5 = asint(asfloat(r5) * asfloat(r5) + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001));
	r5 = asint(max(asfloat(r5), float4(0, 0, 0, 0)));
	r5 = asint(asfloat(r5) * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116));
	r7 = r2 * i.texcoord2.x;
	r7 = asfloat(r3) * i.texcoord2.y + r7;
	r7 = asfloat(r4) * i.texcoord2.z + r7;
	r5 = asint(asfloat(r5) * r7);
	r5 = asint(saturate(r6 * asfloat(r5)));
	r2 = r2 * -(gLightDirX);
	r2 = asfloat(r3) * -(gLightDirY) + r2;
	r2 = asfloat(r4) * -(gLightDirZ) + r2;
	r2 = r6 * r2;
	r2 = saturate(r2 * gLightConeScale + gLightConeOffset);
	r2 = asfloat(r5) * r2;
	r3.x = asint(dot(gLightColR, r2));
	r3.y = asint(dot(gLightColG, r2));
	r3.z = asint(dot(gLightColB, r2));
	r1.xyz = asint(asfloat(r1.xyz) + asfloat(r3.xyz));
	r2 = -(i.texcoord1.x) + gLightPointPosX;
	r3 = asint(-(i.texcoord1.y) + gLightPointPosY);
	r4 = asint(-(i.texcoord1.z) + gLightPointPosZ);
	r5 = asint(r2 * r2);
	r5 = asint(asfloat(r3) * asfloat(r3) + asfloat(r5));
	r5 = asint(asfloat(r4) * asfloat(r4) + asfloat(r5));
	r6 = asfloat(r5) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r6 = rsqrt(r6);
	r5 = asint(-(asfloat(r5)) * gLightPointFallOff + float4(1, 1, 1, 1));
	r5 = asint(max(asfloat(r5), float4(0, 0, 0, 0)));
	r5 = asint(asfloat(r5) * asfloat(r5));
	r5 = asint(asfloat(r5) * asfloat(r5) + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001));
	r5 = asint(max(asfloat(r5), float4(0, 0, 0, 0)));
	r5 = asint(asfloat(r5) * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116));
	r7 = r2 * i.texcoord2.x;
	r7 = asfloat(r3) * i.texcoord2.y + r7;
	r7 = asfloat(r4) * i.texcoord2.z + r7;
	r5 = asint(asfloat(r5) * r7);
	r5 = asint(saturate(r6 * asfloat(r5)));
	r2 = r2 * -(gLightDir2X);
	r2 = asfloat(r3) * -(gLightDir2Y) + r2;
	r2 = asfloat(r4) * -(gLightDir2Z) + r2;
	r2 = r6 * r2;
	r2 = saturate(r2 * gLightConeScale2 + gLightConeOffset2);
	r2 = asfloat(r5) * r2;
	r3.x = asint(dot(gLightPointColR, r2));
	r3.y = asint(dot(gLightPointColG, r2));
	r3.z = asint(dot(gLightPointColB, r2));
	r1.xyz = asint(asfloat(r1.xyz) + asfloat(r3.xyz));
	r0.xyz = r0.xyz * asfloat(r1.xyz);
	o.w = r0.w * globalScalars.x;
	r1.xyz = asint(i.texcoord1.xyz + -(gViewInverse[3].xyz));
	r0.w = saturate(-(i.texcoord2.w) * gDepthFxParams.z + gDepthFxParams.w);
	r1.w = asint(-(r0.w) + 1);
	r0.w = asfloat(r1.w) * gDepthFxParams.y + r0.w;
	r1.w = asint(dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986)));
	r1.w = asint(asfloat(r1.w) + 0.00000999999975);
	r1.w = asint(abs(asfloat(r1.w)) + 0.00000999999975);
	r0.w = r0.w + -0.999989986;
	r1.w = asint(log2(asfloat(r1.w)));
	r0.w = r0.w * asfloat(r1.w);
	r0.w = exp2(r0.w);
	r1.w = asint(asfloat(r1.z) * globalFogParams.x);
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * globalFogParams.z);
	r1.y = (0.0000999999975 < abs(asfloat(r1.w))) ? -1 : 0;
	r1.z = asint(asfloat(r1.w) * -1.44269502);
	r1.z = asint(exp2(asfloat(r1.z)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(asfloat(r1.z) / asfloat(r1.w));
	r1.z = asint(asfloat(r1.z) * asfloat(r1.x));
	r1.x = (r1.y != 0) ? r1.z : r1.x;
	r1.x = asint(asfloat(r1.x) * -(globalFogParams.y));
	r1.x = asint(asfloat(r1.x) * 1.44269502);
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.x = asint(min(asfloat(r1.x), 1));
	r0.xyz = r0.xyz * r0.www + -(globalFogColorN.xyz);
	r0.xyz = asfloat(r1.xxx) * r0.xyz + globalFogColorN.xyz;
	r0.w = gAdrenoFXVars.x * deSatContrastGamma.x;
	r1.x = asint(dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986)));
	r0.xyz = r0.xyz + -(asfloat(r1.xxx));
	o.xyz = r0.www * r0.xyz + asfloat(r1.xxx);

	return o;
}
