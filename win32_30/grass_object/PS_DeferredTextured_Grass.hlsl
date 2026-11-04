sampler2D DiffuseSampler : register(s0);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
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
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.w = saturate(dot(r0.ww, i.texcoord6.ww) + 0);
	o.color.xyz = r0.xyz;
	o.color1 = float4(1, 1, 1, 0) * i.texcoord1.xyzx;
	o.color2 = float4(1, 1, 1, 0) * i.texcoord6.xyzx;
	o.color3 = 0;

	return o;
}
