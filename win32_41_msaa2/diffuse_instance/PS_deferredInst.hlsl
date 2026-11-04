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

SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
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
	int3 r2;
	r0 = asint(ddy(i.texcoord.xyxy));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(ddx(i.texcoord.xyxy));
	r0 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r0));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r2 = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r1.z = asint(asfloat(r1.y) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r2 = r2.xyz & r1.zzz;
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r1.w = asint(asfloat(r0.w) + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r0.xyz = (r1.www != 0) ? r0.xyz : r2.xyz;
	r1.x = 1;
	r1.xy = r1.xy & r1.zz;
	r2.x = (r1.z != 0) ? 3 : 2;
	r2.y = asint(asfloat(r0.w) + asfloat(r1.y));
	r1.xy = (r1.ww != 0) ? r2.xy : r1.xy;
	r0.xyz = asint(asfloat(r0.xyz) / asfloat(r1.yyy));
	r0.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r0.www) * globalScalars2.zzz + asfloat(r0.xyz);
	r0.x = asint(asfloat(r1.y) * i.color.w);
	o.sv_coverage = r1.x;
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_target1.xyz = i.texcoord2.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	o.sv_target2.xy = float2(0, 0.25);
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
