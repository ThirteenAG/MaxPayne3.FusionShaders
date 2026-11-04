cbuffer AlphaTest : register(b11)
{
	float g_AlphaRef : packoffset(c0);
};

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

	int r0;
	r0 = (g_AlphaRef >= 0) ? -1 : 0;
	if (r0.x != 0) discard;
	o.sv_target = float4(0, 0, 0, 0);
	o.sv_target1 = float4(0, 0, 0, 0);
	o.sv_target2 = float4(0, 0, 0, 0);
	o.sv_target3 = float4(0, 0, 0, 0);
	o.sv_coverage = 255;

	return o;
}
