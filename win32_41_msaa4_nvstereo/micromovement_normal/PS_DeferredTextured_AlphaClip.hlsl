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
	int4 r3;
	int4 r4;
	float4 r5;
	int4 r6;
	float2 r7;
	r0 = asint(ddx(i.texcoord.xyxy));
	r1 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r2 = asint(asfloat(r0.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2.x = asint(asfloat(r3.w) + -0.5);
	r2.x = (asfloat(r2.x) >= 0) ? -1 : 0;
	r4.x = 1;
	r4.y = r3.w;
	r4.xy = r2.xx & r4.xy;
	r5 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw));
	r2.y = asint(r5.w + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r6.x = (r2.x != 0) ? 3 : 2;
	r6.y = asint(asfloat(r4.y) + r5.w);
	r2.zw = (r2.yy != 0) ? r6.xy : r4.xy;
	r1 = asint(asfloat(r1) * float4(0.125, 0.125, 0.375, 0.375));
	r0 = asint(asfloat(r0) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r4.x = r2.z + 4;
	r4.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.zw = (r0.xx != 0) ? r4.xy : r2.zw;
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r4.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r6.x = r2.z + 8;
	r6.y = asint(asfloat(r2.w) + asfloat(r4.w));
	r0.zw = (r0.yy != 0) ? r6.xy : r2.zw;
	r2.z = asint(asfloat(r0.w) * i.color.w);
	r2.z = asint(asfloat(r2.z) * globalScalars.x);
	r6.xyz = asint(i.texcoord6.xyz + -(gViewInverse[3].xyz));
	r2.w = asint(dot(asfloat(r6.xyz), asfloat(r6.xyz)));
	r2.w = asint(sqrt(asfloat(r2.w)));
	r2.w = asint(asfloat(r2.w) + -0.649999976);
	r2.w = asint(max(asfloat(r2.w), 0.25));
	r2.w = asint(min(asfloat(r2.w), 1));
	r2.w = asint(asfloat(r2.w) + -1);
	r2.w = asint(gDistFadeParams.x * asfloat(r2.w) + 1);
	r2.w = asint(asfloat(r2.w) * asfloat(r2.z));
	r6.x = (g_AlphaRef >= asfloat(r2.w)) ? -1 : 0;
	if (r6.x != 0) discard;
	r6.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r6.w = asint(-(asfloat(r6.z)) + 1);
	r6.w = (asfloat(r6.w) < asfloat(r6.x)) ? -1 : 0;
	r6.w = r6.w & 1065353216;
	r7 = -(asfloat(r6.zy)) + asfloat(r6.xy);
	r6.xy = asint(asfloat(r6.ww) * r7.xy + asfloat(r6.zy));
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r3.xyz = r2.xxx & r3.xyz;
	r5.xyz = r5.xyz * r5.www + asfloat(r3.xyz);
	r3.xyz = (r2.yyy != 0) ? asint(r5.xyz) : r3.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r3.xyz));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r3.xyz;
	r3.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r1.xyz));
	r1.xyz = (r0.yyy != 0) ? r3.xyz : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xy = asint(asfloat(r6.xy) * float2(2, 2) + float2(-1, -1));
	r1.xy = asint(asfloat(r1.xy) * bumpiness);
	r1.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(max(asfloat(r1.z), 0));
	r1.z = asint(sqrt(asfloat(r1.z)));
	r1.w = asint(max(specularFactor, 1));
	r3.xyz = asint(asfloat(r1.xxx) * i.texcoord4.xyz);
	r3.xyz = asint(asfloat(r1.zzz) * i.texcoord1.xyz + asfloat(r3.xyz));
	r1.xyz = asint(asfloat(r1.yyy) * i.texcoord5.xyz + asfloat(r3.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r2.x = asint(rsqrt(asfloat(r2.x)));
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r2.xxx));
	r2.x = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r2.xxx) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r1.w) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target.w = asfloat(r2.w);
	o.sv_target1.w = asfloat(r2.z);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.w = 1000;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r2.z);
	o.sv_coverage = r0.z;

	return o;
}
