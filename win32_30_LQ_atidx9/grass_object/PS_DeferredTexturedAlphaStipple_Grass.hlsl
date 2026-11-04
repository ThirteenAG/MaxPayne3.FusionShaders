sampler2D DiffuseSampler : register(s0);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
	float2 vpos : VPOS;
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
	float4 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = saturate(dot(r0.ww, i.texcoord6.ww) + 0);
	r1.xy = 0.5 * i.vpos.xy;
	r1.xy = frac(abs(r1.xy));
	r1.xy = (i.vpos.xy >= 0) ? r1.xy : -r1.xy;
	r1.xy = r1.xy + r1.xy;
	r1.zw = frac(r1.xy);
	r1.xy = -r1.zw + r1.xy;
	r1.x = r1.y * 2 + r1.x;
	r1 = r1.x + float4(-0, -1, -2, -3);
	r1 = (-abs(r1) >= 0) ? 1 : 0;
	r1.x = dot(stipplePattern, r1);
	r1.x = -r0.w + r1.x;
	r1 = (r1.x >= 0) ? -1 : -0;
	clip(r1);
	o.color.xyz = r0.xyz;
	o.color.w = r0.w;
	o.color1 = float4(1, 1, 1, 0) * i.texcoord1.xyzx;
	o.color2 = float4(1, 1, 1, 0) * i.texcoord6.xyzx;
	o.color3 = 0;

	return o;
}
