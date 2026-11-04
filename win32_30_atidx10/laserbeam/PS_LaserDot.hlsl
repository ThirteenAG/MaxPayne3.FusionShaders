sampler2D LaserSampler : register(s1);

struct PS_IN
{
	float2 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(LaserSampler, i.texcoord2.xy);
	r0.y = dot(i.color.xyz, r0.xxx);
	o.w = r0.x;
	o.xyz = r0.yyy * 0.5 + i.color.xyz;

	return o;
}
