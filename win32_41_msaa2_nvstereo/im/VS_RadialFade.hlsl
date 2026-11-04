struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float2 position : POSITION)
{
	VS_OUT o;

	o.sv_position.xy = position.xy * float2(2, 2) + float2(-1, -1);
	o.sv_position.zw = float2(0, 1);
	o.texcoord.xy = position.xy;
	o.texcoord.zw = float2(0, 1);

	return o;
}
