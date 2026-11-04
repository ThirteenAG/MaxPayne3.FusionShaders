Texture2DMS<float> DepthPointMap : register(t4);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
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
	float2 r1;
	o.sv_target = float4(1, 0, 0, 1);
	float3 dimensions0;
	DepthPointMap.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r1.x = DepthPointMap.Load(r0.xy, 0).x;
	r1.y = DepthPointMap.Load(r0.xy, 0, int2(-1, 0)).x;
	r1.x = min(r1.y, r1.x);
	r1.y = DepthPointMap.Load(r0.xy, 0, int2(1, 0)).x;
	r0.x = asint(DepthPointMap.Load(r0.xy, 0, int2(0, 1)).x);
	r0.x = asint(min(asfloat(r0.x), r1.y));
	o.sv_depth = min(asfloat(r0.x), r1.x);

	return o;
}
