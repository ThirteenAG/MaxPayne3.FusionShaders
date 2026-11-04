cbuffer DebugDTQ : register(b4)
{
	float4 param0 : packoffset(c0);
	float4 param1 : packoffset(c1);
	float4 param2 : packoffset(c2);
	float4 param3 : packoffset(c3);
	float4 param4 : packoffset(c4);
	float4 param5 : packoffset(c5);
};

SamplerState samp : register(s0);
Texture2D samp_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = samp_tex.SampleLevel(samp, i.texcoord.xy, param5.x);
	r1.x = min(r0.y, r0.x);
	r1.x = min(r0.z, r1.x);
	r1.y = max(r0.y, r0.x);
	r1.y = max(r0.z, r1.y);
	r1.x = -(r1.x) + r1.y;
	r2 = -(r0) + r1.y;
	r0 = param5.y * r2 + r0;
	r1 = r1.x * param5.w + -(r0);
	r0 = param5.z * r1 + r0;
	r1.x = dot(r0, param0);
	r1.y = dot(r0, param1);
	r1.z = dot(r0, param2);
	r1.w = dot(r0, param3);
	r0 = r1 + param4;
	o = r0 * i.color;

	return o;
}
