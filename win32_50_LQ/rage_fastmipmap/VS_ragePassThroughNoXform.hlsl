struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.sv_position.xyz = i.position.xyz;
	o.sv_position.w = 1;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = i.texcoord1.xy;
	o.texcoord2 = float3(0, 0, -1);

	return o;
}
