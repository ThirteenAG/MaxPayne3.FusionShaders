struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	o.sv_position.xyz = position.xyz * float3(2, 2, 1) + float3(-1, -1, 0);
	o.sv_position.w = 1;
	o.texcoord.xy = position.xy * float2(1, -1) + float2(0, 1);
	o.texcoord.zw = float2(0, 1);

	return o;
}
