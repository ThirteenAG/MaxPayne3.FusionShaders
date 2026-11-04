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

SamplerState TextureGrassSampler : register(s1);
Texture2D TextureGrassSampler_tex : register(t1);

struct PS_IN
{
	noperspective centroid float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
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
	int4 r5;
	int2 r6;
	r0.xz = asint(ddx(i.texcoord1.ww));
	r0.yw = asint(ddx(i.texcoord2.ww));
	r1.xz = asint(ddy(i.texcoord1.ww));
	r1.yw = asint(ddy(i.texcoord2.ww));
	r2 = asint(asfloat(r1.zwzw) * float4(-0.375, -0.375, -0.125, -0.125));
	r2 = asint(asfloat(r0.zwzw) * float4(-0.125, -0.125, 0.375, 0.375) + asfloat(r2));
	r3.x = asint(i.texcoord1.w);
	r3.y = asint(i.texcoord2.w);
	r2 = asint(asfloat(r2) + asfloat(r3.xyxy));
	r4 = asint(TextureGrassSampler_tex.Sample(TextureGrassSampler, asfloat(r2.xy)));
	r2.x = asint(asfloat(r4.w) + -0.5);
	r2.x = (asfloat(r2.x) >= 0) ? -1 : 0;
	r5.x = 1;
	r5.y = r4.w;
	r3.zw = r2.xx & r5.xy;
	r5 = asint(TextureGrassSampler_tex.Sample(TextureGrassSampler, asfloat(r2.zw)));
	r2.y = asint(asfloat(r5.w) + -0.5);
	r2.y = (asfloat(r2.y) >= 0) ? -1 : 0;
	r6.x = (r2.x != 0) ? 3 : 2;
	r6.y = asint(asfloat(r3.w) + asfloat(r5.w));
	r2.zw = (r2.yy != 0) ? r6.xy : r3.zw;
	r1 = asint(asfloat(r1) * float4(0.125, 0.125, 0.375, 0.375));
	r0 = asint(asfloat(r0) * float4(-0.375, -0.375, 0.125, 0.125) + asfloat(r1));
	r0 = asint(asfloat(r0) + asfloat(r3.xyxy));
	r1 = asint(TextureGrassSampler_tex.Sample(TextureGrassSampler, asfloat(r0.xy)));
	r0.x = asint(asfloat(r1.w) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r3.x = r2.z + 4;
	r3.y = asint(asfloat(r1.w) + asfloat(r2.w));
	r2.zw = (r0.xx != 0) ? r3.xy : r2.zw;
	r3 = asint(TextureGrassSampler_tex.Sample(TextureGrassSampler, asfloat(r0.zw)));
	r0.y = asint(asfloat(r3.w) + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r6.x = r2.z + 8;
	r6.y = asint(asfloat(r2.w) + asfloat(r3.w));
	r0.zw = (r0.yy != 0) ? r6.xy : r2.zw;
	r2.z = asint(asfloat(r0.w) * i.texcoord.w);
	r2.w = (0.125490203 >= asfloat(r2.z)) ? -1 : 0;
	if (r2.w != 0) discard;
	r4.xyz = asint(asfloat(r4.www) * asfloat(r4.xyz));
	r4.xyz = r2.xxx & r4.xyz;
	r5.xyz = asint(asfloat(r5.xyz) * asfloat(r5.www) + asfloat(r4.xyz));
	r2.xyw = (r2.yyy != 0) ? r5.xyz : r4.xyz;
	r1.xyz = asint(asfloat(r1.xyz) * asfloat(r1.www) + asfloat(r2.xyw));
	r1.xyz = (r0.xxx != 0) ? r1.xyz : r2.xyw;
	r2.xyw = asint(asfloat(r3.xyz) * asfloat(r3.www) + asfloat(r1.xyz));
	r1.xyz = (r0.yyy != 0) ? r2.xyw : r1.xyz;
	r0.xyw = asint(asfloat(r1.xyz) / asfloat(r0.www));
	r1.xyz = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r2.xyw = asint(asfloat(r0.xyw) * i.texcoord.xyz);
	r0.xyw = asint(-(asfloat(r0.xyw)) * i.texcoord.xyz + i.texcoord3.xyz);
	r0.xyw = asint(i.texcoord3.www * asfloat(r0.xyw) + asfloat(r2.xyw));
	r1.w = asint(saturate(gAmbientOcclusionEffect.y + -1));
	o.sv_target.xyz = asfloat(r1.www) * globalScalars2.zzz + asfloat(r0.xyw);
	o.sv_target1.xyz = asfloat(r1.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.sv_target2.z = gAmbientOcclusionEffect.w * gAmbientOcclusionEffect.y;
	o.sv_target3.w = asfloat(r2.z) * globalScalars.x;
	r0.xy = asint(frac(i.sv_position.xy));
	r0.xy = asint(asfloat(r0.xy) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xy)), float2(1000, 1000));
	o.sv_target.w = asfloat(r2.z);
	o.sv_target1.w = asfloat(r2.z);
	o.sv_target2.xy = float2(0, 0.25);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_coverage = r0.z;

	return o;
}
