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
	float reflectivePower : packoffset(c0.z);
	float fresnelRolloff : packoffset(c0.w);
};

SamplerState DiffuseSampler : register(s0);
SamplerState DynamicEnvironmentSampler : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D DynamicEnvironmentSampler_tex : register(t13);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
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
	int4 r7;
	int4 r8;
	float4 r9;
	int4 r10;
	int4 r11;
	float3 r12;
	float3 r13;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.1875, -0.1875, 0.1875, 0.1875));
	r2 = asint(asfloat(r0.zwzw) * float4(0.0625, 0.0625, -0.0625, -0.0625) + asfloat(r2));
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
	r6.x = (2 & ~1) | (r2.x & 1);
	r6.y = asint(asfloat(r4.y) + r5.w);
	r2.zw = (r2.yy != 0) ? r6.xy : r4.xy;
	r4 = asint(asfloat(r1.zwzw) * float4(0.0625, 0.0625, -0.3125, -0.3125));
	r4 = asint(asfloat(r0.zwzw) * float4(0.3125, 0.3125, -0.1875, -0.1875) + asfloat(r4));
	r4 = asint(asfloat(r4) + i.texcoord.xyxy);
	r6 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.xy)));
	r4.x = asint(asfloat(r6.w) + -0.5);
	r4.x = (asfloat(r4.x) >= 0) ? -1 : 0;
	r7.x = r2.z + 4;
	r7.y = asint(asfloat(r2.w) + asfloat(r6.w));
	r2.zw = (r4.xx != 0) ? r7.xy : r2.zw;
	r7 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r4.zw)));
	r4.y = asint(asfloat(r7.w) + -0.5);
	r4.y = (asfloat(r4.y) >= 0) ? -1 : 0;
	r8.x = r2.z + 8;
	r8.y = asint(asfloat(r2.w) + asfloat(r7.w));
	r2.zw = (r4.yy != 0) ? r8.xy : r2.zw;
	r8 = asint(asfloat(r1.zwzw) * float4(0.3125, 0.3125, -0.0625, -0.0625));
	r8 = asint(asfloat(r0.zwzw) * float4(-0.3125, -0.3125, -0.4375, -0.4375) + asfloat(r8));
	r8 = asint(asfloat(r8) + i.texcoord.xyxy);
	r9 = DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r8.xy));
	r4.z = asint(r9.w + -0.5);
	r4.z = (asfloat(r4.z) >= 0) ? -1 : 0;
	r8.x = r2.z + 16;
	r8.y = asint(asfloat(r2.w) + r9.w);
	r2.zw = (r4.zz != 0) ? r8.xy : r2.zw;
	r8 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r8.zw)));
	r4.w = asint(asfloat(r8.w) + -0.5);
	r4.w = (asfloat(r4.w) >= 0) ? -1 : 0;
	r10.x = r2.z + 32;
	r10.y = asint(asfloat(r2.w) + asfloat(r8.w));
	r2.zw = (r4.ww != 0) ? r10.xy : r2.zw;
	r1 = asint(asfloat(r1) * float4(0.4375, 0.4375, -0.4375, -0.4375));
	r0 = asint(asfloat(r0) * float4(0.1875, 0.1875, 0.4375, 0.4375) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r10.x = r2.z + 64;
	r10.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.zw = (r0.xx != 0) ? r10.xy : r2.zw;
	r10 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r10.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r11.x = r2.z + 128;
	r11.y = asint(asfloat(r2.w) + asfloat(r10.w));
	r0.zw = (r0.yy != 0) ? r11.xy : r2.zw;
	r11.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.z = asint(dot(asfloat(r11.xyz), asfloat(r11.xyz)));
	r2.z = asint(rsqrt(asfloat(r2.z)));
	r11.xyz = asint(asfloat(r2.zzz) * asfloat(r11.xyz));
	r2.z = asint(max(specularFactor, 1));
	r2.w = (0 < reflectivePower) ? -1 : 0;
	if (r2.w != 0) {
		r2.w = asint(asfloat(r2.z) * 0.015625);
		r2.w = asint(min(asfloat(r2.w), 1));
		r2.w = asint(-(asfloat(r2.w)) * 4 + 4);
		r12 = i.texcoord3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r11.w = asint(dot(r12.xyz, r12.xyz));
		r11.w = asint(rsqrt(asfloat(r11.w)));
		r12 = asfloat(r11.www) * r12.xyz;
		r11.w = asint(dot(-(r12.xyz), asfloat(r11.xyz)));
		r11.w = asint(asfloat(r11.w) + asfloat(r11.w));
		r13 = asfloat(r11.xyz) * -(asfloat(r11.www)) + -(r12.xyz);
		r13 = r13.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
		r11.w = asint(dot(r13.xyz, r13.xyz));
		r11.w = asint(rsqrt(asfloat(r11.w)));
		r13 = asfloat(r11.www) * r13.zxy;
		r13.x = saturate(r13.x);
		r11.w = asint(r13.x + 1);
		r11.w = asint(asfloat(r11.w) + asfloat(r11.w));
		r13.xy = r13.yz / asfloat(r11.ww);
		r13.xy = r13.xy + float2(0.5, 0.5);
		r13.xy = -(r13.xy) + float2(1, 1);
		r13 = DynamicEnvironmentSampler_tex.SampleLevel(DynamicEnvironmentSampler, r13.xy, asfloat(r2.w)).xyz;
		r13 = r13.xyz * r13.xyz;
		r13 = r13.xyz * float3(16, 16, 16);
		r2.w = asint(saturate(dot(r12.xyz, asfloat(r11.xyz))));
		r11.w = asint(-(fresnelRolloff) + 1);
		r2.w = asint(-(asfloat(r2.w)) + 1.00001001);
		r12.x = asfloat(r2.w) * asfloat(r2.w);
		r12.x = r12.x * r12.x;
		r2.w = asint(asfloat(r2.w) * r12.x);
		r2.w = asint(fresnelRolloff * asfloat(r2.w) + asfloat(r11.w));
		r12 = asfloat(r2.www) * r13.xyz;
	} else {
		r12 = float3(0, 0, 0);
	}
	r2.w = asint(asfloat(r0.w) * i.color.w);
	r2.w = asint(asfloat(r2.w) * globalScalars.x);
	r11.w = (g_AlphaRef >= asfloat(r2.w)) ? -1 : 0;
	if (r11.w != 0) discard;
	r3.xyz = asint(asfloat(r3.www) * asfloat(r3.xyz));
	r3.xyz = r2.xxx & r3.xyz;
	r5.xyz = r5.xyz * r5.www + asfloat(r3.xyz);
	r3.xyz = (r2.yyy != 0) ? asint(r5.xyz) : r3.xyz;
	r5.xyz = asfloat(r6.xyz) * asfloat(r6.www) + asfloat(r3.xyz);
	r3.xyz = (r4.xxx != 0) ? asint(r5.xyz) : r3.xyz;
	r5.xyz = asfloat(r7.xyz) * asfloat(r7.www) + asfloat(r3.xyz);
	r3.xyz = (r4.yyy != 0) ? asint(r5.xyz) : r3.xyz;
	r5.xyz = r9.xyz * r9.www + asfloat(r3.xyz);
	r3.xyz = (r4.zzz != 0) ? asint(r5.xyz) : r3.xyz;
	r4.xyz = asint(asfloat(r8.xyz) * asfloat(r8.www) + asfloat(r3.xyz));
	r3.xyz = (r4.www != 0) ? r4.xyz : r3.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r3.xyz));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r3.xyz;
	r3.xyz = asint(asfloat(r10.xyz) * asfloat(r10.www) + asfloat(r1.xyz));
	r1.xyz = (r0.yyy != 0) ? r3.xyz : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xyz = asint(r12.xyz * reflectivePower);
	r1.w = asint(saturate(globalScalars.w));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r1.w = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r1.www) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r11.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(asfloat(r2.z) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.x = asint(sqrt(asfloat(r0.x)));
	o.sv_target2.y = sqrt(asfloat(r0.x));
	o.sv_target2.z = i.color.x * gAmbientOcclusionEffect.w;
	r0.xyw = asint(saturate(asfloat(r1.xyz) * float3(0.0625, 0.0625, 0.0625)));
	o.sv_target3.xyz = sqrt(asfloat(r0.xyw));
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	r0.x = asint(dot(abs(asfloat(r0.xy)), float2(1000, 1000)));
	r0.y = ((uint)r0.z < 255) ? -1 : 0;
	o.sv_target2.w = (r0.y != 0) ? 1000 : asfloat(r0.x);
	o.sv_target.w = asfloat(r2.w);
	o.sv_target1.w = asfloat(r2.w);
	o.sv_target2.x = specularColorFactor;
	o.sv_target3.w = asfloat(r2.w);
	o.sv_coverage = r0.z;

	return o;
}
