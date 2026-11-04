Texture2D gbufferTexture2 : register(t13);

float4 main(noperspective float4 sv_position : SV_Position) : SV_Target
{
	float4 o;

	int4 r0;
	r0.xy = (int2)sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTexture2.Load(r0.xyz).z);
	o.w = asfloat(r0.x);
	o.xyz = float3(0, 0, 0);

	return o;
}
