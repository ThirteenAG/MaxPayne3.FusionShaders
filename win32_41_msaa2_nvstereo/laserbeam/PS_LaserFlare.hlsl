SamplerState LaserSampler : register(s1);
Texture2D LaserSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	r0.xy = i.texcoord.xy * float2(5, 5);
	r0.x = LaserSampler_tex.Sample(LaserSampler, r0.xy).z;
	r0.x = r0.x + -1;
	r0.y = i.texcoord2.w * 0.5;
	r0.x = r0.y * r0.x + 1;
	r0.yzw = LaserSampler_tex.Sample(LaserSampler, i.texcoord1).xyz;
	r0.y = dot(r0.yzw, i.color.xyz);
	r0.y = r0.y * r0.y;
	r0.x = r0.x * r0.y;
	r0.y = dot(i.texcoord2.xyz, r0.xxx);
	o.w = r0.x;
	o.xyz = r0.yyy * float3(0.5, 0.5, 0.5) + i.texcoord2.xyz;

	return o;
}
