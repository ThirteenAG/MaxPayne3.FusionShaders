float4 main(float4 position : POSITION) : POSITION
{
	float4 o;

	o = float4(1, 1, 1, 0) * position.xyzx;

	return o;
}
