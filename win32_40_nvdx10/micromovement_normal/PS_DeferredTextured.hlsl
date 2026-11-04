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

	float4 r0;
	int4 r1;
	float3 r2;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r0.w = r0.w * globalScalars.x;
	r1.x = asint(saturate(r0.w));
	r1.x = asint(asfloat(r1.x) * 3.99600005);
	r1.y = asint(frac(asfloat(r1.x)));
	r1.y = asint(asfloat(r1.y) * 4);
	r2.xy = floor(asfloat(r1.yx));
	r1.xy = asint(i.sv_position.xy * float2(0.125, 0.125));
	r1.zw = (asfloat(r1.xy) >= -(asfloat(r1.xy))) ? -1 : 0;
	r1.xy = asint(frac(abs(asfloat(r1.xy))));
	r1.xy = (r1.zw != 0) ? r1.xy : asint(-(asfloat(r1.xy)));
	r1.xy = asint(asfloat(r1.xy) * float2(0.25, 0.25));
	r1.xy = asint(r2.xy * float2(0.25, 0.25) + asfloat(r1.xy));
	r1 = asint(gStippleAlphaTexture_tex.Sample(gStippleAlphaTexture, asfloat(r1.xy)));
	r1.x = (0 >= asfloat(r1.y)) ? -1 : 0;
	if (r1.x != 0) discard;
	r1.x = asint(dot(i.texcoord1.xyz, i.texcoord1.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r1.y = asint(dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986)));
	r2 = r0.xyz + -(asfloat(r1.yyy));
	r1.yzw = asint(r2.xyz * float3(0.0500000007, 0.0500000007, 0.0500000007) + asfloat(r1.yyy));
	r2.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r2.y = -(r2.x) + 1;
	r1.yzw = asint(asfloat(r1.yzw) * r2.xxx);
	r0.xyz = r0.xyz * r2.yyy + asfloat(r1.yzw);
	r1.y = asint(saturate(i.color.x + -1));
	o.sv_target.xyz = asfloat(r1.yyy) * globalScalars2.zzz + r0.xyz;
	r0.xyz = i.texcoord1.xyz * asfloat(r1.xxx) + float3(1, 1, 1);
	o.sv_target1.xyz = r0.xyz * float3(0.5, 0.5, 0.5);
	r0.x = 0.001953125 * specularFactor;
	o.sv_target2.y = sqrt(r0.x);
	o.sv_target.w = r0.w;
	o.sv_target1.w = r0.w;
	o.sv_target2.x = 0.5 * specularColorFactor;
	o.sv_target2.z = i.color.x;
	o.sv_target2.w = r0.w;
	o.sv_target3.x = gStencil.x;
	o.sv_target3.yzw = float3(0, 0, 0);

	return o;
}
