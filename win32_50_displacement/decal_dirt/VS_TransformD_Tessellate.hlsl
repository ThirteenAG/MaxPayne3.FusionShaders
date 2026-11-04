cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float3 r0;
	o.texcoord8.xyz = i.position.xyz;
	o.texcoord8.w = 1;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;
	r0 = i.position.yyy * gWorld[1].xyz;
	r0 = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0 = i.position.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord6.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord6.w = 1;

	return o;
}
