struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float2 texcoord3 : TEXCOORD3;
};

VS_OUT main()
{
	VS_OUT o;

	o.sv_position = float4(0, 0, 0, 0);
	o.texcoord = float4(0, 0, 0, 0);
	o.texcoord1 = float4(0, 0, 0, 0);
	o.texcoord2 = float2(0, 0);
	o.texcoord3 = float2(0, 0);

	return o;
}
