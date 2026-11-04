float4 _fakedGrassNormal : register(c91);

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	o.position = position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord = _fakedGrassNormal.xyz;

	return o;
}
