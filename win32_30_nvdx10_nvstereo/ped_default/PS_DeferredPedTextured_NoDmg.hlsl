sampler2D DiffuseSampler : register(s0);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 matMaterialColorScale : register(c198);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
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
	float3 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xyz * matMaterialColorScale.xxx;
	r0.x = r0.w * i.texcoord2.w;
	r0.x = r0.x * globalScalars.x;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1 = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = saturate(gAmbientOcclusionEffect.z);
	r0.y = saturate(r0.y + i.texcoord2.x);
	o.color2.z = r0.y * gAmbientOcclusionEffect.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.zw = float2(0, 1);
	o.color3 = r0.zzzw * gStencil.x;

	return o;
}
