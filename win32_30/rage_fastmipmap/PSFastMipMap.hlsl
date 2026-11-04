sampler2D BaseSampler : register(s3);
float4 TexelSize : register(c38);

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(float2 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.x = 0.5;
	r1.z = TexelSize.x * -r0.x + texcoord.x;
	r1.xyw = TexelSize.xyy * r0.xxx + texcoord.xyy;
	r2 = tex2D(BaseSampler, r1.zw);
	r1 = tex2D(BaseSampler, r1.xy);
	r1 = r2 + r1;
	r2.x = TexelSize.x * r0.x + texcoord.x;
	r2.yzw = TexelSize.yxy * -r0.xxx + texcoord.yxy;
	r0 = tex2D(BaseSampler, r2.xy);
	r2 = tex2D(BaseSampler, r2.zw);
	r0 = r0 + r1;
	r0 = r2 + r0;
	r0 = r0 * 0.25;
	o.color = r0;
	o.color1 = r0;
	o.color2 = r0;
	o.color3 = r0;

	return o;
}
