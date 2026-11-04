sampler2D LaserSampler : register(s1);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.xy = 5 * i.texcoord.xy;
	r0 = tex2D(LaserSampler, r0.xy);
	r0.x = r0.z + -1;
	r0.y = 0.5 * i.texcoord2.w;
	r0.x = r0.y * r0.x + 1;
	r1 = tex2D(LaserSampler, i.texcoord1.xy);
	r0.y = dot(r1.xyz, i.color.xyz);
	r0.y = r0.y * r0.y;
	r0.x = r0.x * r0.y;
	r0.y = dot(i.texcoord2.xyz, r0.xxx);
	o.w = r0.x;
	o.xyz = r0.yyy * 0.5 + i.texcoord2.xyz;

	return o;
}
