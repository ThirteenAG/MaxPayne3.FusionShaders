SamplerState deferredLightDownsampleDepthSampler : register(s12);
Texture2D deferredLightDownsampleDepthSampler_tex : register(t12);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int2 r0;
	r0.x = asint(deferredLightDownsampleDepthSampler_tex.Sample(deferredLightDownsampleDepthSampler, i.texcoord.xy).x);
	r0.y = (asfloat(r0.x) >= 237.5) ? -1 : 0;
	r0.x = asint(asfloat(r0.x) * 0.00400000019);
	r0.y = r0.y & 1065353216;
	o.xyz = asfloat(r0.xxx) * asfloat(r0.yyy);
	o.w = 1;

	return o;
}
