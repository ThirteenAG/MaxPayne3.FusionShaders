struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
};

PS_OUT main()
{
	PS_OUT o;

	o.color = float4(0, 0, 0, -1);
	o.color1 = 0;

	return o;
}
