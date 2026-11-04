struct VS_IN
{
	float3 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.sv_position.xyz = i.position.xyz;
	o.sv_position.w = 1;
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = i.color.x;

	return o;
}
