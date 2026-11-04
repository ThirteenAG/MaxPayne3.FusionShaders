row_major float4x4 gWorldInstanceMatrix : register(c68);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = gWorldInstanceMatrix[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorldInstanceMatrix[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldInstanceMatrix[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldInstanceMatrix[3].xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	o.texcoord = i.texcoord.xy;

	return o;
}
