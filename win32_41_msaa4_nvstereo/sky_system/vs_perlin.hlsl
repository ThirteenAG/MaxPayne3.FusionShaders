struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	o.sv_position.xy = position.xy * float2(2, 2) + float2(-1, -1);
	o.sv_position.zw = float2(0, 1);
	o.texcoord = position.xy * float2(1, -1) + float2(0, 1);

	return o;
}
