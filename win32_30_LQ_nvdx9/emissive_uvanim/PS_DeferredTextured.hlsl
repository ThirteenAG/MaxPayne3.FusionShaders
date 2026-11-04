sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 color : COLOR;
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
	float3 r2;
	r0.yw = float2(-1, -0);
	r0.x = saturate(r0.y + globalScalars.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r1 * colorize;
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2 = normalize(r1.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = globalScalars.z;
	o.color2.z = r0.z * gAmbientOcclusionEffect.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color3 = -r0.wwwy * gStencil.x;

	return o;
}
