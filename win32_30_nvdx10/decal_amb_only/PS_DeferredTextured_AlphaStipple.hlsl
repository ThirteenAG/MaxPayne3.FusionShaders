sampler2D DiffuseSampler : register(s0);
float3 ambientDecalMask : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	r0.xy = 0.5 * i.vpos.xy;
	r0.xy = frac(abs(r0.xy));
	r0.xy = (i.vpos.xy >= 0) ? r0.xy : -r0.xy;
	r0.xy = r0.xy + r0.xy;
	r0.zw = frac(r0.xy);
	r0.xy = -r0.zw + r0.xy;
	r0.x = r0.y * 2 + r0.x;
	r0 = r0.x + float4(-0, -1, -2, -3);
	r0 = (-abs(r0) >= 0) ? 1 : 0;
	r0.x = dot(stipplePattern, r0);
	r0 = (r0.x >= 0) ? -1 : -0;
	clip(r0);
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r0.x = dot(r0.xyz, ambientDecalMask.xyz);
	r0.x = saturate(-r0.x + 1);
	r0.x = r0.w * r0.x;
	r0.x = r0.x * globalScalars.x;
	o.color2.w = r0.x * gAmbientOcclusionEffect.x;
	o.color2.xyz = 0;
	o.color = 0;
	o.color1 = 0;
	o.color3 = 0;

	return o;
}
