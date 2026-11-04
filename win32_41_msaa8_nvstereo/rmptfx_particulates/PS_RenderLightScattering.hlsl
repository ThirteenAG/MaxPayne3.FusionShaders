cbuffer CacheHybrid : register(b1)
{
	float HybridAdd : packoffset(c0);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = HybridAdd;

	return o;
}
