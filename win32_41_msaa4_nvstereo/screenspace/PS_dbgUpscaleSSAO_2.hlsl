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
};

SamplerState gDeferredLightSampler1 : register(s1);
Texture2D gDeferredLightSampler1_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float2 r0;
	r0 = float2(1, 1) / globalScreenSize.xy;
	r0 = r0.xy * float2(0.5, 0.5) + i.texcoord.xy;
	r0.x = gDeferredLightSampler1_tex.Sample(gDeferredLightSampler1, r0.xy).x;
	o.xyz = r0.xxx;
	o.w = 1;

	return o;
}
