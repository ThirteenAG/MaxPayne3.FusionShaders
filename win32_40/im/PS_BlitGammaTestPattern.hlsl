SamplerState DiffuseSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t1);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int2 r0;
	float4 r1;
	r0.x = asint(ceil(i.sv_position.y));
	r0.x = asint(asfloat(r0.x) * 0.25);
	r0.y = (asfloat(r0.x) >= -(asfloat(r0.x))) ? -1 : 0;
	r0.x = asint(frac(abs(asfloat(r0.x))));
	r0.x = (r0.y != 0) ? r0.x : asint(-(asfloat(r0.x)));
	r0 = (asfloat(r0.xx) == float2(0.25, 0.5)) ? -1 : 0;
	r0.x = r0.y | r0.x;
	r0.x = r0.x & 1065353216;
	r1 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	o.w = asfloat(r0.x) * r1.w;
	o.xyz = r1.xyz;

	return o;
}
