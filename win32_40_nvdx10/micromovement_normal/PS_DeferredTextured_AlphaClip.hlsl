cbuffer _Globals : register(b0)
{
	float2 facetMask[4] : packoffset(c204);
	float specularFactor : packoffset(c208);
	float specularColorFactor : packoffset(c209);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalFogParams : packoffset(c3);
	float4 globalFogColor : packoffset(c4);
	float4 globalFogColorE : packoffset(c5);
	float4 globalFogColorN : packoffset(c6);
	float4 globalScreenSize : packoffset(c7);
	float4 gTAADayNightEffects : packoffset(c8);
	float4 ColorCorrectTop : packoffset(c9);
	float4 ColorCorrectBottom : packoffset(c10);
	float4 ColorShift : packoffset(c11);
	float4 deSatContrastGamma : packoffset(c12);
	float4 colorize : packoffset(c13);
	float4 globalUmScalars : packoffset(c14);
	float4 gStencil : packoffset(c15);
	float4 gAmbientOcclusionEffect : packoffset(c16);
};

SamplerState DiffuseSampler : register(s0);
SamplerState gStippleAlphaTexture : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D gStippleAlphaTexture_tex : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
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
	int2 r3;
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.w = asint(asfloat(r0.w) * i.color.w);
	r1.w = asint(asfloat(r0.w) * globalScalars.x);
	r0.w = asint(saturate(asfloat(r1.w)));
	r0.w = asint(asfloat(r0.w) * 3.99600005);
	r2.x = frac(asfloat(r0.w));
	r2.x = r2.x * 4;
	r2.x = floor(r2.x);
	r2.y = floor(asfloat(r0.w));
	r2.zw = i.sv_position.xy * float2(0.125, 0.125);
	r3 = (r2.zw >= -(r2.zw)) ? -1 : 0;
	r2.zw = frac(abs(r2.zw));
	r2.zw = (r3.xy != 0) ? r2.zw : -(r2.zw);
	r2.zw = r2.zw * float2(0.25, 0.25);
	r2.xy = r2.xy * float2(0.25, 0.25) + r2.zw;
	r2 = gStippleAlphaTexture_tex.Sample(gStippleAlphaTexture, r2.xy);
	r0.w = (0 >= r2.y) ? -1 : 0;
	if (r0.w != 0) discard;
	r0.w = asint(dot(i.texcoord1.xyz, i.texcoord1.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.x = dot(asfloat(r0.xyz), float3(0.212500006, 0.715399981, 0.0720999986));
	r2.yzw = asfloat(r0.xyz) + -(r2.xxx);
	r2.xyz = r2.yzw * float3(0.0500000007, 0.0500000007, 0.0500000007) + r2.xxx;
	r2.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r3.x = asint(-(r2.w) + 1);
	r2.xyz = r2.www * r2.xyz;
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r3.xxx) + r2.xyz);
	r2.x = saturate(i.color.x + -1);
	r1.xyz = asint(r2.xxx * globalScalars2.zzz + asfloat(r0.xyz));
	r0.xyz = asint(i.texcoord1.xyz * asfloat(r0.www) + float3(1, 1, 1));
	o.sv_target1.xyz = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5);
	r0.x = asint(0.001953125 * specularFactor);
	o.sv_target2.y = sqrt(asfloat(r0.x));
	r0 = r1;
	o.sv_target1.w = asfloat(r1.w);
	o.sv_target2.x = 0.5 * specularColorFactor;
	o.sv_target2.z = i.color.x;
	o.sv_target2.w = asfloat(r1.w);
	o.sv_target3.x = gStencil.x;
	o.sv_target3.yzw = float3(0, 0, 0);
	r1.x = (0.352941185 >= asfloat(r0.w)) ? -1 : 0;
	if (r1.x != 0) discard;
	o.sv_target = asfloat(r0);

	return o;
}
