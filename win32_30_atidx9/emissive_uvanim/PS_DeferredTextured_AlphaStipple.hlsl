sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float2 vpos : VPOS;
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
	float4 r2;
	float3 r3;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r0 * colorize;
	r0.w = r1.w * i.color.w;
	r1.w = r0.w * globalScalars.x;
	r2.xy = 0.5 * i.vpos.xy;
	r2.xy = frac(abs(r2.xy));
	r2.xy = (i.vpos.xy >= 0) ? r2.xy : -r2.xy;
	r2.xy = r2.xy + r2.xy;
	r2.zw = frac(r2.xy);
	r2.xy = -r2.zw + r2.xy;
	r2.x = r2.y * 2 + r2.x;
	r2 = r2.x + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r2.x = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r2.x;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r2.xyz = 1E-05 + i.texcoord1.xyz;
	r3 = normalize(r2.xyz);
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xyz = r0.xyz * colorize.xyz + -r0.www;
	r2.xyz = gAdrenoFXVars.xxx * r2.xyz + r0.www;
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * -colorize.xyz + r2.xyz;
	r0.xyz = r0.www * r0.xyz + r1.xyz;
	r2.zw = float2(1, 0);
	r0.w = saturate(-r2.z + globalScalars.z);
	o.color.xyz = r0.www * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	o.color.w = r1.w;
	o.color1.w = r1.w;
	r0.z = globalScalars.z;
	o.color2.xyz = r0.zzz * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color2.w = r1.w;
	o.color3 = r2.wwwz * gStencil.x;

	return o;
}
