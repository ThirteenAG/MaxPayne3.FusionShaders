sampler2D DiffuseSampler : register(s0);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0.xy = frac(i.texcoord.xy);
	r0.xy = r0.xy * 0.125 + i.color.xy;
	r0 = tex2D(DiffuseSampler, r0.xy);
	o.z = r0.w * r0.x;
	o.w = r0.w * i.color.w;
	o.xy = r0.xy * float2(2, 1);

	return o;
}
