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
SamplerState EnvironmentSampler : register(s1);
SamplerState BloodSampler : register(s3);
SamplerState BumpSampler : register(s5);
SamplerState SpecSampler : register(s6);
SamplerState VolumeSampler : register(s7);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D EnvironmentSampler_tex : register(t1);
Texture2D BloodSampler_tex : register(t3);
Texture2D BumpSampler_tex : register(t5);
Texture2D SpecSampler_tex : register(t6);
Texture3D VolumeSampler_tex : register(t7);

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
	float3 r4;
	float4 r5;
	float3 r6;
	r0.xyz = asint(BumpSampler_tex.Sample(BumpSampler, i.texcoord.xy).xyw);
	r0.w = asint(-(asfloat(r0.z)) + 1);
	r0.w = (asfloat(r0.w) < asfloat(r0.x)) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xy = asint(-(asfloat(r0.zy)) + asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.ww) * asfloat(r1.xy) + asfloat(r0.zy));
	r1 = asint(ddx(i.texcoord.xyxy));
	r2 = asint(ddy(i.texcoord.xyxy));
	r2 = asint(asfloat(r2) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r2));
	r1 = asint(asfloat(r1) + i.texcoord.xyxy);
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.xy)).xwyz);
	r0.z = asint(asfloat(r2.y) + -0.5);
	r0.z = (asfloat(r0.z) >= 0) ? -1 : 0;
	r3.xyz = asint(asfloat(r2.yyy) * asfloat(r2.xzw));
	r3.xyz = r0.zzz & r3.xyz;
	r2.x = 1;
	r1.xy = r0.zz & r2.xy;
	r2 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r1.zw)));
	r0.w = asint(asfloat(r2.w) + -0.5);
	r0.w = (asfloat(r0.w) >= 0) ? -1 : 0;
	r4.x = (r0.z != 0) ? 0.000000 : 0.000000;
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r2.www) + asfloat(r3.xyz));
	r4.y = asfloat(r1.y) + asfloat(r2.w);
	r2.xyz = (r0.www != 0) ? r2.xyz : r3.xyz;
	r0.zw = (r0.ww != 0) ? asint(r4.xy) : r1.xy;
	r1.xyz = asint(asfloat(r2.xyz) / asfloat(r0.www));
	r0.xy = asint(asfloat(r0.xy) * float2(2, 2) + float2(-1, -1));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r1.w = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r1.w = asint(-(asfloat(r1.w)) + 1);
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2 = asint(SpecSampler_tex.Sample(SpecSampler, i.texcoord.xy));
	r2.w = asint(dot(asfloat(r2), specMapExpMask));
	r2.w = asint(asfloat(r2.w) * specularFactor);
	r3.x = asint(saturate(dot(asfloat(r2.xyz), specMapIntMask.xyz)));
	r2.w = asint(max(asfloat(r2.w), 1));
	r3.yzw = asint(asfloat(r0.xxx) * i.texcoord4.xyz);
	r3.yzw = asint(asfloat(r1.www) * i.texcoord1.xyz + asfloat(r3.yzw));
	r3.yzw = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r3.yzw));
	r3.yzw = asint(asfloat(r3.yzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.yzw), asfloat(r3.yzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r4 = asfloat(r0.xxx) * asfloat(r3.yzw);
	r5.xyz = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.y = asint(dot(r5.xyz, r5.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r5.xyz = asfloat(r0.yyy) * r5.xyz;
	r0.y = asint(dot(-(r5.xyz), r4.xyz));
	r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
	r6 = r4.xyz * -(asfloat(r0.yyy)) + -(r5.xyz);
	r6 = r6.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.y = asint(dot(r6.xyz, r6.xyz));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	r6 = asfloat(r0.yyy) * r6.zxy;
	r6.x = saturate(r6.x);
	r0.y = asint(r6.x + 1);
	r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
	r6.xy = r6.yz / asfloat(r0.yy);
	r6.xy = r6.xy + float2(0.5, 0.5);
	r6.xy = -(r6.xy) + float2(1, 1);
	r6 = EnvironmentSampler_tex.SampleLevel(EnvironmentSampler, r6.xy, 0).xyz;
	r6 = r6.xyz * r6.xyz;
	r6 = r6.xyz * float3(16, 16, 16);
	r0.y = asint(saturate(dot(r5.xyz, r4.xyz)));
	r1.w = asint(-(fresnelRolloff) + 1);
	r0.y = asint(-(asfloat(r0.y)) + 1.00001001);
	r4.x = asfloat(r0.y) * asfloat(r0.y);
	r4.x = r4.x * r4.x;
	r0.y = asint(asfloat(r0.y) * r4.x);
	r0.y = asint(fresnelRolloff * asfloat(r0.y) + asfloat(r1.w));
	r4 = asfloat(r0.yyy) * r6.xyz;
	r0.y = asint(EnvironmentSampler_tex.Sample(EnvironmentSampler, i.texcoord.xy).w);
	r4 = asfloat(r0.yyy) * r4.xyz;
	r4 = r4.xyz * reflectivePower;
	r0.y = asint(dot(asfloat(r2.xyz), specMapReflectMask.xyz));
	r4 = asfloat(r0.yyy) * r4.xyz;
	r4 = r4.xyz * ColorCorrectTopAndPedReflectScale.www;
	r0.y = (0 < gBloodData.w) ? -1 : 0;
	if (r0.y != 0) {
		r5.xyw = BloodSampler_tex.Sample(BloodSampler, i.texcoord.zw).xyw;
		r5.z = min(r5.y, r5.x);
		r0.y = asint(saturate(r5.x * 0.5 + r5.w));
		r5.xyz = -(asfloat(r1.xyz)) + r5.xyz;
		r1.xyz = asint(asfloat(r0.yyy) * r5.xyz + asfloat(r1.xyz));
	}
	r3.yzw = asint(asfloat(r3.yzw) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.yzw), asfloat(r3.yzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r5.xyz = asfloat(r0.xxx) * asfloat(r3.yzw);
	r0.y = asint(asfloat(r0.w) * i.texcoord2.w);
	r1.xyz = asint(asfloat(r1.xyz) * matMaterialColorScale.xxx);
	r4 = r4.xyz * matMaterialColorScale.zzz;
	r0.w = asint(asfloat(r3.x) * matMaterialColorScale.w);
	r1.w = asint(asfloat(r2.w) * matMaterialColorScale.w);
	r2.xyw = asint(i.texcoord7.xyz + -(gViewInverse[3].xyz));
	r2.xyw = asint(asfloat(r2.xyw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r3.x = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
	r3.x = asint(rsqrt(asfloat(r3.x)));
	r2.xyw = asint(asfloat(r2.xyw) * asfloat(r3.xxx));
	r3.xyz = asint(asfloat(r3.yzw) * asfloat(r0.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r3.xyz), asfloat(r3.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r3.xyz = asint(asfloat(r0.xxx) * asfloat(r3.xyz));
	r0.x = asint(dot(asfloat(r2.xyw), asfloat(r3.xyz)));
	r0.x = asint(asfloat(r0.x) * -1.5);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(max(asfloat(r0.x), 0));
	r0.x = asint(asfloat(r0.x) * i.texcoord2.y);
	r2.x = asint(saturate(asfloat(r0.w) * 5));
	r0.x = asint(asfloat(r0.x) * asfloat(r2.x));
	r2.x = asint(asfloat(r1.w) * 0.00510204071);
	r1.w = asint(saturate(-(asfloat(r1.w)) * 0.00999999978 + 1));
	r0.x = asint(asfloat(r1.w) * asfloat(r0.x) + asfloat(r0.w));
	r0.w = asint(asfloat(r2.z) * 16);
	r0.w = asint(trunc(asfloat(r0.w)));
	r3.xy = asint(i.texcoord.xy * detailSettings.zw);
	r0.w = asint(asfloat(r0.w) + 0.5);
	r3.z = asint(asfloat(r0.w) * 0.0625);
	r2.yzw = asint(VolumeSampler_tex.Sample(VolumeSampler, asfloat(r3.xyz)).xyz);
	r2.yzw = asint(asfloat(r2.zwy) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.w = asint(i.texcoord2.w * detailSettings.x);
	r0.w = asint(asfloat(r2.w) * asfloat(r0.w) + 1);
	o.sv_target.xyz = asfloat(r0.www) * asfloat(r1.xyz);
	r1.xyz = asint(asfloat(r2.zzz) * i.texcoord5.xyz);
	r1.xyz = asint(i.texcoord4.xyz * asfloat(r2.yyy) + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * detailSettings.yyy);
	r1.xyz = asint(asfloat(r1.xyz) * i.texcoord2.www + r5.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	o.sv_target2.x = saturate(asfloat(r0.w) * asfloat(r0.x));
	r0.x = asint(saturate(gAmbientOcclusionEffect.z));
	r0.x = asint(saturate(asfloat(r0.x) + i.texcoord2.x));
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r2.x = asint(saturate(asfloat(r2.x)));
	r0.w = asint(sqrt(asfloat(r2.x)));
	o.sv_target2.y = sqrt(asfloat(r0.w));
	o.sv_target2.z = asfloat(r0.x) * gAmbientOcclusionEffect.w;
	r0.x = asint(asfloat(r0.y) * globalScalars.x);
	r1.xyz = asint(saturate(r4.xyz * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r1.xyz));
	r0.yw = asint(frac(i.sv_position.xy));
	r0.yw = asint(asfloat(r0.yw) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.yw)), float2(1000, 1000));
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1.w = asfloat(r0.x);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = r0.z;

	return o;
}
