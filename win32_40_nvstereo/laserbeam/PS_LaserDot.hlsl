SamplerState LaserSampler : register(s1);
Texture2D LaserSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0 = LaserSampler_tex.Sample(LaserSampler, i.texcoord2.xy);
	r0.y = dot(i.color.xyz, r0.xxx);
	o.w = r0.x;
	o.xyz = r0.yyy * float3(0.5, 0.5, 0.5) + i.color.xyz;

	return o;
}
