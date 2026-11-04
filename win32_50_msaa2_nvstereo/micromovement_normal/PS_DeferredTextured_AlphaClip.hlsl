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

cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
};

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BumpSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BumpSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
	uint sv_coverage : SV_Coverage;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	int4 r4;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r2.x = 1;
	r2.y = r1.w;
	r2.xy = r0.xx & r2.xy;
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw));
	r0.y = asint(r3.w + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.x & 1);
	r4.y = asint(asfloat(r2.y) + r3.w);
	r0.zw = (r0.yy != 0) ? r4.xy : r2.xy;
	r2.x = asint(asfloat(r0.w) * i.color.w);
	r2.x = asint(asfloat(r2.x) * globalScalars.x);
	r2.yzw = asint(i.texcoord6.xyz + -(gViewInverse[3].xyz));
	r2.y = asint(dot(asfloat(r2.yzw), asfloat(r2.yzw)));
	r2.y = asint(sqrt(asfloat(r2.y)));
	r2.y = asint(asfloat(r2.y) + -0.649999976);
	r2.y = asint(max(asfloat(r2.y), 0.25));
	r2.y = asint(min(asfloat(r2.y), 1));
	r2.y = asint(asfloat(r2.y) + -1);
	r2.y = asint(gDistFadeParams.x * asfloat(r2.y) + 1);
	r2.y = asint(asfloat(r2.y) * asfloat(r2.x));
	r2.z = (g_AlphaRef >= asfloat(r2.y)) ? -1 : 0;
	if (r2.z != 0) discard;
	r4.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r2.z = asint(-(asfloat(r4.z)) + 1);
	r2.z = (asfloat(r2.z) < asfloat(r4.x)) ? -1 : 0;
	r2.z = r2.z & 1065353216;
	r4.xw = asint(-(asfloat(r4.zy)) + asfloat(r4.xy));
	r2.zw = asint(asfloat(r2.zz) * asfloat(r4.xw) + asfloat(r4.zy));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.xyz = r0.xxx & r1.xyz;
	r3.xyz = r3.xyz * r3.www + asfloat(r1.xyz);
	r1.xyz = (r0.yyy != 0) ? asint(r3.xyz) : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xy = asint(asfloat(r2.zw) * float2(2, 2) + float2(-1, -1));
	r1.xy = asint(asfloat(r1.xy) * bumpiness);
	r1.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(max(asfloat(r1.z), 0));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r1.w = asint(max(specularFactor, 1));
	r3.xyz = asfloat(r1.xxx) * i.texcoord4.xyz;
	r3.xyz = asfloat(r1.zzz) * i.texcoord1.xyz + r3.xyz;
	r1.xyz = asint(asfloat(r1.yyy) * i.texcoord5.xyz + r3.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.z = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r2.z = asint(rsqrt(asfloat(r2.z)));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.zzz));
	r2.z = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r2.zzz) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r1.w) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target.w = asfloat(r2.y);
	o.sv_target1.w = asfloat(r2.x);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r2.x);
	o.sv_coverage = r0.z;

	return o;
}
