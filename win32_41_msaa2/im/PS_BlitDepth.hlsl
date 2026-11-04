Texture2DMS<float> DepthPointMap : register(t4);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
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
	o.sv_target = float4(1, 0, 0, 1);
	float3 dimensions0;
	DepthPointMap.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(DepthPointMap.Load(r0.xy, i.sv_sampleindex).x);
	o.sv_depth = asfloat(r0.x);

	return o;
}
