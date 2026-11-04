cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer BoneVelocity : register(b4)
{
	float4 vBoneVelocitiesX[19] : packoffset(c0);
	float4 vBoneVelocitiesY[19] : packoffset(c19);
	float fAge : packoffset(c38);
	float fIntensity : packoffset(c38.y);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0 = position.y * gWorldViewProj[1];
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	o.sv_position = r0 + gWorldViewProj[3];
	o.texcoord.x = vBoneVelocitiesX[0].x * 101.099998 + 0.5;
	o.texcoord.y = vBoneVelocitiesY[0].x * -101.099998 + 0.5;
	o.texcoord.z = fAge;
	o.texcoord.w = 1;

	return o;
}
