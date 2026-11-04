sampler2D DiffuseSampler : register(s0);
sampler2D TextureSamplerDiffPal : register(s4);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 matMaterialColorScale : register(c198);
float paletteSelector : register(c200);

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
	float4 r1;
	float4 r2;
	float4 r3;
	r0.y = paletteSelector.x;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.z = r1.w * 255.01;
	r0.w = frac(r0.z);
	r0.z = -r0.w + r0.z;
	r0.w = r0.z + -32;
	r0.z = -r0.z + 160;
	r0.z = (r0.z >= 0) ? -1 : -0;
	r0.z = (r0.w >= 0) ? r0.z : -0;
	r0.x = r0.w * 0.0078125;
	r2 = tex2D(TextureSamplerDiffPal, r0.xy);
	r3.xyz = lerp(r1.xyz, r2.xyz, r2.www);
	r3.w = 1;
	r0 = (r0.z >= 0) ? r1 : r3;
	o.color.xyz = r0.xyz * matMaterialColorScale.xxx;
	r0.x = r0.w * i.texcoord2.w;
	r0.x = r0.x * globalScalars.x;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = saturate(gAmbientOcclusionEffect.z);
	r0.y = saturate(r0.y + i.texcoord2.x);
	o.color2.z = r0.y * gAmbientOcclusionEffect.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.yz = float2(-1, -0);
	o.color3 = -r0.zzzy * gStencil.x;

	return o;
}
