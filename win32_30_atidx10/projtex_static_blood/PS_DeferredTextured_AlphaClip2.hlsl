sampler2D DiffuseSampler : register(s0);
float HardAlphaBlend : register(c203);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

struct PS_OUT
{
	half4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	r0.x = -1 + i.texcoord7.y;
	r0.x = i.texcoord7.x * r0.x + 1;
	r0.y = saturate(1 + -i.texcoord7.x);
	r0.x = -r0.y + r0.x;
	r0.x = 1 / r0.x;
	r0.zw = saturate(i.texcoord.xy);
	r1 = tex2D(DiffuseSampler, r0.zw);
	r0.z = r1.w * globalScalars.x + -r0.y;
	r0.x = saturate(r0.x * r0.z);
	r0.y = -r0.x + r0.y;
	r1 = (r0.y >= 0) ? -1 : -0;
	clip(r1);
	r0.y = r0.x * i.color.w + -0.5019608;
	r0.x = r0.x * i.color.w;
	r0.y = r0.y * 20.078741 + -r0.x;
	r0.x = HardAlphaBlend.x * r0.y + r0.x;
	o.color.w = saturate(r0.x + 0.003921569);
	r0.x = -r0.x + 0.003921569;
	r0 = (r0.x >= 0) ? -1 : -0;
	clip(r0);
	o.color.xyz = 0;
	o.color1 = 0;
	o.color2 = 0;
	o.color3 = 0;

	return o;
}
