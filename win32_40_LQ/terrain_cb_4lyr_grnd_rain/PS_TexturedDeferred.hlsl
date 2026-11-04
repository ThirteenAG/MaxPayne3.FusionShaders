cbuffer CacheTerrainCB : register(b1)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
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
	float4 gWaterGlobals : packoffset(c19);
};

cbuffer Wet : register(b4)
{
	float4 WetDarken : packoffset(c0);
};

SamplerState TextureSampler_layer0 : register(s0);
SamplerState BumpSampler_layer0 : register(s1);
SamplerState TextureSampler_layer1 : register(s2);
SamplerState BumpSampler_layer1 : register(s3);
SamplerState TextureSampler_layer2 : register(s4);
SamplerState BumpSampler_layer2 : register(s5);
SamplerState TextureSampler_layer3 : register(s6);
SamplerState BumpSampler_layer3 : register(s7);
SamplerState PuddleMaskSampler : register(s8);
SamplerState WaterRainRippleNormalSampler : register(s14);
Texture2D TextureSampler_layer0_tex : register(t0);
Texture2D BumpSampler_layer0_tex : register(t1);
Texture2D TextureSampler_layer1_tex : register(t2);
Texture2D BumpSampler_layer1_tex : register(t3);
Texture2D TextureSampler_layer2_tex : register(t4);
Texture2D BumpSampler_layer2_tex : register(t5);
Texture2D TextureSampler_layer3_tex : register(t6);
Texture2D BumpSampler_layer3_tex : register(t7);
Texture2D PuddleMaskSampler_tex : register(t8);
Texture2D WaterRainRippleNormalSampler_tex : register(t14);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xyz = asint(-(i.color.xyz) + float3(1, 1, 1));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.w = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.xy = asint(asfloat(r0.xy) * i.color.yz);
	r0.z = asint(asfloat(r0.z) * asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * i.color.z);
	r1 = asint(TextureSampler_layer0_tex.SampleBias(TextureSampler_layer0, i.texcoord.xy, -1.29999995));
	r2 = TextureSampler_layer1_tex.SampleBias(TextureSampler_layer1, i.texcoord.xy, -1.29999995);
	r3 = TextureSampler_layer2_tex.SampleBias(TextureSampler_layer2, i.texcoord.xy, -1.29999995);
	r4 = TextureSampler_layer3_tex.SampleBias(TextureSampler_layer3, i.texcoord.xy, -1.29999995);
	r2.xyz = asfloat(r0.yyy) * r2.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r0.www) + r2.xyz);
	r1.xyz = asint(r3.xyz * asfloat(r0.zzz) + asfloat(r1.xyz));
	r1.xyz = asint(r4.xyz * asfloat(r0.xxx) + asfloat(r1.xyz));
	r2 = BumpSampler_layer0_tex.Sample(BumpSampler_layer0, i.texcoord.xy);
	r1.w = asint(-(r2.w) + 1);
	r1.w = (asfloat(r1.w) < r2.x) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.xz = -(r2.wy) + r2.xy;
	r2.xy = asfloat(r1.ww) * r2.xz + r2.wy;
	r3 = BumpSampler_layer1_tex.Sample(BumpSampler_layer1, i.texcoord.xy);
	r1.w = asint(-(r3.w) + 1);
	r1.w = (asfloat(r1.w) < r3.x) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.zw = -(r3.wy) + r3.xy;
	r2.zw = asfloat(r1.ww) * r2.zw + r3.wy;
	r3 = BumpSampler_layer2_tex.Sample(BumpSampler_layer2, i.texcoord.xy);
	r1.w = asint(-(r3.w) + 1);
	r1.w = (asfloat(r1.w) < r3.x) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r3.xz = -(r3.wy) + r3.xy;
	r3.xy = asfloat(r1.ww) * r3.xz + r3.wy;
	r4 = BumpSampler_layer3_tex.Sample(BumpSampler_layer3, i.texcoord.xy);
	r1.w = asint(-(r4.w) + 1);
	r1.w = (asfloat(r1.w) < r4.x) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r3.zw = -(r4.wy) + r4.xy;
	r3.zw = asfloat(r1.ww) * r3.zw + r4.wy;
	r2.zw = asfloat(r0.yy) * r2.zw;
	r0.yw = asint(r2.xy * asfloat(r0.ww) + r2.zw);
	r0.yz = asint(r3.xy * asfloat(r0.zz) + asfloat(r0.yw));
	r0.xy = asint(r3.zw * asfloat(r0.xx) + asfloat(r0.yz));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	r0.xy = asint(asfloat(r0.xy) * bumpiness);
	r0.xy = asint(asfloat(r0.xy) + asfloat(r0.xy));
	r0.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(max(asfloat(r0.z), 0));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r2.xyz = asfloat(r0.xxx) * i.texcoord4.xyz;
	r0.xzw = asint(i.texcoord2.xyz * asfloat(r0.zzz) + r2.xyz);
	r0.xyz = asint(asfloat(r0.yyy) * i.texcoord5.xyz + asfloat(r0.xzw));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r1.xyz = asint(asfloat(r1.xyz) * i.texcoord3.xyz);
	r0.w = (0 < i.texcoord3.w) ? -1 : 0;
	r2.xy = i.texcoord1.xy * WetDarken.ww;
	r2 = PuddleMaskSampler_tex.Sample(PuddleMaskSampler, r2.xy);
	r2.yz = i.texcoord1.xy * float2(0.300000012, 0.300000012);
	r3 = WaterRainRippleNormalSampler_tex.Sample(WaterRainRippleNormalSampler, r2.yz);
	if (r0.w != 0) {
		r0.w = asint(r2.x + gWaterGlobals.y);
		r0.w = asint(saturate(asfloat(r0.w) + -(i.texcoord3.w)));
		r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
		if (r1.w != 0) {
			r1.xyz = asint(asfloat(r1.xyz) * WetDarken.xyz);
			r2.xy = -(float2(specularFactor, specularColorFactor)) + gWaterGlobals.zw;
			r2.xy = asfloat(r0.ww) * r2.xy + float2(specularFactor, specularColorFactor);
			r3.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
			r3.xyz = r3.xyz * i.texcoord2.zzz;
			r4.xyz = r3.xxx * i.texcoord4.xyz;
			r3.xzw = i.texcoord2.xyz * r3.zzz + r4.xyz;
			r3.xyz = i.texcoord5.xyz * r3.yyy + r3.xzw;
			r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
			r1.w = asint(dot(r3.xyz, r3.xyz));
			r1.w = asint(rsqrt(asfloat(r1.w)));
			r3.xyz = r3.xyz * asfloat(r1.www) + -(asfloat(r0.xyz));
			r3.xyz = asfloat(r0.www) * r3.xyz + asfloat(r0.xyz);
			r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
			r0.w = asint(dot(r3.xyz, r3.xyz));
			r0.w = asint(rsqrt(asfloat(r0.w)));
			r0.xyz = asint(asfloat(r0.www) * r3.xyz);
		} else {
			r0.w = asint(saturate(gWaterGlobals.y));
			r3.xyz = asfloat(r1.xyz) * WetDarken.xyz + -(asfloat(r1.xyz));
			r1.xyz = asint(asfloat(r0.www) * r3.xyz + asfloat(r1.xyz));
			r2.xy = float2(specularFactor, specularColorFactor);
		}
	} else {
		r2.xy = float2(specularFactor, specularColorFactor);
	}
	r0.w = asint(saturate(i.texcoord3.w + -1));
	o.sv_target.xyz = asfloat(r0.www) * globalScalars2.zzz + asfloat(r1.xyz);
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(saturate(r2.x * 0.00510204071));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r2.x = sqrt(asfloat(r0.x));
	r2.z = i.texcoord3.w * gAmbientOcclusionEffect.w;
	o.sv_target.w = 0;
	o.sv_target1.w = globalScalars.x;
	r2.w = globalScalars.x;
	o.sv_target2 = r2.yxzw;
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = globalScalars.x;

	return o;
}
