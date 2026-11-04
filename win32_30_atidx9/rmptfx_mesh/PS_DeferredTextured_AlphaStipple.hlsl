sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c199);
float specularFactor : register(c198);
float4 stipplePattern : register(c62);

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
	float4 r2;
	float3 r3;
	float3 r4;
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
	r2.zw = float2(1, 0);
	r0.w = r2.z + -specularFactor.x;
	r2.x = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r4 = r0.xyz * colorize.xyz + -r2.xxx;
	r4 = gAdrenoFXVars.xxx * r4.xyz + r2.xxx;
	r2.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * -colorize.xyz + r4.xyz;
	r0.xyz = r2.xxx * r0.xyz + r1.xyz;
	r1.x = saturate(-1 + i.color.x);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = specularFactor.x;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r0.w >= 0) ? 0.071428575 : r0.x;
	o.color.w = r1.w;
	o.color1.w = r1.w;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	o.color2.w = r1.w;
	o.color3 = r2.wwwz * gStencil.x;

	return o;
}
