row_major float4x4 gWorldViewProj : register(c8);

float4 main(float4 position : POSITION) : POSITION
{
	float4 o;

	float4 r0;
	r0 = gWorldViewProj[1] * position.y;
	r0 = position.x * gWorldViewProj[0] + r0;
	r0 = position.z * gWorldViewProj[2] + r0;
	o = position.w * gWorldViewProj[3] + r0;

	return o;
}
