cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
};

Texture2DMS<float> DepthBufferTexture : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float3 dimensions0;
	DepthBufferTexture.GetDimensions(dimensions0.x, dimensions0.y, dimensions0.z);
	r0.xy = asint(dimensions0.xy);
	r0.xy = asint(asfloat(r0.xy) * i.texcoord.xy);
	r0.xy = (int2)asfloat(r0.xy);
	r0.zw = int2(0, 0);
	r0.x = asint(DepthBufferTexture.Load(r0.xy, 0).x);
	r0.x = asint(asfloat(r0.x) * gDirectionalColour.z + -(gDirectionalColour.w));
	r0.x = asint(1 / asfloat(r0.x));
	r0.x = asint(-(asfloat(r0.x)) + i.texcoord.z);
	r0.x = asint(asfloat(r0.x) + gDirectionalLight.w);
	r0.x = asint(gDirectionalLight.x * asfloat(r0.x) + -(gDirectionalLight.y));
	r0.y = asint(-(gDirectionalLight.y) + gDirectionalLight.z);
	r0.y = asint(1 / asfloat(r0.y));
	r0.x = asint(saturate(asfloat(r0.y) * asfloat(r0.x)));
	r0.y = asint(asfloat(r0.x) * -2 + 3);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.x));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y));
	o = asfloat(r0.x) * gDepthFxParams;

	return o;
}
