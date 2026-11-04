float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars2 : register(c36);

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(float3 texcoord : TEXCOORD)
{
	PS_OUT o;

	float4 r0;
	float3 r1;
	r0.xyw = float3(-1, 1, 0);
	r0.x = saturate(r0.x + gAmbientOcclusionEffect.y);
	o.color.xyz = r0.xxx * globalScalars2.zzz;
	o.color.w = 1;
	o.color1 = texcoord.xyzx * float4(0.5, 0.5, 0.5, 0) + float4(0.5, 0.5, 0.5, 1);
	r1 = float3(0, 1, 0.25);
	o.color2 = gAmbientOcclusionEffect.y * r1.xxyx + r1.xzxy;
	o.color3 = r0.wwwy * gStencil.x;

	return o;
}
