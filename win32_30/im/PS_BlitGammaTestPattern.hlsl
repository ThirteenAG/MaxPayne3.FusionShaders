sampler2D DiffuseSampler : register(s1);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float2 r0;
	float4 r1;
	r0.x = frac(-i.vpos.y);
	r0.x = r0.x + i.vpos.y;
	r0.y = r0.x * 0.25;
	r0.y = frac(abs(r0.y));
	r0.x = (r0.x >= 0) ? r0.y : -r0.y;
	r0 = r0.xx * 4 + float2(-1, -2);
	r0 = (-abs(r0.xy) >= 0) ? 1 : 0;
	r0.x = r0.y + r0.x;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	o.w = (-r0.x >= 0) ? 0 : r1.w;
	o.xyz = r1.xyz;

	return o;
}
