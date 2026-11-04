struct VS_IN
{
	float3 position : POSITION;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.sv_position.xyz = i.position.xyz;
	o.sv_position.w = 1;
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord.zw = float2(0, 0);

	return o;
}
