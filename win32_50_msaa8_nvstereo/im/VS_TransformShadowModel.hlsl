cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

float4 main(float3 position : POSITION) : SV_Position
{
	float4 o;

	float4 r0;
	r0 = position.y * gWorldViewProj[1];
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	o = r0 + gWorldViewProj[3];

	return o;
}
