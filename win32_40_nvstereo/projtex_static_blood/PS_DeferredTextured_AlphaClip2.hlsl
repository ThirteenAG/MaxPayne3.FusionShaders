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
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
	float bumpiness : packoffset(c0.z);
	float reflectivePower : packoffset(c0.w);
	float fresnelRolloff : packoffset(c1);
	float HardAlphaBlend : packoffset(c1.y);
};

SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord2 : TEXCOORD2;
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
	r0.xy = asint(saturate(i.texcoord.xy));
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)));
	r0.x = asint(saturate(-(i.texcoord7.x) + 1));
	r0.y = asint(asfloat(r0.w) * globalScalars.x + -(asfloat(r0.x)));
	r0.z = asint(i.texcoord7.y + -1);
	r0.z = asint(i.texcoord7.x * asfloat(r0.z) + 1);
	r0.z = asint(-(asfloat(r0.x)) + asfloat(r0.z));
	r0.y = asint(saturate(asfloat(r0.y) / asfloat(r0.z)));
	r0.x = (asfloat(r0.x) >= asfloat(r0.y)) ? -1 : 0;
	if (r0.x != 0) discard;
	r0.x = asint(asfloat(r0.y) * i.color.w + -(g_AlphaRef));
	r0.z = asint(-(g_AlphaRef) + 1);
	r0.z = asint(asfloat(r0.z) * 0.100000001);
	r0.x = asint(asfloat(r0.x) / asfloat(r0.z));
	r0.x = asint(-(asfloat(r0.y)) * i.color.w + asfloat(r0.x));
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r0.x = asint(HardAlphaBlend * asfloat(r0.x) + asfloat(r0.y));
	r0.y = (0.00392156886 >= asfloat(r0.x)) ? -1 : 0;
	o.sv_target.w = saturate(asfloat(r0.x) + 0.00392156886);
	if (r0.y != 0) discard;
	o.sv_target.xyz = float3(0, 0, 0);
	o.sv_target1 = float4(0, 0, 0, 0);
	o.sv_target2 = float4(0, 0, 0, 0);
	o.sv_target3 = float4(0, 0, 0, 0);

	return o;
}
