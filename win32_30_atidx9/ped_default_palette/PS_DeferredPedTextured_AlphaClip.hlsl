sampler2D BloodSampler : register(s2);
float4 ColorCorrectTopAndPedReflectScale : register(c43);
sampler2D DiffuseSampler : register(s0);
sampler2D TextureSamplerDiffPal : register(s4);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gBloodData : register(c199);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 matMaterialColorScale : register(c198);
float paletteSelector : register(c200);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	r1.x = r0.w * 255.01;
	r1.y = frac(r1.x);
	r1.x = -r1.y + r1.x;
	r1.y = r1.x + -32;
	r1.x = -r1.x + 160;
	r3.x = r1.y * 0.0078125;
	r3.y = paletteSelector.x;
	r3 = tex2D(TextureSamplerDiffPal, r3.xy);
	r4.xyz = lerp(r0.xyz, r3.xyz, r3.www);
	r1.x = (r1.x >= 0) ? -1 : -0;
	r1.x = (r1.y >= 0) ? r1.x : -0;
	r4.w = 1;
	r0 = (r1.x >= 0) ? r0 : r4;
	r1.yzw = float3(-1, -0, 1);
	if (-gBloodData.w < -r1.z) {
		r3 = tex2D(BloodSampler, i.texcoord.zw);
		r4.z = min(r3.y, r3.x);
		r1.x = saturate(r3.x * 0.5 + r3.w);
		r4.xy = r3.xy;
		r2.w = -r0.x + r4.x;
		r2.w = r1.x * r2.w;
		r3.xyz = lerp(r0.xyz, r4.xyz, r1.xxx);
		r1.x = dot(r3.xyz, float3(0.2125, 0.7154, 0.0721));
		r4.xyz = lerp(r1.xxx, r3.xyz, gAdrenoFXVars.yyy);
		r1.x = saturate(r2.w * gAmbientOcclusionEffect.z);
		r0.xyz = lerp(r3.xyz, r4.xyz, r1.xxx);
	}
	r0.w = r0.w * i.texcoord2.w;
	r3.xyz = r0.xyz * matMaterialColorScale.xxx;
	r1.x = dot(r3.xyz, float3(0.2125, 0.7154, 0.0721));
	r4.x = 0.1;
	r2.w = saturate(r4.x + deSatContrastGamma.x);
	r2.w = 1 / r2.w;
	r2.w = r2.w * gAdrenoFXVars.z;
	r0.xyz = r0.xyz * matMaterialColorScale.xxx + -r1.xxx;
	r0.xyz = r2.www * r0.xyz + r1.xxx;
	r4.xyz = saturate(r1.www + -ColorCorrectTopAndPedReflectScale.xyz);
	r4.xyz = r4.xyz * 0.25 + 1;
	r1.x = saturate(gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * r4.xyz + -r3.xyz;
	o.color.xyz = r1.xxx * r0.xyz + r3.xyz;
	o.color2.z = saturate(r1.x + i.texcoord2.x);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = r0.w * globalScalars.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color3 = -r1.zzzy * gStencil.x;

	return o;
}
