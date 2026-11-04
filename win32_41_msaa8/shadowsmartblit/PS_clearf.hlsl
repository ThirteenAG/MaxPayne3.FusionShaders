cbuffer SmartBlit : register(b4)
{
	float4 clearcol : packoffset(c0);
};

float4 main() : SV_Target
{
	float4 o;

	o = clearcol;

	return o;
}
