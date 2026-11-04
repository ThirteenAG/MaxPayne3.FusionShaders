sampler2D DiffuseSampler : register(s0);
float HardAlphaBlend : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
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
	float r2;
	r0.x = i.vpos.y + i.vpos.x;
	r0.y = frac(r0.x);
	r0.z = (-r0.y >= 0) ? 0 : 1;
	r0.y = r0.x + -r0.y;
	r0.x = (r0.x >= 0) ? 0 : r0.z;
	r0.x = r0.x + r0.y;
	r0.yz = (r0.xx >= 0) ? float2(2, 0.5) : float2(-2, -0.5);
	r0.x = r0.z * r0.x;
	r0.x = frac(r0.x);
	r0.x = r0.x * r0.y;
	r0.y = frac(r0.x);
	r0.z = (-r0.y >= 0) ? 0 : 1;
	r0.y = r0.x + -r0.y;
	r0.x = (r0.x >= 0) ? 0 : r0.z;
	r0.x = r0.x + r0.y;
	r0.x = (-abs(r0.x) >= 0) ? 1 : 0;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2 = -0.5019608;
	r0.y = r1.w * globalScalars.x + r2.x;
	r0.z = r1.w * globalScalars.x;
	r0.y = r0.y * 20.078741 + -r0.z;
	r0.y = HardAlphaBlend.x * r0.y + r0.z;
	r0.z = r0.y + -0.95;
	r0.y = -r0.y + 0.003921569;
	r0.y = (r0.y >= 0) ? 1 : 0;
	r0.x = (r0.z >= 0) ? 0 : r0.x;
	r0.x = r0.y + r0.x;
	r0 = (-r0.x >= 0) ? -0 : -1;
	clip(r0);
	r0.x = saturate(-1 + i.color.x);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = 0;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.xy = float2(0, 1);
	o.color3 = r0.xxxy * gStencil.x;

	return o;
}
