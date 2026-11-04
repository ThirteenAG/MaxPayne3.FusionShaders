sampler2D DiffuseSampler : register(s0);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);

struct PS_IN
{
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
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
	r1.x = -r0.w + 0.3529412;
	r1 = (r1.x >= 0) ? -1 : -0;
	clip(r1);
	o.color.xyz = r0.xyz * i.texcoord.zzz;
	o.color.w = r0.w * globalScalars.x;
	o.color1 = i.texcoord1.xyzx * float4(0.5, 0.5, 0.5, 0) + float4(0.5, 0.5, 0.5, 0);
	r0.yzw = float3(-1, -0, -0.5);
	o.color2 = gAmbientOcclusionEffect.y * -r0.zzwz + -r0.zwzz;
	o.color3 = -r0.zzzy * gStencil.x;

	return o;
}
