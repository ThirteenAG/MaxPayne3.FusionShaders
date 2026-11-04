struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float2 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	o = float4(0, 0, 0, 0);

	return o;
}
