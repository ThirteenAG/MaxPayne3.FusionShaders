cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float reflectivePower : packoffset(c0.y);
	float3 specMapReflectMask : packoffset(c1);
	float fresnelRolloff : packoffset(c1.w);
	float bumpiness : packoffset(c2);
	float displacementScale : packoffset(c2.y);
	float specularFactor : packoffset(c2.z);
	float3 specMapIntMask : packoffset(c3);
	float4 specMapExpMask : packoffset(c4);
	float4 matMaterialColorScale : packoffset(c5);
	float4 gBloodData : packoffset(c6);
};

cbuffer Details : register(b7)
{
	float4 detailSettings : packoffset(c0);
};

SamplerState DiffuseSampler : register(s0);
SamplerState BloodSampler : register(s2);
SamplerState BumpSampler : register(s4);
SamplerState SpecSampler : register(s5);
SamplerState VolumeSampler : register(s6);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D BloodSampler_tex : register(t2);
Texture2D BumpSampler_tex : register(t4);
Texture2D SpecSampler_tex : register(t5);
Texture3D VolumeSampler_tex : register(t6);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
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
	int4 r2;
	int4 r3;
	int4 r4;
	float4 r5;
	float4 r6;
	float3 r7;
	float3 r8;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r0.z = asint(dot(i.texcoord2.xyz, float3(0.300000012, 0.600000024, 0.100000001)));
	r1 = asint(ddx_coarse(i.texcoord.xyxy));
	r2 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r2) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)).xwyz);
	r0.w = asint(asfloat(r2.y) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r3.xyz = asint(asfloat(r2.yyy) * asfloat(r2.xzw));
	r3.xyz = r0.www & r3.xyz;
	r2.x = 1;
	r1.xy = r0.ww & r2.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r1.z = asint(asfloat(r2.w) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.w & 1);
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r4.y = asint(asfloat(r1.y) + asfloat(r2.w));
	r2.xyz = (r1.zzz != 0) ? r2.xyz : r3.xyz;
	r1.xy = (r1.zz != 0) ? r4.xy : r1.xy;
	r2.xyz = asint(asfloat(r2.xyz) / asfloat(r1.yyy));
	r3.xyz = asint(i.texcoord2.xyz);
	r3.w = 1065353216;
	r2.w = r1.y;
	r4 = asint(asfloat(r2) * asfloat(r3));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.w = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r5 = SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy);
	r1.y = asint(dot(r5, specMapExpMask));
	r1.y = asint(asfloat(r1.y) * specularFactor);
	r1.z = asint(dot(r5.xyz, specMapIntMask.xyz));
	r1.y = asint(max(asfloat(r1.y), 1));
	r6.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r6.xyz = asfloat(r0.www) * i.texcoord1.xyz + r6.xyz;
	r0.xyw = asint(asfloat(r0.yyy) * i.texcoord5.xyz + r6.xyz);
	r0.xyw = asint(asfloat(r0.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r6.xyz = asfloat(r0.xyw) * asfloat(r1.www);
	r2.w = (0 < reflectivePower) ? -1 : 0;
	if (r2.w != 0) {
		r2.w = asint(asfloat(r1.y) * 0.015625);
		r2.w = asint(min(asfloat(r2.w), 1));
		r2.w = asint(-(asfloat(r2.w)) * 4 + 4);
		r7 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r3.w = asint(dot(r7.xyz, r7.xyz));
		r3.w = asint(rsqrt(asfloat(r3.w)));
		r7 = asfloat(r3.www) * r7.xyz;
		r3.w = asint(dot(-(r7.xyz), r6.xyz));
		r3.w = asint(asfloat(r3.w) + asfloat(r3.w));
		r8 = r6.xyz * -(asfloat(r3.www)) + -(r7.xyz);
		r8 = r8.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r3.w = asint(dot(r8.xyz, r8.xyz));
		r3.w = asint(rsqrt(asfloat(r3.w)));
		r8 = asfloat(r3.www) * r8.zxy;
		r8.x = saturate(r8.x);
		r3.w = asint(r8.x + 1);
		r3.w = asint(asfloat(r3.w) + asfloat(r3.w));
		r8.xy = r8.yz / asfloat(r3.ww);
		r8.xy = r8.xy + float2(0.5, 0.5);
		r8.xy = -(r8.xy) + float2(1, 1);
		r8 = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r8.xy, asfloat(r2.w)).xyz;
		r8 = r8.xyz * r8.xyz;
		r8 = r8.xyz * float3(16, 16, 16);
		r2.w = asint(saturate(dot(r7.xyz, r6.xyz)));
		r3.w = asint(-(fresnelRolloff) + 1);
		r2.w = asint(-(asfloat(r2.w)) + 1.00001001);
		r5.w = asfloat(r2.w) * asfloat(r2.w);
		r5.w = r5.w * r5.w;
		r2.w = asint(asfloat(r2.w) * r5.w);
		r2.w = asint(fresnelRolloff * asfloat(r2.w) + asfloat(r3.w));
		r6.xyz = asfloat(r2.www) * r8.xyz;
	} else {
		r6.xyz = float3(0, 0, 0);
	}
	r6.xyz = r6.xyz * reflectivePower;
	r2.w = asint(dot(r5.xyz, specMapReflectMask.xyz));
	r5.xyw = asfloat(r2.www) * r6.xyz;
	r5.xyw = r5.xyw * ColorCorrectTopAndPedReflectScale.www;
	r2.w = (0 < gBloodData.w) ? -1 : 0;
	if (r2.w != 0) {
		r6.xyw = BloodSampler_tex.Sample(BloodSampler, i.texcoord.zw).xyw;
		r6.z = min(r6.y, r6.x);
		r2.w = asint(saturate(r6.x * 0.5 + r6.w));
		r2.xyz = asint(-(asfloat(r3.xyz)) * asfloat(r2.xyz) + r6.xyz);
		r4.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz) + asfloat(r4.xyz));
	}
	r0.xyw = asint(asfloat(r0.xyw) * asfloat(r1.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyz = asint(asfloat(r0.xyw) * asfloat(r1.www));
	r2.w = asint(asfloat(r4.w) * i.texcoord2.w);
	r0.z = asint(asfloat(r0.z) * globalScalars.z + -1);
	r0.z = asint(gAmbientOcclusionEffect.x * asfloat(r0.z) + 1);
	r3.xyz = asint(asfloat(r4.xyz) * matMaterialColorScale.xxx);
	r4.xyz = asint(r5.xyw * matMaterialColorScale.zzz);
	r1.yz = asint(asfloat(r1.yz) * matMaterialColorScale.ww);
	r5.xyw = i.texcoord7.xyz + -(gViewInverse[3].xyz);
	r5.xyw = r5.xyw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = asint(dot(r5.xyw, r5.xyw));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r5.xyw = asfloat(r3.www) * r5.xyw;
	r0.xyw = asint(asfloat(r0.xyw) * asfloat(r1.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r0.xyw), asfloat(r0.xyw)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r0.xyw = asint(asfloat(r0.xyw) * asfloat(r1.www));
	r0.x = asint(dot(r5.xyw, asfloat(r0.xyw)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r0.y = asint(saturate(asfloat(r1.z) * 5));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r5.x = asfloat(r1.y) * 0.00510204071;
	r0.y = asint(saturate(-(asfloat(r1.y)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x) + asfloat(r1.z));
	r0.y = asint(r5.z * 16);
	r0.y = asint(trunc(asfloat(r0.y)));
	r6.xy = i.texcoord.xy * detailSettings.zw;
	r0.y = asint(asfloat(r0.y) + 0.5);
	r6.z = asfloat(r0.y) * 0.0625;
	r1.yzw = asint(VolumeSampler_tex.Sample(VolumeSampler, r6.xyz).xyz);
	r1.yzw = asint(asfloat(r1.zwy) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.y = asint(i.texcoord2.w * detailSettings.x);
	r0.y = asint(asfloat(r1.w) * asfloat(r0.y) + 1);
	o.sv_target.xyz = asfloat(r0.yyy) * asfloat(r3.xyz);
	r3.xyz = asint(asfloat(r1.zzz) * i.texcoord5.xyz);
	r1.yzw = asint(i.texcoord4.xyz * asfloat(r1.yyy) + asfloat(r3.xyz));
	r1.yzw = asint(asfloat(r1.yzw) * detailSettings.yyy);
	r1.yzw = asint(asfloat(r1.yzw) * i.texcoord2.www + asfloat(r2.xyz));
	r1.yzw = asint(asfloat(r1.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r1.yzw), asfloat(r1.yzw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.yzw = asint(asfloat(r0.www) * asfloat(r1.yzw));
	o.sv_target2.x = saturate(asfloat(r0.y) * asfloat(r0.x));
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + asfloat(r0.z)));
	o.sv_target1.xyz = asfloat(r1.yzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r5.x = saturate(r5.x);
	r0.y = asint(sqrt(r5.x));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r2.w) * globalScalars.x);
	r0.yzw = asint(saturate(asfloat(r4.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.yzw));
	r0.yz = asint(frac(i.sv_position.xy));
	r0.yz = asint(asfloat(r0.yz) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yz)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r1.x;

	return o;
}
