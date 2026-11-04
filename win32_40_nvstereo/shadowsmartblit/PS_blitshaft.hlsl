SamplerState SmartBlitSampler : register(s1);
Texture2D SmartBlitSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	int4 r2;
	r0.xyz = int3(-964689920, 1182793728, 0);
	while (true) {
		r0.w = (r0.z >= 8) ? -1 : 0;
		if (r0.w != 0) break;
		r1.x = (float)r0.z;
		r1.zw = asfloat(r0.xy);
		r0.w = 0;
		while (true) {
			r2.x = (r0.w >= 8) ? -1 : 0;
			if (r2.x != 0) break;
			r1.y = (float)r0.w;
			r2.xy = asint(r1.xy * float2(0.001953125, 0.001953125) + i.texcoord.xy);
			r2 = asint(SmartBlitSampler_tex.SampleLevel(SmartBlitSampler, asfloat(r2.xy), 0));
			r1.z = max(r1.z, asfloat(r2.y));
			r1.w = min(r1.w, asfloat(r2.y));
			r0.w = r0.w + 1;
		}
		r0.xy = asint(r1.zw);
		r0.z = r0.z + 1;
	}
	r0.z = (asfloat(r0.x) == asfloat(r0.y)) ? -1 : 0;
	o.z = asfloat(r0.z & 1065353216);
	o.w = 1;
	o.xy = asfloat(r0.xy);

	return o;
}
