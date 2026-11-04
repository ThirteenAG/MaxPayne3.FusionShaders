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
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	float2 r6;
	float2 r7;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r2.xyz = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	r0.xzw = asint(asfloat(r0.zzz) * i.texcoord1.xyz + asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r0.xzw));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2 = asint(colorize * colorize);
	r1 = asint(asfloat(r1) * asfloat(r2));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.xyz));
	r0.w = asint(asfloat(r1.w) * i.color.w);
	r1.w = asint(dot(i.texcoord3.xyz, i.texcoord3.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyz = asint(asfloat(r1.www) * i.texcoord3.xyz);
	r1.w = asint(saturate(asfloat(r0.z) * -0.5 + 0.5));
	r3.xyz = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r3.xyz = asint(asfloat(r1.www) * asfloat(r3.xyz) + gLightAmbient0.xyz);
	r3.xyz = asint(asfloat(r3.xyz) * i.color.xxx);
	r3.xyz = asint(asfloat(r3.xyz) / gAmbientOcclusionEffect.yyy);
	r1.w = asint(dot(-(asfloat(r2.xyz)), asfloat(r0.xyz)));
	r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
	r2.xyz = asint(asfloat(r0.xyz) * -(asfloat(r1.www)) + -(asfloat(r2.xyz)));
	r4.xyz = asint(gDirectionalColour.www * gDirectionalColour.xyz);
	r0.x = asint(dot(asfloat(r0.xyz), -(gDirectionalLight.xyz)));
	r0.yz = asint(asfloat(r0.xx) + float2(0.649999976, 1));
	r1.w = asint(dot(-(gDirectionalLight.xyz), asfloat(r2.xyz)));
	r2.x = asint(saturate(asfloat(r1.w)));
	r2.x = asint(asfloat(r2.x) + 0.0000199999995);
	r2.y = asint(specularFactor + 0.0000199999995);
	r2.x = asint(log2(asfloat(r2.x)));
	r2.x = asint(asfloat(r2.x) * asfloat(r2.y));
	r2.x = asint(exp2(asfloat(r2.x)));
	r2.y = asint(abs(asfloat(r1.w)) + 0.0000199999995);
	r2.zw = asint(specularFactor * float2(1.5, 0.0149999997) + float2(0.0000199999995, 0.0000199999995));
	r2.y = asint(log2(asfloat(r2.y)));
	r2.y = asint(asfloat(r2.y) * asfloat(r2.z));
	r2.y = asint(exp2(asfloat(r2.y)));
	r0.y = asint(saturate(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * asfloat(r2.y));
	r0.y = asint(asfloat(r0.y) * 0.5);
	r0.y = asint(min(asfloat(r0.y), 0.0299999993));
	r0.y = asint(asfloat(r0.y) + asfloat(r2.x));
	r1.w = asint(saturate(asfloat(asint(-(asfloat(r1.w))))));
	r1.w = asint(asfloat(r1.w) + 0.0000199999995);
	r1.w = asint(log2(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) * asfloat(r2.w));
	r1.w = asint(exp2(asfloat(r1.w)));
	r0.x = asint(saturate(-(asfloat(r0.x)) + -0.600000024));
	r0.x = asint(asfloat(r0.x) * asfloat(r1.w));
	r0.x = asint(asfloat(r0.x) * 0.00999999978 + asfloat(r0.y));
	r2.xyz = asint(i.texcoord6.yyy * gShadowMatrix[1].xyz);
	r2.xyz = asint(i.texcoord6.xxx * gShadowMatrix[0].xyz + asfloat(r2.xyz));
	r2.xyz = asint(i.texcoord6.zzz * gShadowMatrix[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + gShadowMatrix[3].xyz);
	r5.xyz = asint(-(i.texcoord6.xyz) + gViewInverse[3].xyz);
	r0.y = asint(dot(asfloat(r5.xyz), asfloat(r5.xyz)));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r5.xyz = (asfloat(r0.yyy) >= gFacetCentre.xyz) ? -1 : 0;
	r5.yzw = r5.xyz & int3(1065353216, 1065353216, 1065353216);
	r5.x = 1065353216;
	r6.x = dot(asfloat(r5), gShadowParam0123);
	r6.y = dot(asfloat(r5), gShadowParam4567);
	r7.x = dot(asfloat(r5), gShadowParam891113);
	r7.y = dot(asfloat(r5), gShadowParam14151617);
	r2.xy = asint(asfloat(r2.xy) * r6.xy + r7.xy);
	r0.y = asint(-(asfloat(r2.z)) + 1);
	r0.y = asint(asfloat(r0.y) + -(gShadowParamPCF.z));
	r1.w = asint(gShadowParamPCF.x * -0.5);
	r1.w = (int)asfloat(r1.w);
	r2.z = asint(gShadowParamPCF.x * 0.5 + 1);
	r2.z = (int)asfloat(r2.z);
	r2.w = 0;
	r3.w = r1.w;
	while (true) {
		r4.w = (r3.w >= r2.z) ? -1 : 0;
		if (r4.w != 0) break;
		r4.w = asint((float)r3.w);
		r4.w = asint(asfloat(r4.w) * gShadowParamPCF.w);
		r5.x = asint(asfloat(r4.w) * gShadowParam18192021.x);
		r4.w = r2.w;
		r5.z = r1.w;
		while (true) {
			r5.w = (r5.z >= r2.z) ? -1 : 0;
			if (r5.w != 0) break;
			r5.w = asint((float)r5.z);
			r5.w = asint(asfloat(r5.w) * gShadowParamPCF.w);
			r5.y = asint(asfloat(r5.w) * gShadowParam18192021.y);
			r5.yw = asint(asfloat(r2.xy) + asfloat(r5.xy));
			r5.y = asint(ShadowZTextureDir.SampleCmpLevelZero(gShadowZSamplerDir, asfloat(r5.yw), asfloat(r0.y)));
			r4.w = asint(asfloat(r4.w) + asfloat(r5.y));
			r5.z = r5.z + 1;
		}
		r2.w = r4.w;
		r3.w = r3.w + 1;
	}
	r0.y = asint(gShadowParamPCF.x * gShadowParamPCF.x);
	r0.y = asint(asfloat(r2.w) / asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) + -0.400000006);
	r0.yz = asint(saturate(asfloat(r0.yz) * float2(1.66666663, 0.5)));
	r1.w = asint(asfloat(r0.y) * -2 + 3);
	r0.y = asint(asfloat(r0.y) * asfloat(r0.y));
	r0.y = asint(asfloat(r0.y) * asfloat(r1.w));
	r0.y = asint(asfloat(r0.y) * 0.5 + 0.5);
	r2.xyz = asint(asfloat(r0.xxx) * asfloat(r4.xyz));
	r2.xyz = asint(asfloat(r0.yyy) * asfloat(r2.xyz));
	r4.xyz = asint(asfloat(r0.zzz) * asfloat(r4.xyz));
	r0.xyz = asint(asfloat(r0.yyy) * asfloat(r4.xyz));
	r2.xyz = asint(asfloat(r2.xyz) * gDirectionalLight.www);
	r1.w = asint(dot(i.texcoord7.xyz, -(gDirectionalLight.xyz)));
	r1.w = asint(asfloat(r1.w) + 1);
	r1.w = asint(asfloat(r1.w) * i.texcoord7.w);
	r1.w = asint(asfloat(r1.w) * Occlusion);
	r1.w = asint(saturate(-(asfloat(r1.w)) * 0.00249999994 + 1));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.www) + asfloat(r3.xyz));
	r2.xyz = asint(asfloat(r1.www) * asfloat(r2.xyz));
	r1.w = asint(-(abs(i.texcoord8)) * 15 + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r2.xyz = asint(asfloat(r1.www) * asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) * specularColorFactor);
	r0.xyz = asint(asfloat(r1.xyz) * asfloat(r0.xyz) + asfloat(r2.xyz));
	o.sv_target.w = asfloat(r0.w) * globalScalars.x;
	r0.w = asint(i.sv_position.y / globalScreenSize.y);
	r1.x = asint(saturate(-(i.texcoord1.w) * gDepthFxParams.z + gDepthFxParams.w));
	r1.y = asint(-(asfloat(r1.x)) + 1);
	r1.xy = asint(asfloat(r1.yy) * gDepthFxParams.xy + asfloat(r1.xx));
	r1.z = asint(dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986)));
	r0.xyz = asint(asfloat(r0.xyz) + -(asfloat(r1.zzz)));
	r0.xyz = asint(asfloat(r1.xxx) * asfloat(r0.xyz) + asfloat(r1.zzz));
	r1.xy = asint(asfloat(r1.zy) + float2(0.00000999999975, -0.999989986));
	r1.x = asint(abs(asfloat(r1.x)) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.yzw = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r2.x = asint(saturate(i.texcoord1.w / globalFogParams.x));
	r2.y = asint(i.texcoord1.w + -(globalFogParams.x));
	r2.z = asint(-(globalFogParams.x) + globalFogParams.y);
	r2.y = asint(saturate(asfloat(r2.y) / asfloat(r2.z)));
	r2.z = asint(-(globalFogParams.w) + 1);
	r2.z = asint(asfloat(r2.z) * asfloat(r2.y));
	r2.x = asint(asfloat(r2.x) * globalFogParams.w + asfloat(r2.z));
	r2.x = asint(asfloat(r2.x) + globalFogParams.z);
	r2.yzw = asint(-(globalFogOffsetN.xyz) * asfloat(r2.yyy) + globalFogColorN.xyz);
	r0.xyz = asint(-(asfloat(r0.xyz)) * asfloat(r1.xxx) + asfloat(r2.yzw));
	r0.xyz = asint(asfloat(r2.xxx) * asfloat(r0.xyz) + asfloat(r1.yzw));
	r1.x = asint(dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986)));
	r0.xyz = asint(asfloat(r0.xyz) + -(asfloat(r1.xxx)));
	r0.xyz = asint(deSatContrastGamma.xxx * asfloat(r0.xyz) + asfloat(r1.xxx));
	r1.x = asint(asfloat(r1.x) * ColorShift.w);
	r1.yzw = asint(asfloat(r1.xxx) * ColorShift.xyz);
	r2.x = asint(saturate(asfloat(r1.x)));
	r0.xyz = asint(-(ColorShift.xyz) * asfloat(r1.xxx) + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r2.xxx) * asfloat(r0.xyz) + asfloat(r1.yzw));
	r1.xyz = asint(asfloat(r0.www) * ColorCorrectBottomOffset.xyz + ColorCorrectTop.xyz);
	o.sv_target.xyz = asfloat(r0.xyz) * asfloat(r1.xyz);
	o.sv_coverage = 255;

	return o;
}
