struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	o.sv_position.xy = i.position.xy;
	o.sv_position.zw = float2(0, 1);
	o.texcoord = i.position.xy;
	o.texcoord1 = i.texcoord.xy;
	o.texcoord2.xyz = i.normal.xyz;
	o.texcoord2.w = i.position.z;
	o.color = i.color.xyz;

	return o;
}
