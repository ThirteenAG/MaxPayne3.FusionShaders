Texture2D<float> depthSourceTexture : register(t13);

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float sv_depth : SV_Depth;
};

PS_OUT main(noperspective float4 sv_position : SV_Position)
{
	PS_OUT o;

	int4 r0;
	o.sv_target = float4(0, 0, 0, 1);
	r0.xy = (int2)sv_position.xy;
	r0.zw = int2(0, 0);
	r0.x = asint(depthSourceTexture.Load(r0.xyz).x);
	o.sv_depth = asfloat(r0.x);

	return o;
}
