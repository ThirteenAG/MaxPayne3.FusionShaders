sampler2D DiffuseSampler : register(s0);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
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

	float3 r0;
	float4 r1;
	r0.x = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
	o.color.w = r0.x;
	o.color1.xyz = i.texcoord2.xyz * 0.5 + 0.5;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.xyz = i.color.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.xz = float2(-1, -0);
	o.color3 = -r0.zzzx * gStencil.x;

	return o;
}
