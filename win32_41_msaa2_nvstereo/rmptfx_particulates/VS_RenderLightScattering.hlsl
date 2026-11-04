struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
};

VS_OUT main()
{
	VS_OUT o;

	o.sv_position = float4(0, 0, 0, 0);
	o.texcoord = float2(0, 0);
	o.texcoord2 = float3(0, 0, 0);

	return o;
}
