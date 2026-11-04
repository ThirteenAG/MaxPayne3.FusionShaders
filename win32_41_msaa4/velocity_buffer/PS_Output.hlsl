cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o.xyz = i.texcoord.xyz;
	o.w = globalScalars.x;

	return o;
}
