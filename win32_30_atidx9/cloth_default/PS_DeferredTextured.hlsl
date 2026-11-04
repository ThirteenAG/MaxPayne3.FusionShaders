sampler2D DiffuseSampler : register(s0);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
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
	float3 r2;
	float3 r3;
	r0.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = lerp(r0.yyy, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.xxx);
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
	r0.y = saturate(-1 + i.color.x);
	o.color.xyz = r0.yyy * globalScalars2.zzz + r3.xyz;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.xyz = i.color.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.xz = float2(-1, -0);
	o.color3 = -r0.zzzx * gStencil.x;

	return o;
}
