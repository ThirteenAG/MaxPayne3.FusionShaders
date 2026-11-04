Texture2DMS<float4> gbufferTexture0 : register(t8);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	int4 r0;
	r0.xy = (int2)sv_position.xy;
	r0.zw = int2(0, 0);
	o = gbufferTexture0.Load(r0.xy, 0);

	return o;
}
