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

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float displacementScale : packoffset(c0.y);
	float4 matMaterialColorScale : packoffset(c1);
	float4 gBloodData : packoffset(c2);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BloodSampler : register(s2);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BloodSampler_tex : register(t2);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
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
	float4 r3;
	int2 r4;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0.x = asint(asfloat(r1.y) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r2 = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r2 = r0.xxx & r2.xyz;
	r1.x = 1;
	r1.xy = r0.xx & r1.xy;
	r3 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw));
	r0.y = asint(r3.w + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.x & 1);
	r0.xzw = asint(r3.xyz * r3.www + asfloat(r2.xyz));
	r4.y = asint(asfloat(r1.y) + r3.w);
	r0.xzw = (r0.yyy != 0) ? r0.xzw : r2.xyz;
	r1.xy = (r0.yy != 0) ? r4.xy : r1.xy;
	r0.xyz = asint(asfloat(r0.xzw) / asfloat(r1.yyy));
	r2 = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2 = asint(asfloat(r0.www) * asfloat(r2.xyz));
	r0.w = (0 < gBloodData.w) ? -1 : 0;
	if (r0.w != 0) {
		r3.xyw = BloodSampler_tex.Sample(BloodSampler, i.texcoord.zw).xyw;
		r3.z = min(r3.y, r3.x);
		r0.w = asint(saturate(r3.x * 0.5 + r3.w));
		r3.xyz = -(asfloat(r0.xyz)) + r3.xyz;
		r0.xyz = asint(asfloat(r0.www) * r3.xyz + asfloat(r0.xyz));
	}
	r0.w = asint(asfloat(r1.y) * i.texcoord2.w);
	o.sv_target.xyz = asfloat(r0.xyz) * matMaterialColorScale.xxx;
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r2.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r0.w) * globalScalars.x);
	r0.yz = asint(frac(i.sv_position.xy));
	r0.yz = asint(asfloat(r0.yz) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yz)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target2.xy = float2(0, 0.25);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.x;

	return o;
}
