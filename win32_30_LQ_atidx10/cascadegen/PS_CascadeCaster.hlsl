float4 main(float texcoord : TEXCOORD) : COLOR
{
	float4 o;

	o = texcoord.x * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);

	return o;
}
