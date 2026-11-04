cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
};

SamplerState DiffuseTexSampler : register(s0);
Texture2D DiffuseTexSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.x = i.texcoord2.y * globalScalars4.x;
	r1 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.xy);
	r1 = r1 * i.texcoord;
	r1.xyz = r0.xxx * r1.xyz;
	r1.w = saturate(r1.w);
	r0 = max(r1, float4(0, 0, 0, 0));
	o = min(r0, float4(32, 32, 32, 32));

	return o;
}
