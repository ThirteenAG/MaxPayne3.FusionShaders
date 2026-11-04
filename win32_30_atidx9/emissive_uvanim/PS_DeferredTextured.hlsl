sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAdrenoFXVars : register(c68);
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
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r0 * colorize;
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = r0.xyz * colorize.xyz + -r0.www;
	r2 = gAdrenoFXVars.xxx * r2.xyz + r0.www;
	r0.xyz = r0.xyz * -colorize.xyz + r2.xyz;
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.www * r0.xyz + r1.xyz;
	r0.w = r1.w * i.color.w;
	r0.w = r0.w * globalScalars.x;
	r1.xzw = float3(-1, -0, -0.25);
	r1.y = saturate(r1.x + globalScalars.z);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r0.xyz;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r2 = normalize(r0.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.w = r0.w;
	o.color2.xyz = globalScalars.zzz * -r1.zzx + -r1.zwz;
	o.color3 = -r1.zzzx * gStencil.x;

	return o;
}
