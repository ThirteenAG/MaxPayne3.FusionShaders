SamplerState DiffuseSampler : register(s1);
Texture2D DiffuseSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * i.texcoord1.xyz;
	r0.xyz = saturate(r0.xyz * float3(0.0625, 0.0625, 0.0625));
	o.xyz = sqrt(r0.xyz);
	o.w = 1;

	return o;
}
