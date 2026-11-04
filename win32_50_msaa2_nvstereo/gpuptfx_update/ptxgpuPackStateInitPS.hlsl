struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	o.sv_target = float4(0, 0, 0, -1);
	o.sv_target1 = float4(0, 0, 0, 0);

	return o;
}
