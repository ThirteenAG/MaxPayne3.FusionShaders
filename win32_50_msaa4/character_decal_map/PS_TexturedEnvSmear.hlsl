SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float3 r0;
	r0.xy = frac(i.texcoord.xy);
	r0.xy = r0.xy * float2(0.125, 0.125) + i.color.xy;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, r0.xy).xyw;
	o.z = r0.z * r0.x;
	o.w = r0.z * i.color.w;
	o.xy = r0.xy * float2(2, 1);

	return o;
}
