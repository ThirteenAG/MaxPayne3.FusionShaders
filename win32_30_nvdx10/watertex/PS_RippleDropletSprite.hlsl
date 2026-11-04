struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float texcoord1 : TEXCOORD1;
};

half4 main(PS_IN i) : COLOR
{
	half4 o;

	float2 r0;
	float2 r1;
	r0 = i.texcoord.xy * 2 + -1;
	r0.x = dot(r0.xy, r0.xy) + 0;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = saturate(r0.x * 1.1 + -0.1);
	r0.x = -r0.x + 1;
	r0.y = i.texcoord1.x * 1.4999987 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r1.y = sin(r0.y);
	o = dot(r1.yy, r0.xx) + 0.5;

	return o;
}
