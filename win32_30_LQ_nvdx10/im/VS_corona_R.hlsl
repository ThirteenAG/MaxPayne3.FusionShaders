row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	r0.xyz = i.color.xyz;
	o.texcoord1.xyz = r0.xyz * i.texcoord.yyy;
	o.texcoord.x = i.texcoord.x;
	o.texcoord.y = i.color.w;
	o.texcoord1.w = 1;

	return o;
}
