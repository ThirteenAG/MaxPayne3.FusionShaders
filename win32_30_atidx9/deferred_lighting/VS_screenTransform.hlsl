float4 main(float4 position : POSITION) : POSITION
{
	float4 o;

	o = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);

	return o;
}
