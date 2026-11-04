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
	float r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyw = r0.xyw * i.color.xyw;
	o.z = r0.w * r0.x;
	r1 = 0.9999 + -i.color.z;
	r0.z = r0.z * i.color.z + -r1.x;
	r0.w = r0.w * i.color.w;
	o.xy = r0.xy;
	o.w = (r0.z >= 0) ? r0.w : 0;

	return o;
}
