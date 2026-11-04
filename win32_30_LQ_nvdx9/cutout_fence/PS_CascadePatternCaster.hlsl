float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float2 r0;
	float4 r1;
	float r2;
	r0 = texcoord.yz * 15.915494 + 0.5;
	r0 = frac(r0.xy);
	r0 = r0.xy * 6.2831855 + -3.1415927;
	r1.y = sin(r0.x);
	r2.x = cos(r0.y);
	r0.x = r1.y + r2.x;
	r0.y = -r0.x + 0.5019608;
	r1 = (r0.y >= 0) ? -1 : -0;
	clip(r1);
	o.xyz = texcoord.xxx;
	o.w = r0.x;

	return o;
}
