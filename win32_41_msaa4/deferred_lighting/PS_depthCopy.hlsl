Texture2DMS<float> depthSourceTexture : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float sv_depth : SV_Depth;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	o.sv_target = float4(0, 0, 0, 1);
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(depthSourceTexture.Load(r0.xy, i.sv_sampleindex).x);
	o.sv_depth = asfloat(r0.x);

	return o;
}
