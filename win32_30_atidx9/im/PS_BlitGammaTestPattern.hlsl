float4 main(float2 vpos : VPOS) : COLOR
{
	float4 o;

	float r0;
	r0 = 0.5 * vpos.y;
	r0 = frac(abs(r0.x));
	r0 = (vpos.y >= 0) ? r0.x : -r0.x;
	o.xyz = r0.xxx + r0.xxx;
	o.w = 1;

	return o;
}
