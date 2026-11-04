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

	float4 r0;
	float4 r1;
	int4 r2;
	r0.x = saturate(i.texcoord2.x);
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord.zw);
	r2 = asint(DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord.xy));
	r1 = r1 + -(asfloat(r2));
	r0 = r0.x * r1 + asfloat(r2);
	r0 = r0 * i.color;
	r1.x = -(i.texcoord3.x) + 1;
	r1.w = r0.w * r1.x;
	r1.xyz = r0.www * r0.xyz;
	r2.x = (0 != HybridAdd) ? -1 : 0;
	o = (r2.x != 0) ? r1 : r0;

	return o;
}
