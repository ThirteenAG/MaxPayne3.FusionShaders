Texture2DMS<float4> gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(gbufferTexture2.Load(r0.xy, i.sv_sampleindex).z);
	o.w = asfloat(r0.x);
	o.xyz = float3(0, 0, 0);

	return o;
}
