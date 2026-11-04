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
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
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

	int3 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int2 r6;
	r0.x = 1;
	r1 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.1875, -0.1875, 0.1875, 0.1875));
	r3 = asint(ddx(i.texcoord.xyxy));
	r2 = asint(asfloat(r3.zwzw) * float4(0.0625, 0.0625, -0.0625, -0.0625) + asfloat(r2));
	r2 = asint(asfloat(r2) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.xy)));
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r2.zw)));
	r0.y = r4.w;
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = r0.xy & r0.zz;
	r5.y = asint(asfloat(r2.w) + asfloat(r0.y));
	r5.x = (r0.z != 0) ? 3 : 2;
	r4.xyz = r4.xyz & r0.zzz;
	r0.z = asint(asfloat(r2.w) + -0.5);
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r4.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r2.xyz : r4.xyz;
	r4 = asint(asfloat(r1.zwzw) * float4(0.0625, 0.0625, -0.3125, -0.3125));
	r4 = asint(asfloat(r3.zwzw) * float4(0.3125, 0.3125, -0.1875, -0.1875) + asfloat(r4));
	r4 = asint(asfloat(r4) + i.texcoord.xyxy);
	r5 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)));
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r6.y = asint(asfloat(r0.y) + asfloat(r5.w));
	r6.x = r0.x + 4;
	r0.z = asint(asfloat(r5.w) + -0.5);
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r6.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r5.xyz : r2.xyz;
	r5.x = r0.x + 8;
	r5.y = asint(asfloat(r4.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r4.xyz : r2.xyz;
	r4 = asint(asfloat(r1.zwzw) * float4(0.3125, 0.3125, -0.0625, -0.0625));
	r1 = asint(asfloat(r1) * float4(0.4375, 0.4375, -0.4375, -0.4375));
	r1 = asint(asfloat(r3) * float4(0.1875, 0.1875, 0.4375, 0.4375) + asfloat(r1));
	r3 = asint(asfloat(r3.zwzw) * float4(-0.3125, -0.3125, -0.4375, -0.4375) + asfloat(r4));
	r3 = asint(asfloat(r3) + i.texcoord.xyxy);
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r4 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.xy)));
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r3.zw)));
	r5.y = asint(asfloat(r0.y) + asfloat(r4.w));
	r5.x = r0.x + 16;
	r0.z = asint(asfloat(r4.w) + -0.5);
	r4.xyz = asint(asfloat(r4.xyz) * asfloat(r4.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r5.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r4.xyz : r2.xyz;
	r4.x = r0.x + 32;
	r4.y = asint(asfloat(r3.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r3.w) + -0.5);
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r3 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)));
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r4.y = asint(asfloat(r0.y) + asfloat(r3.w));
	r4.x = r0.x + 64;
	r0.z = asint(asfloat(r3.w) + -0.5);
	r3.xyz = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r4.xy : r0.xy;
	r2.xyz = (r0.zzz != 0) ? r3.xyz : r2.xyz;
	r3.x = r0.x + 128;
	r3.y = asint(asfloat(r1.w) + asfloat(r0.y));
	r0.z = asint(asfloat(r1.w) + -0.5);
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyz));
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r0.xy = (r0.zz != 0) ? r3.xy : r0.xy;
	r1.xyz = (r0.zzz != 0) ? r1.xyz : r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) / asfloat(r0.yyy));
	o.sv_target.xyz = asfloat(r1.xyz) * i.texcoord.zzz;
	r0.y = asint(asfloat(r0.y) * globalScalars.x);
	o.sv_coverage = r0.x;
	o.sv_target.w = asfloat(r0.y);
	o.sv_target3.w = asfloat(r0.y);
	o.sv_target1.xyz = i.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target1.w = 0;
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target2.xy = float2(0, 0.5);
	o.sv_target2.z = gAmbientOcclusionEffect.y * 0.5;
	o.sv_target3.xyz = float3(0, 0, 0);

	return o;
}
