struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float2 texcoord3 : TEXCOORD3;
};

VS_OUT main()
{
	VS_OUT o;

	o.position = 0;
	o.texcoord = 0;
	o.texcoord1 = 0;
	o.texcoord2 = 0;
	o.texcoord3 = 0;

	return o;
}
