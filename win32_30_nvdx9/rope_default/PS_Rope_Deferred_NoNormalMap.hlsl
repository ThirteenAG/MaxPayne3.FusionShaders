sampler2D DiffuseSampler : register(s0);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

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

	float3 r0;
	float4 r1;
	r0.x = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
	r1.xyz = normalize(i.texcoord1.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r1.xw = float2(1, 0.0051020407);
	r0.y = saturate(r1.w * specularFactor.x);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.z = r1.x + -specularFactor.x;
	o.color2.y = (r0.z >= 0) ? 0.26726124 : r0.y;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.x = specularColorFactor.x;
	r0.yz = float2(0, 1);
	o.color3 = r0.yyyz * gStencil.x;

	return o;
}
