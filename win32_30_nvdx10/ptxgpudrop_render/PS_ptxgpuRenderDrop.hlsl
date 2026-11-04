sampler2D DiffuseSampler : register(s4);
sampler2D DiffuseTexSampler : register(s3);

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
	r0.xy = float2(10, 0) + i.texcoord.xy;
	r0 = tex2D(DiffuseTexSampler, r0.xy);
	r0 = r0 * i.color;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	o = (i.texcoord.x >= 0) ? r1 : r0;

	return o;
}
