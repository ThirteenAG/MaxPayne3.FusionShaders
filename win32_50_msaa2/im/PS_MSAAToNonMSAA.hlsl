Texture2DMS<float4> RenderPointMapMSAA : register(t5);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float3 dimensions0;
	RenderPointMapMSAA.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r1 = RenderPointMapMSAA.Load(r0.xy, 0);
	r0 = asint(RenderPointMapMSAA.Load(r0.xy, 1));
	r0 = asint(asfloat(r0) + r1);
	o = asfloat(r0) * float4(0.5, 0.5, 0.5, 0.5);

	return o;
}
