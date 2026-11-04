sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s1);
sampler2D TextureSampler_layer2 : register(s2);
sampler2D TextureSampler_layer3 : register(s3);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord5 : TEXCOORD5;
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
	r0 = tex2D(TextureSampler_layer0, i.texcoord.xy);
	r1 = tex2D(TextureSampler_layer1, i.texcoord.zw);
	r0.w = r1.w * i.texcoord5.y;
	r2 = lerp(r0.xyz, r1.xyz, r0.www);
	r0 = tex2D(TextureSampler_layer2, i.texcoord1.xy);
	r0.w = r0.w * i.texcoord5.z;
	r1.xyz = lerp(r2.xyz, r0.xyz, r0.www);
	r0 = tex2D(TextureSampler_layer3, i.texcoord1.zw);
	r0.w = r0.w * i.texcoord5.w;
	r2 = lerp(r1.xyz, r0.xyz, r0.www);
	r0.x = saturate(-1 + i.texcoord6.w);
	r0.x = r0.x * globalScalars2.z;
	o.color.xyz = r2.xyz * i.texcoord6.xyz + r0.xxx;
	o.color.w = 0;
	o.color1.xyz = i.texcoord3.xyz * 0.5 + 0.5;
	o.color1.w = globalScalars.x;
	o.color2.xyz = i.texcoord6.www * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color2.w = globalScalars.x;
	r0.xy = float2(-1, 0);
	o.color3 = abs(r0.yyyx) * gStencil.x;

	return o;
}
