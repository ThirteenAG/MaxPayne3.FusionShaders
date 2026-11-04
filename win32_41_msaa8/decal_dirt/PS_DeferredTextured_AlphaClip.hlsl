cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
};

cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
};

cbuffer CacheMegaVariables : register(b4)
{
	float3 dirtDecalMask : packoffset(c0);
	float specularFactor : packoffset(c0.w);
	float specularColorFactor : packoffset(c1);
};

SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
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

	int3 r0;
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy).xyz);
	r0.x = asint(dot(asfloat(r0.xyz), dirtDecalMask.xyz));
	r0.x = asint(asfloat(r0.x) * i.color.w);
	r0.x = asint(asfloat(r0.x) * globalScalars.x);
	r0.y = (g_AlphaRef >= asfloat(r0.x)) ? -1 : 0;
	if (r0.y != 0) discard;
	r0.y = asint(max(specularFactor, 1));
	r0.y = asint(asfloat(r0.y) * 0.00510204071);
	r0.y = asint(min(asfloat(r0.y), 1));
	r0.y = asint(sqrt(asfloat(r0.y)));
	o.sv_target2.y = sqrt(asfloat(r0.y));
	o.sv_target.xyz = i.color.xyz;
	o.sv_target.w = asfloat(r0.x);
	o.sv_target1 = float4(0, 0, 0, 0);
	o.sv_target2.x = specularColorFactor;
	o.sv_target2.zw = float2(0, 0);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.x);
	o.sv_coverage = 255;

	return o;
}
