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
	float4 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	r1 = r0.w * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o = r0 * r1;

	return o;
}
