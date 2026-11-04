cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_ptx : register(b3)
{
	float4 gForcedColor : packoffset(c0);
	float4 gAspectRatio : packoffset(c1);
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

cbuffer ParticleRainDrop : register(b1)
{
	float gNormalArc : packoffset(c0);
	float gLightIntensityClamp : packoffset(c0.y);
	float gDiffuse : packoffset(c0.z);
	float gAmbientAmount : packoffset(c0.w);
	float gSuperAlpha : packoffset(c1);
	float gBlurAmount : packoffset(c1.y);
	float gRefraction : packoffset(c1.z);
	float gNormalHeight : packoffset(c1.w);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float3 r1;
	float3 r2;
	float3 r3;
	o.sv_position.w = 1;
	r0.y = asint(globalScreenSize.x / globalScreenSize.y);
	r1.x = sin(i.normal.z);
	r2.x = cos(i.normal.z);
	r1.xy = r1.xx * i.normal.yx;
	r3.x = i.normal.x * r2.x + -(r1.x);
	r3.y = i.normal.y * r2.x + r1.y;
	r3.z = 0;
	r0.xz = int2(1065353216, 1065353216);
	r1.xy = i.position.xy;
	r1.z = 0;
	r2 = r3.xyz * asfloat(r0.xyz) + r1.xyz;
	r0.xyz = asint(asfloat(r0.xyz) * r3.xyz);
	r0.w = (i.normal.w == 1) ? -1 : 0;
	r1 = (r0.www != 0) ? r2.xyz : r1.xyz;
	o.sv_position.xyz = r1.xyz;
	o.texcoord3.xy = r1.xy;
	r0.xyz = (r0.www != 0) ? r0.xyz : asint(i.position.xyz);
	o.texcoord3.z = asfloat(r0.w & asint(i.normal.z));
	r0.xy = asint(asfloat(r0.xy) / gAspectRatio.xy);
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y));
	r0.x = asint(saturate(asfloat(r0.x) * -0.5 + 0.5));
	r0.yzw = asint(-(gLightAmbient0.xyz) + gLightAmbient1.xyz);
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw) + gLightAmbient0.xyz);
	r0.xyz = asint(asfloat(r0.xyz) * gAmbientOcclusionEffect.yyy);
	r0.xyz = asint(asfloat(r0.xyz) * gAmbientAmount);
	r0.xyz = asint(asfloat(r0.xyz) / gAmbientOcclusionEffect.yyy);
	r0.xyz = asint(asfloat(r0.xyz) * i.color.xyz);
	r0.xyz = asint(max(asfloat(r0.xyz), float3(0, 0, 0)));
	o.texcoord.xyz = asfloat(r0.xyz) + i.color.xyz;
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r0 = asint(i.position.y * gWorldView[1]);
	r0 = asint(i.position.x * gWorldView[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldView[2] + asfloat(r0));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord8.w = i.normal.w * globalScalars4.x;
	o.texcoord8.xyz = i.normal.xyz;
	o.texcoord1 = i.texcoord;
	o.texcoord2 = i.texcoord1;
	o.texcoord3.w = i.texcoord2.y;
	r0.xyz = asint(i.position.xyz + -(gViewInverse[3].xyz));
	r0.w = asint(asfloat(r0.z) * globalFogParams.x);
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * globalFogParams.z);
	r0.y = asint(asfloat(r0.w) * -1.44269502);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(asfloat(r0.y) / asfloat(r0.w));
	r0.z = (0.0000999999975 < abs(asfloat(r0.w))) ? -1 : 0;
	r0.y = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = (r0.z != 0) ? r0.y : r0.x;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;
	o.texcoord5 = i.texcoord3;

	return o;
}
