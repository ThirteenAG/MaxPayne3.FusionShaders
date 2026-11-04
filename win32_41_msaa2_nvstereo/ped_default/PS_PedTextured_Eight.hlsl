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

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float displacementScale : packoffset(c0.y);
	float4 matMaterialColorScale : packoffset(c1);
};

SamplerState DiffuseSampler : register(s0);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord7 : TEXCOORD7;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	uint sv_coverage : SV_Coverage;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	float4 r7;
	float4 r8;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r0.xyz = r0.xyz * r0.xyz;
	r0.w = r0.w * i.texcoord7.w;
	r1.w = asint(saturate(asfloat(r1.z) * -0.5 + 0.5));
	r2.xyz = -(gLightAmbient0.xyz) + gLightAmbient1.xyz;
	r2.xyz = asfloat(r1.www) * r2.xyz + gLightAmbient0.xyz;
	r2.xyz = r2.xyz * gAmbientOcclusionEffect.yyy;
	r2.xyz = r2.xyz * i.texcoord7.xxx;
	r2.xyz = r2.xyz / gAmbientOcclusionEffect.yyy;
	r1.w = asint(dot(asfloat(r1.xyz), -(gDirectionalLight.xyz)));
	r1.w = asint(saturate(asfloat(r1.w) + -0.25));
	r1.w = asint(asfloat(r1.w) * 1.33333337);
	r3.xyz = asint(i.texcoord2.yyy * gShadowMatrix[1].xyz);
	r3.xyz = asint(i.texcoord2.xxx * gShadowMatrix[0].xyz + asfloat(r3.xyz));
	r3.xyz = asint(i.texcoord2.zzz * gShadowMatrix[2].xyz + asfloat(r3.xyz));
	r3.xyz = asint(asfloat(r3.xyz) + gShadowMatrix[3].xyz);
	r4.xy = asint(asfloat(r3.xy) + -(gShadowParam18192021.zw));
	r4.zw = (asfloat(r4.xx) >= gCascadeXMaxThresholds.xy) ? -1 : 0;
	r4.zw = r4.zw & int2(1065353216, 1065353216);
	r5.xy = (gCascadeXMinThresholds.xy >= asfloat(r4.xx)) ? -1 : 0;
	r5.zw = (asfloat(r4.yy) >= gCascadeYMaxThresholds.xy) ? -1 : 0;
	r5 = r5 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	r6.xy = (gCascadeYMinThresholds.xy >= asfloat(r4.yy)) ? -1 : 0;
	r6.xy = r6.xy & int2(1065353216, 1065353216);
	r4.zw = asint(asfloat(r4.zw) + asfloat(r5.xy));
	r4.zw = asint(asfloat(r5.zw) + asfloat(r4.zw));
	r4.zw = asint(asfloat(r6.xy) + asfloat(r4.zw));
	r5.yz = asint(min(asfloat(r4.zw), float2(1, 1)));
	r5.x = 1065353216;
	r6.x = asint(dot(asfloat(r5.xyz), gShadowParam0123.xyz));
	r6.y = asint(dot(asfloat(r5.xyz), gShadowParam4567.xyz));
	r6.z = asint(dot(asfloat(r5.xyz), gCascadeZScales.xyz));
	r7.x = dot(asfloat(r5.xyz), gShadowParam891113.xyz);
	r7.y = dot(asfloat(r5.xyz), gShadowParam14151617.xyz);
	r7.z = dot(asfloat(r5.xyz), gCascadeZOffsets.xyz);
	r3.xyz = asint(asfloat(r3.zxy) * asfloat(r6.zxy) + r7.zxy);
	r3.x = asint(saturate(asfloat(r3.x)));
	r5.x = asint(-(gCascadeXMinThresholds.w));
	r5.y = asint(-(gCascadeXMaxThresholds.w));
	r4.xy = asint(saturate(abs(asfloat(r4.xy)) * float2(4, 4) + asfloat(r5.xy)));
	r2.w = max(asfloat(r4.y), asfloat(r4.x));
	r3.x = asint(-(asfloat(r3.x)) + 0.999999523);
	r3.w = 0;
	r4.x = -1;
	while (true) {
		r4.y = (r4.x >= 2) ? -1 : 0;
		if (r4.y != 0) break;
		r4.y = asint((float)r4.x);
		r5.x = asint(asfloat(r4.y) * gShadowParam18192021.x);
		r4.y = r3.w;
		r4.z = -1;
		while (true) {
			r4.w = (r4.z >= 2) ? -1 : 0;
			if (r4.w != 0) break;
			r4.w = asint((float)r4.z);
			r5.y = asint(asfloat(r4.w) * gShadowParam18192021.y);
			r5.yz = asint(asfloat(r3.yz) + asfloat(r5.xy));
			r4.w = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r5.yz), asfloat(r3.x)));
			r4.y = asint(asfloat(r4.w) + asfloat(r4.y));
			r4.z = r4.z + 1;
		}
		r3.w = r4.y;
		r4.x = r4.x + 1;
	}
	r2.w = asfloat(r3.w) * 0.111111112 + r2.w;
	r2.w = r2.w * 1.25;
	r2.w = min(r2.w, 1);
	r3.x = asint(r2.w * -2 + 3);
	r2.w = r2.w * r2.w;
	r2.w = r2.w * asfloat(r3.x);
	r3.xyz = asint(r2.www * gDirectionalColour.xyz);
	r2.xyz = asfloat(r3.xyz) * asfloat(r1.www) + r2.xyz;
	r3 = asint(-(i.texcoord2.x) + gLightPosX);
	r4 = asint(-(i.texcoord2.y) + gLightPosY);
	r5 = asint(-(i.texcoord2.z) + gLightPosZ);
	r6 = asint(asfloat(r3) * asfloat(r3));
	r6 = asint(asfloat(r4) * asfloat(r4) + asfloat(r6));
	r6 = asint(asfloat(r5) * asfloat(r5) + asfloat(r6));
	r7 = asfloat(r6) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r7 = rsqrt(r7);
	r6 = asint(-(asfloat(r6)) * gLightFallOff + float4(1, 1, 1, 1));
	r6 = asint(max(asfloat(r6), float4(0, 0, 0, 0)));
	r6 = asint(asfloat(r6) * asfloat(r6));
	r6 = asint(asfloat(r6) * asfloat(r6) + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001));
	r6 = asint(max(asfloat(r6), float4(0, 0, 0, 0)));
	r6 = asint(asfloat(r6) * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116));
	r8 = asfloat(r1.x) * asfloat(r3);
	r8 = asfloat(r4) * asfloat(r1.y) + r8;
	r1 = asint(asfloat(r5) * asfloat(r1.z) + r8);
	r1 = asint(asfloat(r6) * asfloat(r1));
	r1 = asint(saturate(r7 * asfloat(r1)));
	r3 = asint(asfloat(r3) * -(gLightDirX));
	r3 = asint(asfloat(r4) * -(gLightDirY) + asfloat(r3));
	r3 = asint(asfloat(r5) * -(gLightDirZ) + asfloat(r3));
	r3 = asint(r7 * asfloat(r3));
	r3 = asint(saturate(asfloat(r3) * gLightConeScale + gLightConeOffset));
	r1 = asint(asfloat(r1) * asfloat(r3));
	r3.x = asint(dot(gLightColR, asfloat(r1)));
	r3.y = asint(dot(gLightColG, asfloat(r1)));
	r3.z = asint(dot(gLightColB, asfloat(r1)));
	r1.xyz = asint(r2.xyz + asfloat(r3.xyz));
	r0.xyz = r0.xyz * asfloat(r1.xyz);
	o.sv_target.w = r0.w * globalScalars.x;
	r1.xyz = asint(i.texcoord2.xyz + -(gViewInverse[3].xyz));
	r0.w = saturate(-(i.texcoord1.w) * gDepthFxParams.z + gDepthFxParams.w);
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
	r0.xyz = r0.www * r0.xyz + asfloat(r1.xxx);
	o.sv_target.xyz = r0.xyz * matMaterialColorScale.xxx;
	o.sv_coverage = 255;

	return o;
}
