SamplerState BaseSampler : register(s3);
Texture2D BaseSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0.xyz = BaseSampler_tex.Sample(BaseSampler, i.texcoord.xy).xyz;
	r0.xyz = r0.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	o.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	o.w = 1;

	return o;
}
