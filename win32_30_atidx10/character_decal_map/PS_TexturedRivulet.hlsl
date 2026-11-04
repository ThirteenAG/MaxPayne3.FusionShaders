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
	float4 r1;
	r0.xy = i.color.yz * 2 + -1;
	r0.xy = r0.xy * float2(-2.5, 2.5);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.zw = r1.yz * 2 + -1;
	r0.x = dot(r0.zw, r0.xy) + 0;
	r0.y = r0.x * r0.x;
	r0.x = saturate(r0.x * r0.y);
	r0.y = r1.w * i.color.w;
	r0.w = r0.x * r0.y;
	r0.xyz = float3(0.5, 0.05, 0.5);
	r1.y = 1 + -i.color.x;
	r1.x = -r1.y + r1.x;
	o = (r1.x >= 0) ? r0 : 0;

	return o;
}
