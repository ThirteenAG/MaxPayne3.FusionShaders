sampler2D DiffuseSampler : register(s0);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float3 r0;
	float4 r1;
	r0 = i.color.www * float3(0, 0, 1) + float3(1, 1, 0);
	r1.xy = i.texcoord.xy * 0.2 + float2(0.025, 0.8);
	r1 = tex2D(DiffuseSampler, r1.xy);
	o.yzw = r0.xyz * r1.yzw;
	o.x = saturate(r1.x + r1.x);

	return o;
}
