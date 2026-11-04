sampler2D TextureGrassSampler : register(s1);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
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
	float3 r2;
	r0.x = i.texcoord1.w;
	r0.y = i.texcoord2.w;
	r0 = tex2D(TextureGrassSampler, r0.xy);
	r1.xyz = i.texcoord.xyz;
	r1.xyz = r0.xyz * -r1.xyz + i.texcoord3.xyz;
	r0 = r0 * i.texcoord;
	r0.xyz = i.texcoord3.www * r1.xyz + r0.xyz;
	r1.yw = float2(-1, -0);
	r1.x = saturate(r1.y + gAmbientOcclusionEffect.y);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r2 = normalize(r0.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	o.color2.z = gAmbientOcclusionEffect.w * gAmbientOcclusionEffect.y;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.xyw = r0.www * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color3 = -r1.wwwy * gStencil.x;

	return o;
}
