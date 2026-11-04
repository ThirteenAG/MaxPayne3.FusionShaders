float4 ColorCorrectTopAndPedReflectScale : register(c43);
sampler2D DiffuseSampler : register(s0);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
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
	r0.xy = float2(0.1, 1);
	r0.yzw = saturate(r0.yyy + -ColorCorrectTopAndPedReflectScale.xyz);
	r0.yzw = r0.yzw * 0.25 + 1;
	r0.x = saturate(r0.x + deSatContrastGamma.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * gAdrenoFXVars.z;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2.xyz = r1.xyz * matMaterialColorScale.xxx;
	r2.w = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.xyz = r1.xyz * matMaterialColorScale.xxx + -r2.www;
	r1.w = r1.w * i.texcoord2.w;
	r1.w = r1.w * globalScalars.x;
	r1.xyz = r0.xxx * r1.xyz + r2.www;
	r0.xyz = r1.xyz * r0.yzw + -r2.xyz;
	r0.w = saturate(gAmbientOcclusionEffect.z);
	o.color.xyz = r0.www * r0.xyz + r2.xyz;
	o.color2.z = saturate(r0.w + i.texcoord2.x);
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color.w = r1.w;
	o.color1.w = r1.w;
	o.color2.xyw = r1.www * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.xy = float2(0, 1);
	o.color3 = r0.xxxy * gStencil.x;

	return o;
}
