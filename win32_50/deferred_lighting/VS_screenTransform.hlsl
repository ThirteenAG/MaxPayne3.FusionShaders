float4 main(float3 position : POSITION) : SV_Position
{
	float4 o;

	o.xy = position.xy * float2(2, 2) + float2(-1, -1);
	o.zw = float2(0, 1);

	return o;
}
