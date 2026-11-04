sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c199);
float specularFactor : register(c198);

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
	r1.x = saturate(-1 + i.color.x);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r1.w = 0.0051020407;
	r0.x = saturate(r1.w * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.y = 1;
	r0.y = r0.y + -specularFactor.x;
	o.color2.y = (r0.y >= 0) ? 0.071428575 : r0.x;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.w = r0.w;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	r0.yz = float2(0, 1);
	o.color3 = r0.yyyz * gStencil.x;

	return o;
}
