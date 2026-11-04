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
	float4 globalFogOffsetE : packoffset(c6);
	float4 globalFogOffsetN : packoffset(c7);
	float4 globalFogColorN : packoffset(c8);
	float4 globalScreenSize : packoffset(c9);
	float4 globalDayNightEffects : packoffset(c10);
	float4 ColorCorrectTop : packoffset(c11);
	float4 ColorCorrectBottomOffset : packoffset(c12);
	float4 ColorShift : packoffset(c13);
	float4 deSatContrastGamma : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gAmbientOcclusionEffect : packoffset(c17);
};

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gFacetCentre : packoffset(c1);
	float4 gShadowParam14151617 : packoffset(c2);
	float4 gShadowParam0123 : packoffset(c3);
	float4 gShadowParam4567 : packoffset(c4);
	float4 gShadowParam891113 : packoffset(c5);
	float4 gShadowParamPCF : packoffset(c6);
	row_major float4x4 gShadowMatrix : packoffset(c7);
};

cbuffer CacheMegaVariables : register(b1)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
};

cbuffer Fluid : register(b4)
{
	float4 DensityFieldCenter : packoffset(c0);
	float4 DensityField[32] : packoffset(c1);
	float4 MovementVector : packoffset(c33);
	row_major float4x4 ViewProjMtx : packoffset(c34);
	float Occlusion : packoffset(c38);
	float Glob : packoffset(c38.y);
	float Streak : packoffset(c38.z);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
SamplerComparisonState gShadowZSamplerDir : register(s15);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);
Texture2D ShadowZTextureDir : register(t15);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float texcoord8 : TEXCOORD8;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
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

	int4 r0;
	float4 r1;
	float4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	int4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 r12;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = -(asfloat(r0.zy)) + asfloat(r0.xy);
	r0.xy = asint(asfloat(r0.ww) * r1.xy + asfloat(r0.zy));
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r2.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r0.xzw = asint(asfloat(r0.zzz) * i.texcoord1.xyz + r2.xyz);
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r0.xzw));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2 = colorize * colorize;
	r1 = r1 * r2;
	r1.xyz = r1.xyz * r1.xyz;
	r0.w = asint(r1.w * i.color.w);
	r1.w = dot(i.texcoord3.xyz, i.texcoord3.xyz);
	r1.w = rsqrt(r1.w);
	r2.xyz = r1.www * i.texcoord3.xyz;
	r1.w = saturate(asfloat(r0.z) * -0.5 + 0.5);
	r3.xyz = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r3.xyz = asint(r1.www * asfloat(r3.xyz) + gLightAmbient0.xyz);
	r3.xyz = asint(asfloat(r3.xyz) * i.color.xxx);
	r3.xyz = asint(asfloat(r3.xyz) / gAmbientOcclusionEffect.yyy);
	r1.w = dot(-(r2.xyz), asfloat(r0.xyz));
	r1.w = r1.w + r1.w;
	r2.xyz = asfloat(r0.xyz) * -(r1.www) + -(r2.xyz);
	r4.xyz = asint(gDirectionalColour.www * gDirectionalColour.xyz);
	r1.w = dot(asfloat(r0.xyz), -(gDirectionalLight.xyz));
	r5.xy = asint(r1.ww + float2(0.649999976, 1));
	r2.w = saturate(asfloat(r5.y) * 0.5);
	r3.w = asint(dot(-(gDirectionalLight.xyz), r2.xyz));
	r4.w = asint(saturate(asfloat(r3.w)));
	r4.w = asint(asfloat(r4.w) + 0.0000199999995);
	r5.y = asint(specularFactor + 0.0000199999995);
	r4.w = asint(log2(asfloat(r4.w)));
	r4.w = asint(asfloat(r4.w) * asfloat(r5.y));
	r4.w = asint(exp2(asfloat(r4.w)));
	r5.y = asint(abs(asfloat(r3.w)) + 0.0000199999995);
	r6.xyz = asint(specularFactor * float3(1.5, 0.0149999997, 0.25) + float3(0.0000199999995, 0.0000199999995, 0.00000999999975));
	r5.y = asint(log2(asfloat(r5.y)));
	r5.y = asint(asfloat(r5.y) * asfloat(r6.x));
	r5.y = asint(exp2(asfloat(r5.y)));
	r5.x = asint(saturate(asfloat(r5.x)));
	r5.x = asint(asfloat(r5.x) * asfloat(r5.y));
	r5.x = asint(asfloat(r5.x) * 0.5);
	r5.x = asint(min(asfloat(r5.x), 0.0299999993));
	r4.w = asint(asfloat(r4.w) + asfloat(r5.x));
	r3.w = asint(saturate(asfloat(asint(-(asfloat(r3.w))))));
	r3.w = asint(asfloat(r3.w) + 0.0000199999995);
	r3.w = asint(log2(asfloat(r3.w)));
	r3.w = asint(asfloat(r3.w) * asfloat(r6.y));
	r3.w = asint(exp2(asfloat(r3.w)));
	r1.w = saturate(-(r1.w) + -0.600000024);
	r1.w = r1.w * asfloat(r3.w);
	r1.w = r1.w * 0.00999999978 + asfloat(r4.w);
	r5.xyz = asint(i.texcoord6.yyy * gShadowMatrix[1].xyz);
	r5.xyz = asint(i.texcoord6.xxx * gShadowMatrix[0].xyz + asfloat(r5.xyz));
	r5.xyz = asint(i.texcoord6.zzz * gShadowMatrix[2].xyz + asfloat(r5.xyz));
	r5.xyz = asint(asfloat(r5.xyz) + gShadowMatrix[3].xyz);
	r6.xyw = asint(-(i.texcoord6.xyz) + gViewInverse[3].xyz);
	r3.w = asint(dot(asfloat(r6.xyw), asfloat(r6.xyw)));
	r3.w = asint(sqrt(asfloat(r3.w)));
	r6.xyw = (asfloat(r3.www) >= gFacetCentre.xyz) ? -1 : 0;
	r7.yzw = r6.xyw & int3(1065353216, 1065353216, 1065353216);
	r7.x = 1065353216;
	r6.x = asint(dot(asfloat(r7), gShadowParam0123));
	r6.y = asint(dot(asfloat(r7), gShadowParam4567));
	r8.x = dot(asfloat(r7), gShadowParam891113);
	r8.y = dot(asfloat(r7), gShadowParam14151617);
	r5.xy = asint(asfloat(r5.xy) * asfloat(r6.xy) + r8.xy);
	r3.w = asint(-(asfloat(r5.z)) + 1);
	r3.w = asint(asfloat(r3.w) + -(gShadowParamPCF.z));
	r4.w = asint(gShadowParamPCF.x * -0.5);
	r4.w = (int)asfloat(r4.w);
	r5.z = asint(gShadowParamPCF.x * 0.5 + 1);
	r5.z = (int)asfloat(r5.z);
	r5.w = 0;
	r6.x = r4.w;
	while (true) {
		r6.y = (r6.x >= r5.z) ? -1 : 0;
		if (r6.y != 0) break;
		r6.y = asint((float)r6.x);
		r6.y = asint(asfloat(r6.y) * gShadowParamPCF.w);
		r7.x = asint(asfloat(r6.y) * gShadowParam18192021.x);
		r6.y = r5.w;
		r6.w = r4.w;
		while (true) {
			r7.z = (r6.w >= r5.z) ? -1 : 0;
			if (r7.z != 0) break;
			r7.z = asint((float)r6.w);
			r7.z = asint(asfloat(r7.z) * gShadowParamPCF.w);
			r7.y = asint(asfloat(r7.z) * gShadowParam18192021.y);
			r7.yz = asint(asfloat(r5.xy) + asfloat(r7.xy));
			r7.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r7.yz), asfloat(r3.w)));
			r6.y = asint(asfloat(r6.y) + asfloat(r7.y));
			r6.w = r6.w + 1;
		}
		r5.w = r6.y;
		r6.x = r6.x + 1;
	}
	r3.w = asint(gShadowParamPCF.x * gShadowParamPCF.x);
	r3.w = asint(asfloat(r5.w) / asfloat(r3.w));
	r3.w = asint(asfloat(r3.w) + -0.400000006);
	r3.w = asint(saturate(asfloat(r3.w) * 1.66666663));
	r4.w = asint(asfloat(r3.w) * -2 + 3);
	r3.w = asint(asfloat(r3.w) * asfloat(r3.w));
	r3.w = asint(asfloat(r3.w) * asfloat(r4.w));
	r3.w = asint(asfloat(r3.w) * 0.5 + 0.5);
	r5.xyz = asint(r1.www * asfloat(r4.xyz));
	r5.xyz = asint(asfloat(r3.www) * asfloat(r5.xyz));
	r4.xyz = asint(r2.www * asfloat(r4.xyz));
	r4.xyz = asint(asfloat(r3.www) * asfloat(r4.xyz));
	r5.xyz = asint(asfloat(r5.xyz) * gDirectionalLight.www);
	r1.w = dot(i.texcoord7.xyz, -(gDirectionalLight.xyz));
	r1.w = r1.w + 1;
	r1.w = r1.w * i.texcoord7.w;
	r1.w = r1.w * Occlusion;
	r1.w = saturate(-(r1.w) * 0.00249999994 + 1);
	r3.xyz = asint(asfloat(r4.xyz) * r1.www + asfloat(r3.xyz));
	r4 = asint(-(i.texcoord6.x) + gLightPosX);
	r7 = asint(-(i.texcoord6.y) + gLightPosY);
	r8 = -(i.texcoord6.z) + gLightPosZ;
	r9 = asfloat(r4) * asfloat(r4);
	r9 = asfloat(r7) * asfloat(r7) + r9;
	r9 = r8 * r8 + r9;
	r10 = rsqrt(r9);
	r9 = saturate(-(r9) * gLightFallOff + float4(1, 1, 1, 1));
	r9 = r9 * r9;
	r9 = r9 * r9 + float4(-0.100000001, -0.100000001, -0.100000001, -0.100000001);
	r9 = max(r9, float4(0, 0, 0, 0));
	r9 = r9 * float4(1.11111116, 1.11111116, 1.11111116, 1.11111116);
	r11 = asfloat(r4) * i.texcoord7.x;
	r11 = asfloat(r7) * i.texcoord7.y + r11;
	r11 = r8 * i.texcoord7.z + r11;
	r11 = max(r11, float4(0, 0, 0, 0));
	r12 = asfloat(r0.x) * asfloat(r4);
	r12 = asfloat(r7) * asfloat(r0.y) + r12;
	r12 = r8 * asfloat(r0.z) + r12;
	r11 = r11 * i.texcoord7.w;
	r11 = r11 * Occlusion;
	r11 = r11 * float4(0.00499999989, 0.00499999989, 0.00499999989, 0.00499999989);
	r9 = r12 * r9 + -(r11);
	r9 = saturate(r10 * r9);
	r11 = asfloat(r4) * -(gLightDirX);
	r11 = asfloat(r7) * -(gLightDirY) + r11;
	r11 = r8 * -(gLightDirZ) + r11;
	r11 = r10 * r11;
	r11 = saturate(r11 * gLightConeScale + gLightConeOffset);
	r9 = r9 * r11;
	r4 = asint(r2.x * asfloat(r4));
	r4 = asint(r2.y * asfloat(r7) + asfloat(r4));
	r2 = r2.z * r8 + asfloat(r4);
	r2 = r10 * r2;
	r2 = abs(r2) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2 = log2(r2);
	r2 = r2 * asfloat(r6.z);
	r2 = exp2(r2);
	r2 = r9 * r2;
	r0.x = asint(dot(gLightColR, r9));
	r0.y = asint(dot(gLightColG, r9));
	r0.z = asint(dot(gLightColB, r9));
	r4.x = asint(dot(gLightColR, r2));
	r4.y = asint(dot(gLightColG, r2));
	r4.z = asint(dot(gLightColB, r2));
	r0.xyz = asint(asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + asfloat(r3.xyz));
	r2.xyz = asfloat(r4.xyz) * float3(0.5, 0.5, 0.5);
	r2.xyz = asfloat(r5.xyz) * r1.www + r2.xyz;
	r1.w = -(abs(i.texcoord8)) * 15 + 1;
	r1.w = max(r1.w, 0);
	r2.xyz = r1.www * r2.xyz;
	r2.xyz = r2.xyz * specularColorFactor;
	r0.xyz = asint(r1.xyz * asfloat(r0.xyz) + r2.xyz);
	o.sv_target.w = asfloat(r0.w) * globalScalars.x;
	r0.w = asint(i.sv_position.y / globalScreenSize.y);
	r1.x = saturate(-(i.texcoord1.w) * gDepthFxParams.z + gDepthFxParams.w);
	r1.y = -(r1.x) + 1;
	r1.xy = r1.yy * gDepthFxParams.xy + r1.xx;
	r1.z = dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986));
	r0.xyz = asint(asfloat(r0.xyz) + -(r1.zzz));
	r0.xyz = asint(r1.xxx * asfloat(r0.xyz) + r1.zzz);
	r1.xy = r1.zy + float2(0.00000999999975, -0.999989986);
	r1.x = abs(r1.x) + 0.00000999999975;
	r1.x = log2(r1.x);
	r1.x = r1.x * r1.y;
	r1.x = exp2(r1.x);
	r1.yzw = asfloat(r0.xyz) * r1.xxx;
	r2.x = saturate(i.texcoord1.w / globalFogParams.x);
	r2.y = i.texcoord1.w + -(globalFogParams.x);
	r2.z = -(globalFogParams.x) + globalFogParams.y;
	r2.y = saturate(r2.y / r2.z);
	r2.z = -(globalFogParams.w) + 1;
	r2.z = r2.z * r2.y;
	r2.x = r2.x * globalFogParams.w + r2.z;
	r2.x = r2.x + globalFogParams.z;
	r2.yzw = -(globalFogOffsetN.xyz) * r2.yyy + globalFogColorN.xyz;
	r0.xyz = asint(-(asfloat(r0.xyz)) * r1.xxx + r2.yzw);
	r0.xyz = asint(r2.xxx * asfloat(r0.xyz) + r1.yzw);
	r1.x = dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986));
	r0.xyz = asint(asfloat(r0.xyz) + -(r1.xxx));
	r0.xyz = asint(deSatContrastGamma.xxx * asfloat(r0.xyz) + r1.xxx);
	r1.x = r1.x * ColorShift.w;
	r1.yzw = r1.xxx * ColorShift.xyz;
	r2.x = saturate(r1.x);
	r0.xyz = asint(-(ColorShift.xyz) * r1.xxx + asfloat(r0.xyz));
	r0.xyz = asint(r2.xxx * asfloat(r0.xyz) + r1.yzw);
	r1.xyz = asfloat(r0.www) * ColorCorrectBottomOffset.xyz + ColorCorrectTop.xyz;
	o.sv_target.xyz = asfloat(r0.xyz) * r1.xyz;
	o.sv_coverage = 255;

	return o;
}
