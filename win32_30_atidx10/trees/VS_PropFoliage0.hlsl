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

	float2 r0;
	r0 = gWorldViewProj[1].zw * i.position.yy;
	r0 = i.position.xx * gWorldViewProj[0].zw + r0.xy;
	r0 = i.position.zz * gWorldViewProj[2].zw + r0.xy;
	o.position.zw = r0.xy + gWorldViewProj[3].zw;
	o.position.xy = 0;
	o.texcoord = i.texcoord.xy;

	return o;
}
