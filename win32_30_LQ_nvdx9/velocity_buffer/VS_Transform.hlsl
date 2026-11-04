float fAge : register(c247);
row_major float4x4 gWorldViewProj : register(c8);
float4 vBoneVelocitiesX[19] : register(c209);
float4 vBoneVelocitiesY[19] : register(c228);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0 = gWorldViewProj[1] * position.y;
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	r0 = float4(101.1, 0, 0.5, 1);
	o.texcoord.xw = vBoneVelocitiesX[0].xx * r0.xy + r0.zw;
	r0.xy = float2(-101.1, 0.5);
	o.texcoord.y = vBoneVelocitiesY[0].x * r0.x + r0.y;
	o.texcoord.z = fAge.x;

	return o;
}
