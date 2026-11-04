sampler2D DiffuseSampler : register(s0);
float3 ambientDecalMask : register(c198);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
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

	float2 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = lerp(r0.yyy, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.xxx);
	r0.x = r1.w * i.color.w;
	r0.y = dot(r3.xyz, ambientDecalMask.xyz);
	r0.y = saturate(-r0.y + 1);
	r0.x = r0.x * r0.y;
	r0.x = r0.x * globalScalars.x;
	o.color2.w = r0.x * gAmbientOcclusionEffect.x;
	o.color = 0;
	o.color1 = 0;
	o.color2.xyz = 0;
	o.color3 = 0;

	return o;
}
