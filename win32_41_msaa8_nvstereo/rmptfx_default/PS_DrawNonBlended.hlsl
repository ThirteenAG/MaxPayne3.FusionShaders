cbuffer Hybrid : register(b2)
{
	float HybridAdd : packoffset(c0);
	float gBiasToCamera : packoffset(c0.y);
};

SamplerState DiffuseTexSampler : register(s0);
Texture2D DiffuseTexSampler_tex : register(t0);

struct PS_IN
{
	float4 color : COLOR;
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int2 r0;
	float4 r1;
	float4 r2;
	r0.x = (0 != HybridAdd) ? -1 : 0;
	r0.y = asint(-(i.texcoord3.x) + 1);
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	r2.w = asfloat(r0.y) * r1.w;
	r2.xyz = r1.www * r1.xyz;
	o = (r0.x != 0) ? r2 : r1;

	return o;
}
