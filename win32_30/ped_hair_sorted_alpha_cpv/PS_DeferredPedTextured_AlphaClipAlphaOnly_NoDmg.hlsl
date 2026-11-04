sampler2D DiffuseSampler : register(s0);
float HardAlphaBlend : register(c196);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.x = r0.w * i.texcoord2.w;
	r1 = -0.003921569;
	r0.y = r0.x * globalScalars.x + r1.x;
	r0.x = r0.x * globalScalars.x;
	r0.y = r0.y * 10.039371 + -r0.x;
	r0.x = HardAlphaBlend.x * r0.y + r0.x;
	o.color.w = saturate(r0.x + 0.007843138);
	r0.x = -r0.x + 0.003921569;
	r0 = (r0.x >= 0) ? -1 : -0;
	clip(r0);
	o.color.xyz = 0;
	o.color1 = 0;
	o.color2 = 0;
	o.color3 = 0;

	return o;
}
